###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015
## 
## Objective: Understand AB Testing by two simple examples
## Data source:
## Dwell_Time_VersionA.csv and Dwell_Time_VersionB.csv at:
## https://github.com/datasciencedojo/bootcamp/tree/master/Online_Experimentation_and_AB_Testing
## Please install "ggplot2" package: install.packages("ggplot2")
###################################################################################

###################################################################################
## 1. AB Test of Proportions
## 
## Basic concepts:
##
## Conversion rate -- In electronic commerce, The conversion rate is the proportion
## of visitors to a website who take action to go beyond a casual content view or
## website visit, as a result of subtle or direct requests from marketers, 
## advertisers, and content creators. With the formula:
## Conversion rate = Number of Goal Achievements / Visitors
## Successful conversions are defined differently by individual marketers,
## advertisers, and content creators.
## Check out the wikipedia page http://en.wikipedia.org/wiki/Conversion_marketing
## for more details of conversion rate and conversion marketing.
##
## Significance level (type I error rate) -- the probability of rejecting the null
## hypothesis given that it is true.
## 
## Confidence level = 1 - Significance level
##
## Type II error rate -- when the null hypothesis is false, the possibility that it
## fails to be rejected.
##
## Power: 1 - type II error rate
## 
## Scenario:
## Your team is developing and maintaining a e-comerce website. Last week, You did
## an AB testing last week to compare two version of the webpages (version A & B).
## This week, you are going to analyze the results of last week's AB test. Your
## team has agreed on a conversion rate as the metric.
## Data:
## 1. There are 98,234 visiting times of the website last week. The server showed A
## and B versions with equal times among all the visitings.
## 2. There are 8365 successful conversions in version A, and 8604 successful
## conversions in version B.
## Question:
## Do A and B versions of the website give the website the same
## conversion rate (with significance level = 0.05)?
###################################################################################

## assign some variables
visit.per.group <- 298234/2
success.A <- 8365
success.B <- 8604
conversion.rate.A <- success.A / visit.per.group
conversion.rate.B <- success.B / visit.per.group
## do the hypothesis test of proportion
## H0 (null hypothesis): conversion rates of version A and B are the same
## H1 (alternative hypothesis): conversion rates of version A and B are different
prop.test(x=c(success.A, success.B), n=c(visit.per.group, visit.per.group),
          alternative = "two.sided",
          conf.level = 0.95, correct = TRUE)
## By comparing the p-value of the above results and the significance level 0.05,
## what is your conclusion?

## Your team also want to know the "power" of the above results. Since they want to
## know if the H1 is true, what is the possibility that we can get the correct
## conclusion.
## The power can be obtained using power.prop.test function (see the results of the
## following code)
power.prop.test(n=visit.per.group, p1=conversion.rate.A, p2=conversion.rate.B, sig.level=0.05)

###################################################################################
## 2. AB Test of Means
## Scenario:
## Right now your team ask you another question about how much time customers spent
## on version A and B of the website.
## Question: Is the customers' time spent on page different between the version A
## and B of the websites (with significance level = 0.05)?
###################################################################################
## Navigate the working directory of R to the directory of this sample code and
## data files Dwell_Time_VersionA.csv and Dwell_Time_VersionB.csv
## (These two dwell time data sets are not real one, but the distributions of real
## dwell time data would be similar to them.)
## Load the data
dwell.time.versionA <- read.csv("../Code/Dwell_Time_VersionA.csv")
dwell.time.versionB <- read.csv("../Code/Dwell_Time_VersionB.csv")

## Visualize the data
## Calculate mean and standard deviation (sd) of dwell time on the web pages
meanA <- round(mean(dwell.time.versionA$dwellTime), 2)
sdA <- round(sd(dwell.time.versionA$dwellTime), 2)
meanB <- round(mean(dwell.time.versionB$dwellTime), 2)
sdB <- round(sd(dwell.time.versionB$dwellTime), 2)
mean.sd <- data.frame(mean = c(meanA, meanB), sd = c(sdA, sdB))
row.names(mean.sd) <- c("Version A", "Version B")
mean.sd
## plot the density of dwell time of version A and B
library(ggplot2)
#Sample data
dat <- data.frame(Dwell.Time= c(dwell.time.versionA$dwellTime, dwell.time.versionB$dwellTime), Version = c(rep("version A", visit.per.group), rep("version B", visit.per.group)))
#Plot.
ggplot(dat, aes(x = Dwell.Time, fill = Version)) + geom_density(alpha = 0.5) + ggtitle("Comparison of dwell time densities on web page version A and B")

## Use t.test function to do the test
t.test(dwell.time.versionA$dwellTime, dwell.time.versionB$dwellTime, alterative="two.sided", conf.level=0.95)
## Is the dwell time different between version A and B (with significance level 0.05)?

###################################################################################
## EXERCISE:
## After you finish the above analysis, the engineer in your team notices you that
## 343 of the records in group B with unsuccessful conversion are fake data
## automatically filled by computer. The visiting time in version B is acutually
## 298234/2-343, and there still 8604 successful conversion in version B.
## Then you re-do the analysis of section 1 above, does your conclusion change?
###################################################################################
