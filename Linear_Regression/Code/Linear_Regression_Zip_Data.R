###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on hand-written digits recognition with linear regression model. In this task, we just do the binary classification between digits '2' and '3'.
## Data source: zip.train.csv  
##	        zip.test.csv   
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Datasets/Zip
###################################################################################

## DATA EXPLORATION
## import both zip.train and zip.test to R (set working dirctory to be the same one of Ozone data folder)
zip.train <- read.csv("../../Datasets/Zip/zip.train.csv", header=FALSE)
zip.test <- read.csv("../../Datasets/Zip/zip.test.csv", header=FALSE)
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
zip.model <- lm(formula=V1 ~ ., data=zip.train)
## extract linear regression model summary
zip.model
## explore the model
summary(zip.model)
head(zip.model$coefficients)
head(zip.model$fitted.values)
head(zip.model$residuals)

## MODEL EVALUATION
## To predict using linear regression model (round the number as the response)
zip.test.predictions <- predict(zip.model, zip.test)
zip.test.predictions <- ifelse(zip.test.predictions >= 2.5, 3, 2)
## extract out true label for zip.testing dataset
zip.test.observations <- zip.test[,1]
## define error
error <- zip.test.observations - zip.test.predictions
## calculate Root Mean Squared Error (RMSE)
ozone.rmse <- sqrt(mean(error^2))
ozone.rmse
## calculate Mean Absolute Error (MAE)
ozone.mae <- mean(abs(error))
ozone.mae
## show the confusion table
confusion.matrix <- table(zip.test.predictions, zip.test.observations)
confusion.matrix
## calculate the accuracy in testing set
accuracy <- sum(diag(confusion.matrix)) / sum(confusion.matrix)

## EXERCISE
## This zip classification problem is already solved in our Logistic Regression session. But in this sample code, linear regression is used for this classification problem. And it gives us slightly better result (with less error)! What this tells us is: whenever a machine learning problem comes, choose algorithms by thinking about their principle, instead of the names! (I am not saying linear regression is better for this case, since the performance of logistic regression may be improved by fine-tuning the parameters.)
## Compare linear regression, and linear logistic regression. What are the difference and similarities?
