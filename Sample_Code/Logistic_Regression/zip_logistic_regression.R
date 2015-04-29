###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on hand-written digits recognition with logistic regression model. In this task, we just do the binary classification between digits '2' and '3'.
## Data source: zip.train.csv  
##	        zip.test.csv   
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Logistic_Regression/Zip
###################################################################################

## DATA EXPLORATION
## import both zip.train and zip.test to R (set working dirctory to be the same one of Ozone data folder)
zip.train <- read.csv("Zip/zip.train.csv", header=FALSE)
zip.test <- read.csv("Zip/zip.test.csv", header=FALSE)
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
## convert V1 (response) to factor for the training/testing datasets
zip.train[,1] <- as.factor(zip.train[,1])
zip.test[,1] <- as.factor(zip.test[,1])
## build logistic regression model with log.zip.training dataset
zip.model <- glm(formula=V1 ~ ., data=zip.train, family = "binomial", maxit=200)
### extract logistic regression model summary
zip.model

## MODEL EVALUATION
## to predict using logistic regression model, probablilities obtained
zip.pred.prob <- predict(zip.model, zip.test, type="response")
## visualize partial prediction output (the probabilities)
head(zip.pred.prob)
## assign labels with decision rule, >0.5= "2", <0.5="3"
zip.pred <- ifelse(zip.pred.prob >= 0.5, "3", "2")
## extract out true label for zip.testing dataset
zip.obs <- as.character(zip.test[,1])
## show the confusion table
confusion.matrix <- table(zip.pred, zip.obs)
confusion.matrix
## extract out the row that has wrong prediction
error.pred <- subset(zip.pred.table, zip.obs != zip.pred)
error.pred
## visualize error prediction from both linear and logistic regression
levelplot(matrix(zip.test[280,2:257],nrow=16, byrow=TRUE))





