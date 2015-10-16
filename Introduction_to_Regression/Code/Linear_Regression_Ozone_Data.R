###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on ozone prediction with linear regression model
## Data source: ozone data set (at https://github.com/datasciencedojo/bootcamp/tree/master/Datasets)
## Please install "miscTools" package: install.packages("miscTools")
###################################################################################

## DATA EXPLORATION
## load the library
library(miscTools)
## load the ozone data to R
## make sure your working directory is set to the bootcamp base folder
ozone.data <- read.table("Datasets/Ozone/ozone.data", header=T)
str(ozone.data)
## visualize the data
plot(ozone.data)

## BUILD MODEL
## randomly choose 70% of the data set as training data
set.seed(27)
ozone.train.indices <- sample(1:nrow(ozone.data), 0.7*nrow(ozone.data), replace=F)
ozone.train <- ozone.data[ozone.train.indices,]
dim(ozone.train)
## Use the remaining 30% as testing data
ozone.test <- ozone.data[-ozone.train.indices,]
dim(ozone.test)
## You could also do the following
#ozone.test.indices <- setdiff(1:nrow(ozone.data),random.rows.train)
#ozone.test <- ozone.data[ozone.test.indices,]

## fitting decision model on training set 
ozone.lm.model <- lm(ozone ~ ., data=ozone.train)
summary(ozone.lm.model)

## VISUALIZE THE TRAINED MODEL
layout(matrix(c(1,2,3,4),2,2)) # set 4 graphs/page 
plot(ozone.lm.model)

## MODEL EVALUATION
## make prediction using trained model
ozone.lm.predictions <- predict(ozone.lm.model, ozone.test)
par(mfrow=c(3,1))
plot(ozone.test$ozone, ozone.lm.predictions)
## calculate residuals
ozone.lm.residuals <- ozone.test$ozone - ozone.lm.predictions
plot(ozone.test$ozone, ozone.lm.residuals)
plot(ozone.lm.predictions, ozone.lm.residuals)
## calculate Root Mean Squared Error (RMSE)
ozone.lm.rmse <- sqrt(mean(ozone.lm.residuals^2))
print(ozone.lm.rmse)
## calculate Mean Absolute Error (MAE)
ozone.lm.mae <- mean(abs(ozone.lm.residuals))
print(ozone.lm.mae)
## R squared (coefficient of determination)
ozone.lm.r2 <- rSquared(ozone.lm.predictions, ozone.lm.residuals)
print(ozone.lm.r2)

## Exercise:
## Try dropping some of the predictor columns and rerunning the model. 
## How can you estimate variable importance via this brute force method? 
## What variable is most important? least important?