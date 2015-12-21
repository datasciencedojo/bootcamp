###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Predict wine quality with a linear regression model
## Data source: wine quality data set
###################################################################################

library(GGally)

# DATA IMPORT
# Make sure your working directory is set to the bootcamp base folder
# What does sep=";" do?
wine.red <- read.csv("Datasets/Wine_Quality/redwine.csv", header=T, sep=";")
str(wine.red)

# DATA EXPLORATION
# Looking at the whole set is unreasonable, so subset to investigate relationships
# Cast quality to a factor so we get box plots & histograms from ggpairs, 
# then cast back to integer for modeling
wine.red$quality <- as.factor(wine.red$quality)
ggpairs(wine.red[, c(1:4, 12)])
ggpairs(wine.red[, c(5:8, 12)])
ggpairs(wine.red[, 9:12])
wine.red$quality <- as.integer(wine.red$quality)

## BUILD MODEL
## randomly choose 70% of the data set as training data
set.seed(27)
wine.red.train.indices <- sample(1:nrow(wine.red), 0.7*nrow(wine.red), replace=F)
wine.red.train <- wine.red[wine.red.train.indices,]
dim(wine.red.train)
## Use the remaining 30% as testing data
wine.red.test <- wine.red[-wine.red.train.indices,]
dim(wine.red.test)
## You could also do the following
#wine.red.test.indices <- setdiff(1:nrow(wine.red),random.rows.train)
#wine.red.test <- wine.red[wine.red.test.indices,]

## fitting decision model on training set 
wine.red.lm.model <- lm(quality ~ volatile.acidity + residual.sugar + chlorides + total.sulfar.dioxide + suphates + alcohol, data=wine.red.train)
summary(wine.red.lm.model)

## VISUALIZE THE TRAINED MODEL
layout(matrix(c(1,2,3,4),2,2)) # set 4 graphs/page 
plot(wine.red.lm.model)

## MODEL EVALUATION
## make prediction using trained model
wine.red.lm.predictions <- predict(wine.red.lm.model, wine.red.test)
par(mfrow=c(1,1))
plot(wine.red.test$quality, wine.red.lm.predictions)
## calculate residuals
wine.red.lm.residuals <- wine.red.test$quality - wine.red.lm.predictions
plot(wine.red.lm.predictions, wine.red.lm.residuals)
plot(wine.red.test$quality, wine.red.lm.residuals)
## calculate Root Mean Squared Error (RMSE)
wine.red.lm.rmse <- sqrt(mean(wine.red.lm.residuals^2))
print(wine.red.lm.rmse)
## calculate Mean Absolute Error (MAE)
wine.red.lm.mae <- mean(abs(wine.red.lm.residuals))
print(wine.red.lm.mae)
## R squared (coefficient of determination)
wine.red.ss.tot <- sum((wine.red.test$quality - mean(wine.red.test$quality))^2)
wine.red.lm.ss.res <- sum(wine.red.lm.residuals^2)
wine.red.lm.r2 <- 1 - wine.red.lm.ss.res / wine.red.ss.tot
print(wine.red.lm.r2)

## Exercise:
## Try dropping some of the predictor columns and rerunning the model. 
## How can you estimate variable importance via this brute force method? 
## What variable is most important? least important?