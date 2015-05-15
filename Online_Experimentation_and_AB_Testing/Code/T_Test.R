###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Illustrate two-sample t-test through a simple example
###################################################################################

###################################################################################
## During the bootcamp's lecture "Online Experimentation and AB Testing", we
## already understood the concept of hypothesis test. In a real-world AB testing
## experiement, data scientists usually approximate the distribution of a certain
## metric (like dwell time of web pages, revenue, etc.) by t-distribution.
## T-distribution is a generalized version of normal distribution with freedom.
## (See wikipedia page: http://en.wikipedia.org/wiki/Student%27s_t-distribution.)
## 
## After this approximation, what we want to do is to compare the metric quantity's
## means in control and treatment groups before coming to the conclusion.
## This step is also called two-sample t-test for equal means.
## The mathematical procedure of this important step of AB test is well explained
## in one of National Information Technology Laboratory (NITL)'s web pages at:
## http://www.itl.nist.gov/div898/handbook/eda/section3/eda353.htm.
##
## What this sample code trying to do is to guide students to implement t-test and
## relevant analysis using R.
###################################################################################

###################################################################################
## Example:
## There are two groups of students (8 at each group). And each student has a score
## of a certain test.
## In group A, students slep for 8 hours at the night before test
## In group B, students slep for 4 hours at the night before test
## The data test scores are as following:
## | Group A | 5 | 7 | 5 | 3 | 5 | 3 | 3 | 9 |
## |---------+---+---+---+---+---+---+---+---|
## | Group B | 8 | 1 | 4 | 6 | 6 | 4 | 1 | 2 |
## The goal of the hypothesis test is to confirm if the students' scores are
## different between the 8 hours sleep and 4 hours sleep groups.
###################################################################################

###################################################################################
## Question 1: Input the above data into R, what are the mean and standard
## deviation of test scores in group A and B?
###################################################################################

###################################################################################
## Question 2: What would be the null and alternative hypothesis in this study?
###################################################################################

###################################################################################
## Question 3: What significance level did you choose and why?
###################################################################################

###################################################################################
## Question 4: What is the t-score of this t test?
## (You may want to use the function t.test, make sure the alternative and
## conf.level parameters in this function are assighted with correct values.)
###################################################################################

###################################################################################
## Question 5: Is there a significant difference between the two groups?
## Interpret your answer.
###################################################################################

###################################################################################
## Question 6: If you have made an error, would it be a Type I or a Type II error? ## Explain your answer.
###################################################################################
