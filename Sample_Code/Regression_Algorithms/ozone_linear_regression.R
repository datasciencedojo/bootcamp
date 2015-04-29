###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on ozone prediction with linear regression model
## Data source: ozone data set (at https://github.com/datasciencedojo/bootcamp/tree/master/Regression_Algorithms)
###################################################################################

## DATA EXPLORATION
## load the ozone data to R (set working dirctory to be the same one of Ozone data folder)
ozone.data <- read.table("Ozone/ozone.data", header=T)
str(ozone.data)
## visualize the data
plot(ozone.data)      

## BUILD MODEL
## randomly choose 80% of the data set as training data
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
ozone.pred <- predict(ozone.model, ozone.test)
## define error
error <- ozone.test$ozone - ozone.pred
## calculate Root Mean Squared Error (RMSE)
ozone.rmse <- sqrt(mean(error^2))
ozone.rmse
## calculate Mean Absolute Error (MAE)
ozone.mae <- mean(abs(error))
ozone.mae
