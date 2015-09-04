###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on hand-written digits recognition with linear regression model. In this task, we just do the binary classification between digits '2' and '3'.
## Data source: zip.train.csv  
##	        zip.test.csv   
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Datasets/Zip
###################################################################################

## DATA EXPLORATION
## import both zip.train and zip.test to R (set working dirctory to root bootcamp folder)
zip.train <- read.csv("Datasets/Zip/zip.train.csv", header=FALSE)
zip.test <- read.csv("Datasets/Zip/zip.test.csv", header=FALSE)
## check for dataset dimension
dim(zip.train)
dim(zip.test)
## check the first few lines of zip.train dataset (in a certain row, V1 represents the number, V2 -> V257 are the gray levels of all pixels)
head(zip.train)
## visualize data
library(lattice)
levelplot(matrix(zip.train[5,2:257],nrow=16, byrow=TRUE))

## BUILD MODEL
## retain the rows with labels "2" and "3" in training and testing datasets
zip.train <- subset(zip.train,zip.train$V1==2 | zip.train$V1==3)
zip.test <- subset(zip.test,zip.test$V1==2 | zip.test$V1==3)
## build linear regression model with log.zip.training dataset
zip.lm.model <- lm(V1 ~ ., data=zip.train)
## explore the model
print(zip.lm.model)
summary(zip.lm.model)
head(zip.lm.model$coefficients)
head(zip.lm.model$fitted.values)
head(zip.lm.model$residuals)

## MODEL EVALUATION
## To predict using linear regression model (round the number as the response)
zip.lm.predictions <- predict(zip.model.lm, zip.test)
zip.lm.predictions.rd <- ifelse(zip.lm.predictions >= 2.5, 3, 2)

## count the number of wrong predictions from test set
zip.lm.error.count<-sum(ifelse(zip.test[,1]==zip.lm.predictions.rd,0,1))
print(zip.lm.error.count)

## Calculate residuals (should we use the rounded predictions or the unrounded predictions? why?)
zip.lm.residuals <- zip.test[,1] - zip.lm.predictions
## calculate Root Mean Squared Error (RMSE)
zip.lm.rmse <- sqrt(mean(zip.test.lm.residuals^2))
print(zip.lm.rmse)
## calculate Mean Absolute Error (MAE)
zip.lm.mae <- mean(abs(zip.test.lm.residuals))
print(zip.lm.mae)
## build the confusion matrix
zip.lm.confusion <- table(zip.test.lm.predictions.rd, zip.test.observations)
print(zip.lm.confusion)
## calculate the accuracy, precision, recall, and F1 for our predictions
zip.lm.accuracy <- sum(diag(zip.lm.confusion)) / sum(zip.lm.confusion)
print(zip.lm.accuracy)

zip.lm.precision <- zip.lm.confusion[2,2] / sum(zip.lm.confusion[2,])
print(ozone.lm.precision)

zip.lm.recall <- zip.lm.confusion[2,2] / sum(zip.lm.confusion[,2])
print(zip.lm.recall)

zip.lm.F1 <- 2 * zip.lm.precision * zip.lm.recall / (zip.lm.precision + zip.lm.recall)
print(zip.lm.F1)

## Exercise:
## Try varying the threshold for rounding the predictions to numbers. How does this change
## the accuracy, precision, recall, and F1?
## Install and import the "AUC" library and use the roc and auc functions to calculate the
## area under the receiver curve if we interpret (prediction - 2) as the probability of a test
## object being a 3.
## Use ?roc and ?auc after importing the library to see the documentation for the functions