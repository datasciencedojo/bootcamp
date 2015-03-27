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

