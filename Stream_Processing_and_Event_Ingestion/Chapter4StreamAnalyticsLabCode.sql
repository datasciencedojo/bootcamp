#The Streamer APP
#http://demos.datasciencedojo.com/app/credit-card-streamer/

#Show me transactions as they happen. Write it to a blob 
#AND powerBI.
SELECT *
INTO MyBlob
FROM SwipeStream TIMESTAMP BY swipe_date;
SELECT *
INTO PowerBI
FROM SwipeStream TIMESTAMP BY swipe_date;

#What was our commission on each transaction?
SELECT 
	transaction_id, 
	merchant_fee / transaction_amount AS Commision
FROM SwipeStream TIMESTAMP BY swipe_date

#Show me only VISA transactions that made over $5 revenue.
SELECT 	
	swipe_date, 
	card_type, 	
	merchant_fee AS revenue
FROM SwipeStream TIMESTAMP BY swipe_date
WHERE card_type LIKE 'VISA' AND merchant_fee < 5

#How many transactions were made for each card type every minute?
SELECT 
	System.Timestamp AS WindowEnd, 
	card_type AS  CardType, 
	Count(*) AS Frequency
FROM SwipeStream TIMESTAMP BY swipe_date
GROUP BY TUMBLINGWINDOW(minute, 3), card_type

#Hoping window
SELECT 
   System.Timestamp AS WindowEnd, 
   card_type AS  CardType, 
   Count(*) AS Frequency
FROM SwipeStream TIMESTAMP BY swipe_date
GROUP BY HoppingWindow(minute, 3, 2), card_type

#Sliding window
SELECT 
	System.Timestamp AS WindowEnd, 
	card_type AS  CardType, 
	Count(*) AS Frequency
FROM SwipeStream TIMESTAMP BY swipe_date
GROUP BY SlidingWindow(minute, 3), card_type
HAVING Frequency > 2

#How much revenue is being accumulated from merchants 
#every 3 minutes?
SELECT 
    System.Timestamp AS WindowEnd, 
    Sum(merchant_fee) AS IntervalRevenue
FROM SwipeStream TIMESTAMP BY swipe_date
GROUP BY TUMBLINGWINDOW(minute, 3), WindowEnd

#Which 3-minute time interval made more than $10?
SELECT 
    System.Timestamp AS WindowEnd, 
    Sum(merchant_fee) AS IntervalRevenue
FROM SwipeStream TIMESTAMP BY swipe_date
GROUP BY TUMBLINGWINDOW(minute, 3), WindowEnd
Having IntervalRevenue > 10

#Generate descriptive statistics for revenue every 3 
#minutes (car count, min, max, average, standard deviation, 
#and total revenue).
SELECT 
	System.Timestamp AS WindowEnd, 
	count(merchant_fee) AS CarCount,
	min(merchant_fee) AS MinRev,
	max(merchant_fee) AS MaxRev,
	avg(merchant_fee) AS AvgRev,
	stdev(merchant_fee) AS VarRev,
	sum(merchant_fee) AS TotalRev
FROM SwipeStream TIMESTAMP BY swipe_date
GROUP BY TUMBLINGWINDOW(minute, 3)

#What is the duration between the first transaction in the 
#window and the last transaction in the window?  What was 
#the duration between the first transaction in the window and 
#the end of the window?
SELECT 
    System.Timestamp AS WindowEnd, 
    count(*) AS Frequency,
    datediff(second, min(swipe_date), 
	max(swipe_date)) AS FirstLastDuration,
	datediff(second, min(swipe_date), System.Timestamp) AS FirstEndDuration
FROM SwipeStream TIMESTAMP BY swipe_date 
GROUP BY TUMBLINGWINDOW(minute, 3)
