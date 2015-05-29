#1.	Which Hive tables are present within this Hadoop cluster?
show tables;

#2. Let’s get information about hivesampletable.
describe hivesampletable;

#3.	Let’s get a preview of our data. Use the “limit” clause 
# at the end of the HiveQL statement. The star tells Hive to 
# grab each rows and limit returns X number of rows at random.
select *
from hivesampletable
limit 100;

#4.	Include “set hive.cli.print.header=true;” to see headers. 
set hive.cli.print.header=true;
select *
from hivesampletable
limit 100;

#5a.Count(*) is the command to count all rows. 
select count(*)
from hivesampletable

# Enable tez to hyper accelerate hive performance
set hive.execution.engine=tez;

#print the first 20 entries where the device maker 
#starts with HTC.
select *
from hivesampletable
where devicemake like "HTC%"
limit 20;

#see the first 20 entries where client dwell time exceeded 
#20 seconds. These people are probably the more interested 
#customers. Let’s isolate them. 
set hive.cli.print.header=true;
select *
from hivesampletable
where querydwelltime > 20;

#3.	What was the average dwell time? Run the following 
#query to find out.
select "average dwell time", avg(querydwelltime)
from hivesampletable;

#4. find the min, max, variance, and sum of the dwell time.
select 
	"max", max(querydwelltime),
	"min", min(querydwelltime),
	"variance", variance(querydwelltime),
	"sum", sum(querydwelltime)
from hivesampletable;

#5. Run the query below to print the 10 largest dwell time
# in descending order.
select clientid, querydwelltime
from hivesampletable
order by querydwelltime desc
limit 10;

#6.	What is the distribution of our devices? Run the 
#following query to find the total devices for each brand. 
set hive.cli.print.header=true;
select devicemake, count(*)
from hivesampletable
group by devicemake;

#7.	The next query renames the queried columns using 
#the “as” clause.
set hive.cli.print.header=true;
select devicemake as device_make, count(*) as device_total
from hivesampletable
group by devicemake;

#8.	Let’s get the frequency counts by devices where dwell 
#times where higher than 20 second. This will filter out 
#the devices that aren’t generating enough engagement. 
set hive.cli.print.header=true;
select devicemake as Device, count(*) as Total
from hivesampletable
where querydwelltime > 20
group by devicemake;

#9.	To focus on the top brands, let’s include those with 
#100 dwell times greater than 20 seconds. Use the “HAVING” 
#clause since the filter occurs after the grouping.
set hive.cli.print.header=true;
select devicemake as Device, count(*) as Total
from hivesampletable
where querydwelltime > 20
group by devicemake
having Total > 100;

#let’s print the previous query in descending order by using 
#the “sort by” clause.  Limit the query to the 7 most engaging 
#brands.
set hive.cli.print.header=true;
select 
	devicemake as Device, 
	count(*) as Total
from hivesampletable
where querydwelltime > 20
group by devicemake
having Total > 100
sort by Total desc
limit 7;