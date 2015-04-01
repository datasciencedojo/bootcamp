---------------------------------------------------------------------------------------------------
-- Return all the contents of the event hub once.
SELECT
    *
INTO
    YourOutput
FROM
    MyEventHubStream
TIMESTAMP BY
    time

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
-- Vertically joining multiple streams and their difference in
-- humidity and temperature
select
    System.timestamp as "WindowEnd"
    , sup.hmdt as SupHmdt, sup.temp as SupTemp
    , bat.hmdt as BatHmdt, bat.temp as BatTemp
    , (sup.hmdt - bat.hmdt) as HmdtDiff
    , (sup.temp - sup.temp) as TempDiff
from superman as sup timestamp by time
join batman as bat timestamp by time
on (datediff(second, sup, bat) between 0 and 1) and sup.time = bat.time
where ((sup.hmdt - bat.hmdt) + (sup.temp - sup.temp)) > 0

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
