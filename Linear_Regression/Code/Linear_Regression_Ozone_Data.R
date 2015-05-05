###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on ozone prediction with linear regression model
## Data source: ozone data set (at https://github.com/datasciencedojo/bootcamp/tree/master/Regression_Algorithms)
## Please install "miscTools" package: install.packages("miscTools")
###################################################################################

## DATA EXPLORATION
## load the library
library(miscTools)
## load the ozone data to R (set working dirctory to be the same one of Ozone data folder)
ozone.data <- read.table("../Data/Ozone/ozone.data", header=T)
str(ozone.data)
## visualize the data
plot(ozone.data)      

## BUILD MODEL
## randomly choose 80% of the data set as training data
set.seed(777)
random.rows.train <- sample(1:nrow(ozone.data), 0.8*nrow(ozone.data), replace=F)
ozone.train <- ozone.data[random.rows.train,]
dim(ozone.train)
## select the other 20% as the testing data
random.rows.test <- setdiff(1:nrow(ozone.data),random.rows.train)
ozone.test <- ozone.data[random.rows.test,]
dim(ozone.test)
## fitting decision model on training set 
ozone.model <- lm(ozone~., data=ozone.train)
ozone.model

## VISUALIZE THE MODELS
layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(ozone.model)

## MODEL EVALUATION
## predict using linear regression model
ozone.test.predictions <- predict(ozone.model, ozone.test)
## define error
error <- ozone.test$ozone - ozone.test.predictions
## calculate Root Mean Squared Error (RMSE)
ozone.rmse <- sqrt(mean(error^2))
ozone.rmse
## calculate Mean Absolute Error (MAE)
ozone.mae <- mean(abs(error))
ozone.mae
## R squared (coefficient of determination)
resid <- ozone.test.predictions - ozone.test$ozone
r2 <- rSquared(ozone.test.predictions, resid)
r2

## EXERCISE
## In the MODEL EVALUATION session above, three metrics of the model are shown. They are all important metrics for regression problems. Check their definitions at Wikipedia to make sure you know the idea:
## http://en.wikipedia.org/wiki/Root-mean-square_deviation
## http://en.wikipedia.org/wiki/Mean_absolute_scaled_error
## http://en.wikipedia.org/wiki/Coefficient_of_determination
