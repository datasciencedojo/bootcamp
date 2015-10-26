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

library(ggplot2)

###################################################################################
## 1. AB Test of Proportions
## 
## Basic concepts:
##
## Conversion rate -- In electronic commerce, The conversion rate is the proportion
## of visitors to a website who take action to beyond a casual content view or
## website visit, as a result of subtle or direct requests from marketers, 
## advertisers, and content creators. The formula is:
## Conversion rate = Number of Goal Achievements / Number of Visitors
## Successful conversions are defined differently by individual marketers,
## advertisers, and content creators.
## Check out the wikipedia page http://en.wikipedia.org/wiki/Conversion_marketing
## for more details of conversion rate and conversion marketing.
##
## Significance level -- the probability of the null hypothesis being true.
## 
## Confidence level = 1 - Significance level -- the probability of the null hypothesis being false
##
## Type 1 error -- Incorrectly rejecting the null hypothesis. Rate is connected to significance level
## Type II error -- Incorrectly accepting the null hypothesis. This is a subtler and harder to
##                  measure error.
##
## Power =  1 - type II error rate -- The probability that we do not incorrectly accept the null hypothesis
## 
## Scenario:
## Your team is developing and maintaining a e-comerce website. Last week, You did
## an AB test to compare two version of the main landing page (versions A & B).
## This week, you are going to analyze the results of last week's AB test. Your
## team has agreed on conversion rate as the metric.
## Data:
## 1. There are 298,234 visiting times of the website last week. The server showed A
## and B versions with equal times among all the visitings.
## 2. There are 8365 successful conversions in version A, and 8604 successful
## conversions in version B.
## Question:
## Do A and B versions of the website give the website the same
## conversion rate? What is the significance level?
###################################################################################

## assign some variables
visits.per.group <- 298234/2
success.A <- 8365
success.B <- 8604
conversion.rate.A <- success.A / visits.per.group
conversion.rate.B <- success.B / visits.per.group
## Perform a proportional hypothesis test
## H0 (null hypothesis): conversion rates of version A and B are the same
## H1 (alternative hypothesis): conversion rates of version A and B are different
proportion.test.results <- prop.test(x=c(success.A, success.B), n=c(visits.per.group, visits.per.group),
          alternative = "two.sided",
          conf.level = 0.95, correct = TRUE)
## Examine the output of the prop.test function.
## If the target p-value is 0.05, what is your conclusion? Do you accept or reject H0?

## Note that this test only tells you whether A & B have different conversion rates, not
## which is larger. In this case, since A & B had the same number of visits, this is easy to 
## determine. However, if you only showed B to 10% of your visitors, you may want to use a
## one-sided test instead. You can investigate the difference by changing the alternative
## argument to either "less" or "greater" for A < B and A > B respectively

## Your team also wants to know the "power" of the above results. Since they want to
## know if H1 is true, what is the possiblity that we accept H0 when H1 is true?
## The power can be obtained using power.prop.test function.
proportion.test.power <- power.prop.test(n=visits.per.group, p1=conversion.rate.A, p2=conversion.rate.B, sig.level=0.05)
print(proportion.test.power)

###################################################################################
## 2. AB Test of Means
## Scenario:
## Your team's manager asks you about dwell time differences between versions A and B
## Question: Is the customers' time spent on page different between version A
## and B of the website?
###################################################################################
## Load the data
## Remember to set your working directory to the bootcamp base folder
dwell.time.versionA <- read.csv("Datasets/Dwell_Time/Dwell_Time_VersionA.csv")
dwell.time.versionB <- read.csv("Datasets/Dwell_Time/Dwell_Time_VersionB.csv")

## Visualize the data
## Calculate mean and standard deviation (sd) of dwell time on the web pages
mean.A <- round(mean(dwell.time.versionA$dwellTime), 2)
sd.A <- round(sd(dwell.time.versionA$dwellTime), 2)
mean.B <- round(mean(dwell.time.versionB$dwellTime), 2)
sd.B <- round(sd(dwell.time.versionB$dwellTime), 2)
mean.sd.AB <- data.frame(mean = c(mean.A, mean.B), sd = c(sd.A, sd.B))
row.names(mean.sd.AB) <- c("Version A", "Version B")
print(mean.sd.AB)
## plot the density of dwell time of version A and B
#Put the sample data into a data frame
dat <- data.frame(Dwell.Time= c(dwell.time.versionA$dwellTime, dwell.time.versionB$dwellTime), Version = c(rep("version A", visits.per.group), rep("version B", visits.per.group)))
#Create a density plot of the dwell times for each version
ggplot(dat, aes(x = Dwell.Time, fill = Version)) + geom_density(alpha = 0.5) + ggtitle("Comparison of dwell time densities on web page version A and B")

## For this question, we use a t-test.
t.test.results <- t.test(dwell.time.versionA$dwellTime, dwell.time.versionB$dwellTime, alterative="two.sided", conf.level=0.95)
## Is the dwell time different between version A and B (with significance level 0.05)?
## What is the power of this conclusion? Use the power.t.test function to find out.

###################################################################################
## EXERCISE:
## After you finish the above analysis, an engineer in your team notifies you that
## 3430 of the records in group B with unsuccessful conversion are fake data
## automatically filled in by computer. The number of visitors for version B is thus
## 298234/2-3430, but there were still 8604 successful conversions for version B.
## Does this revelation change your conclusion from section 1?
###################################################################################
