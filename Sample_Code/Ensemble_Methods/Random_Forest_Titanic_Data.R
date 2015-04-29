###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of Titanic data's survival classification with ensemble methods (random forest and boosted decision tree)
## Data source: Titanic data set
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Ensemble_Methods
## Please install "randomForest" package: install.packages("randomForest")
###################################################################################

## load the rpart library
library(randomForest)

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
titanic.model <- randomForest(Survived~., data=titanic.train, importance=TRUE, ntree=500)
titanic.model

## MODEL EVALUATION
## to predict using logistic regression model, probablilities obtained
titanic.test.predictions <- predict(titanic.model, titanic.test, type="response")
## extract out the observation for titanic.testing dataset
titanic.test.observations <- titanic.test[,1]
## show the confusion table
confusion.matrix <- table(titanic.test.predictions, titanic.test.observations)
confusion.matrix
## calculate the error in testing set
error <- (confusion.matrix[1, 2] + confusion.matrix[2, 1]) / sum(confusion.matrix)
error
## show the importance of variables
importance(titanic.model)
varImpPlot(titanic.model)

## EXERCISE
## Random forest has its build-in function of feature selection. varImpPlot() function helps us visualize the importance of all features in the random forest model. Check the importance of all features, remove the lest important one and re-build this model. Would it have similar performance? If so, continue to remove the (newer) lest important feature and re-build the model again, until the model has much worse performance as the original one. Imaging you are dealing much larger data than this Titanic data set, then memory and calculating speed are something that you concern about. In such situation, what are the features you will use in the model?
