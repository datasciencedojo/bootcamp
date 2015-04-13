---------------------------------------------------------------------------------------------------
--Return all the contents stored within the Event Hub and all the contents that will ever go 
-- through the event hub.
SELECT
    *
FROM
    MyEventHubStream

-- Return all readings from the stream where humidity was higher than 70.
select *
FROM
    MyInputAlias
Where hmdt > 70

-- Return all readings from streams where the humidity was higher than 70 or the temperature was 
-- higher than 80, indefinitely from the past and future.
select *
FROM
    MyInputAlias
Where hmdt > 70
OR temp > 80

-- Return the average temperature every 3 seconds, from past and future readings indefinitely.
SELECT
    System.Timestamp AS WindowEnd,
    avg(temp) as AverageTemp
INTO
    YourOutput
FROM
    MyEventHubStream
TIMESTAMP BY
    time
GROUP BY
    TumblingWindow(second, 3)

-- Return the average temperature for the past 3 seconds, but open a window up every 1 second, 
-- from past and future readings indefinitely.
SELECT
    System.Timestamp AS WindowEnd,
    avg(temp) as AverageTemp
INTO
    YourOutput
FROM
    MyEventHubStream
TIMESTAMP BY
    time
GROUP BY
    HopingWindow(second, 3, 1)

-- Return descriptive statistics for temperature every 3 seconds from past and future readings
-- indefinitely. Description statistics being 
-- (average, minimum, number of readings, max temperature, and variance).
SELECT
    System.Timestamp AS WindowEnd,
    avg(temp) as AvgTemp,
    min(temp) as MinTemp,
    max(temp) as MaxTemp,
    count(temp) as TempCount,
    var(temp) as TempVariance
INTO
    YourOutput
FROM
    MyEventHubStream
TIMESTAMP BY
    time
GROUP BY
    TumblingWindow(second, 3)

-- Return descriptive statistics for humidity every 3 seconds from past and future readings
-- indefinitely. Description statistics being 
-- (average, minimum, number of readings, max temperature, and standard deviation).
SELECT
    System.Timestamp AS WindowEnd,
    avg(hmdt) as AvgHmdt,
    min(hmdt) as MinHmdt,
    max(hmdt) as MaxHmdt,
    count(hmdt) as HmdtCount,
    var(hmdt) as HmdtVariance
INTO
    YourOutput
FROM
    MyEventHubStream
TIMESTAMP BY
    time
GROUP BY
    TumblingWindow(second, 3)


-- Combine the last two queries about descriptive statistics together into one query.
SELECT
    System.Timestamp AS WindowEnd,
    avg(temp) as AvgTemp,
    min(temp) as MinTemp,
    max(temp) as MaxTemp,
    count(temp) as TempCount,
    var(temp) as TempVariance,
    avg(hmdt) as AvgHmdt,
    min(hmdt) as MinHmdt,
    max(hmdt) as MaxHmdt,
    count(hmdt) as HmdtCount,
    var(hmdt) as HmdtVariance
INTO
    YourOutput
FROM
    MyEventHubStream
TIMESTAMP BY
    time
GROUP BY
    TumblingWindow(second, 3)

--Write a query that returns the min and max time for events inside of 3 
--second tumbling windows and report the difference between the min and max time in seconds.
SELECT
    min(time) as Begining,
    max(time) as Ending,
    datediff( second, min(time), max(time) ) as Difference,
    System.Timestamp as WindowEnd
FROM
    MySensorStream
TIMESTAMP BY 
    time
group by tumblingwindow(second, 3)

-- Return min temperature, max temperature, and the change in temperature between min and max 
-- of 3 second tumbling windows.
SELECT
    System.Timestamp as WindowEnd,
    min(temp) as MinTemp,
    max(temp) as MaxTemp,
    max(temp) - min(temp) as DeltaTemp
FROM
    MyInputAlias Timestamp by time
Group by TumblingWindow(second, 3)

-- Write a query that returns the min and max time for events inside of 3 second tumbling windows
-- and report the difference between the min and max time in seconds. Hint: datediff()
SELECT
    System.Timestamp as WindowEnd,
    min(time) as MinTime,
    max(time) as MaxTime,
    max(time) - min(time) as DeltaTime
FROM
    MyInputAlias Timestamp by time
Group by TumblingWindow(second, 3)

------- Scenarios -------
You own a fleet of dairy delivery trucks whose internal freezer temperatures need to be 
maintained at 22° to 24°. How would you write a query that returns the status update every 5
minutes for freezers who deviated from this range.
SELECT
    System.Timestamp AS WindowEnd,
    dspl AS SensorName,
FROM
    MyInputAlias Timestamp by time
GROUP BY
    TumblingWindow(minute, 5), dspl
HAVING
    avg(temp) < 22 or avg(temp) > 24

-- You’re in charge of 12 temperature and humidity controlled bio-domes in 
-- Eastern Washington that grow pineapples. Pineapples need humidity between 
-- 50% and 70% and temperature between 68°F and 86°F. If temperatures went below
-- 68°F, plant growth will slow. Write a query that would notify you every time 
-- either the humidity or temperature deviated out of the optimal range. 
-- Hint: OR clause. 
SELECT
    System.Timestamp AS WindowEnd,
    dspl AS SensorName,
FROM
    MyInputAlias Timestamp by time
GROUP BY
    TumblingWindow(minute, 5), dspl
HAVING
    avg(hmdt) < 50 
    or avg(hmdt) > 70
    or avg(temp) < 68
    or avg(temp) > 86

-------------------------------------------------------------------------------------------------------------

-- Creates the humidity table
CREATE TABLE humidity(
    WindowEnd DATETIME2,
    Humidity decimal(5,2)
)
-- Creating a clustered index for humidity
IF (NOT EXISTS (SELECT * FROM SYS.INDEXES 
                 WHERE NAME = 'IX_humidity_WindowEnd'))
BEGIN
CREATE CLUSTERED INDEX [IX_humidity_WindowEnd]
    ON [dbo].[humidity]([WindowEnd] ASC);
END

--Open up a hoping window every second and calculate the 
--moving average humidity for the past 3 seconds.
SELECT
    System.Timestamp as WindowEnd,
    avg(hmdt) as Humidity
INTO
    HumidityTable
FROM
    streamsensor
TIMESTAMP BY
    time
Group by 
    HoppingWindow(second, 3, 1);


-- Creates the humidity table
CREATE TABLE sensor(
    WindowEnd DATETIME2,
    Humidity decimal(5,2)
)
-- Creating a clustered index for humidity
IF (NOT EXISTS (SELECT * FROM SYS.INDEXES 
                 WHERE NAME = 'IX_humidity_StartTime'))
BEGIN
CREATE CLUSTERED INDEX [IX_humidity_StartTime]
    ON [dbo].[humidity]([time] ASC);
END

--Open up a hoping window every second and calculate the 
--moving average humidity for the past 3 seconds.
SELECT
    System.Timestamp as WindowEnd,
    avg(hmdt) as Humidity
INTO
    HumidityTable
FROM
    streamsensor
TIMESTAMP BY
    time
Group by 
    HoppingWindow(second, 3, 1);


-------------------------------------------------------------------------------------
-- Room Aggregations
SELECT
    System.timestamp as WindowEnd,
    Dspl as device,
    avg(temp) as temp,
    avg(hmdt) as hmdt
INTO
    DojoEventHub
FROM
    MySensorStream
TIMESTAMP BY
    time
where
    dspl like 'YourSensorTagDsplName'
Group by 
    HoppingWindow(second, 3, 1), dspl
