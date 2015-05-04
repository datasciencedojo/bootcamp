###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of Titanic data's survival classification regularized logistic regression
## Data source: Titanic data set
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Ensemble_Methods
## Please install "glmnet" package: install.packages("glmnet")
## Please install "Metrics" package: install.packages("Metrics")
###################################################################################

## load the library
library(glmnet)

## DATA EXPLORATION AND CLEANING
## load the iris data in R
titanic.data <- read.csv("Titanic_train.csv", header=TRUE)
## explore the data set
dim(titanic.data)
str(titanic.data)
summary(titanic.data)
## ignore the PassengerID, Name, Ticket, and Cabin
titanic.data <- titanic.data[, -c(1, 4, 9, 11, 12)]
titanic.data$Survived <- as.factor(titanic.data$Survived)
## there are some NAs in Age, fill it with the median value
titanic.data$Age[is.na(titanic.data$Age)] = median(titanic.data$Age, na.rm=TRUE)

## BUILD MODEL
## randomly choose 80% of the data set as training data
random.rows.train <- sample(1:nrow(titanic.data), 0.8*nrow(titanic.data), replace=F)
titanic.train <- titanic.data[random.rows.train,]
dim(titanic.train)
## select the other 20% as the testing data
random.rows.test <- setdiff(1:nrow(titanic.data),random.rows.train)
titanic.test <- titanic.data[random.rows.test,]
dim(titanic.test)
## fitting decision model on training set
set.seed(777)
x <- model.matrix(Survived~., data=titanic.train)[,-1]
titanic.model <- glmnet(x, titanic.train$Survived, family="binomial", lambda=0.001)
titanic.model

## MODEL EVALUATION
## to predict using logistic regression model, probablilities obtained
x.test <- model.matrix(Survived~., data=titanic.test)[,-1]
titanic.test.predictions.probabilities <- predict(titanic.model, x.test, type="response")
## extract out the observation for titanic.testing dataset
titanic.test.observations <- titanic.test[,1]
## AUC
library(Metrics)
auc(titanic.test.observations, titanic.test.predictions.probabilities)
## assign labels with decision rule of survival, >0.5= 1, <0.5=0
titanic.test.predictions <- ifelse(titanic.test.predictions.probabilities >= 0.5, 1, 0)
## show the confusion table
confusion.matrix <- table(titanic.test.predictions, titanic.test.observations)
confusion.matrix
## calculate the error in testing set
error <- (confusion.matrix[1, 2] + confusion.matrix[2, 1]) / sum(confusion.matrix)
error

## EXERCISE
## AUC (Area Under Curve of ROC) is a commonly used metric for classification models. It is threshold independent. Check the wikipedia page http://en.wikipedia.org/wiki/Receiver_operating_characteristic#Area_under_curve for more details.
