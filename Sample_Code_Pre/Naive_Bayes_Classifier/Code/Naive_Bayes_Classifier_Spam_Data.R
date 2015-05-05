###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of iris species classification with decision tree
## Data source: spam data set (included in the package "ElemStatLearn")	
## Please install "klaR" package for the naive Bayes algorithm: install.packages("klaR")
## Please install "ElemStatLearn" package for the spam data: install.packages("ElemStatLearn")
###################################################################################

## load the library
library(klaR)

## DATA EXPLORATION
## load the spam data in R
data(spam, package="ElemStatLearn")
## explore the data set
###################################################################################
## This data frame "spam" is the result of a text mining task based on 4601 emails. We want to classify an email to spam or (regular) email, which is the 58th column of the data frame. The 1st to the 54th columns are the frequences of some important words or characters in each email. The 55th to 57th columns are some features relecting the appearance of capital letters in each email.
## A more detailed explanation of these features is explained in the mannual of ElemStatLearn library at: http://cran.r-project.org/web/packages/ElemStatLearn/ElemStatLearn.pdf
###################################################################################
str(spam)
dim(spam)

## BUILD MODEL
## randomly choose 0.7 of the data set as training data
set.seed(777)
random.rows.train <- sample(1:nrow(spam), 0.7*nrow(spam), replace=F)
spam.train <- spam[random.rows.train,]
dim(spam.train)
## select the other 0.3 left as the testing data
random.rows.test <- setdiff(1:nrow(spam),random.rows.train)
spam.test <- spam[random.rows.test,]
dim(spam.test)
## fitting decision model on training set
spam.model <- NaiveBayes(spam ~ ., data=spam.train)

## VISUALIZATION OF THE MODEL (PRIOR PROBABILITIES)
## compare the prior conditional probabilities of each features for spam and regular email (approximated as a normal distribution)
par(mfrow=c(2,4))
plot(spam.model)

## MODEL EVALUATION
## make prediction using decision model
spam.test.predictions <- predict(spam.model, spam.test)
## extract out the observations in testing set
spam.test.observations <- spam.test$spam
## show the confusion matrix
confusion.matrix <- table(spam.test.predictions[["class"]], spam.test.observations)
confusion.matrix
## precision
precision <- confusion.matrix[2,2] / sum(confusion.matrix[2,])
precision
## recall
recall <- confusion.matrix[2,2] / sum(confusion.matrix[,2])
recall
## F1 score
F1.score <- 2 * precision * recall / (precision + recall)
F1.score

## EXERCISE
## This sample code for spam data uses the library "klaR" for naive Beyes inference. Instead of klaR, try to use the library "e1071" as the sample code: Naive_Bayes_Classifier_Iris_Data.R. (Then you need to use the function naiveBayes() in e1071.) Do they give the same results?



