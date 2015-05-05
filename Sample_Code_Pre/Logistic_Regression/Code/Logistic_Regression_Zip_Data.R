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
zip.train <- read.csv("../Data/Zip/zip.train.csv", header=FALSE)
zip.test <- read.csv("../Data/Zip/zip.test.csv", header=FALSE)
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
zip.test.predictions.probabilities <- predict(zip.model, zip.test, type="response")
## visualize partial prediction output (the probabilities)
head(zip.test.predictions.probabilities)
## assign labels with decision rule, >0.5= "2", <0.5="3"
zip.test.predictions <- ifelse(zip.test.predictions.probabilities >= 0.5, "3", "2")
## extract out true label for zip.testing dataset
zip.test.observations <- as.character(zip.test[,1])
## show the confusion table
confusion.matrix <- table(zip.test.predictions, zip.test.observations)
confusion.matrix
## calculate the error in testing set
error <- (confusion.matrix[1, 2] + confusion.matrix[2, 1]) / sum(confusion.matrix)
error
## extract out the row that has wrong prediction
zip.predictions.table <- cbind(zip.test.predictions, zip.test.observations)
wrong.predictions <- subset(zip.predictions.table, zip.test.observations != zip.test.predictions)
wrong.predictions
## visualize one of the wrong prediction from logistic regression
levelplot(matrix(zip.test[280,2:257],nrow=16, byrow=TRUE))

## EXERCISE
## Besides confusion matrix, and error, another important evaluation method of logistic regression is ROC curve. ROC curve is the curve of sensitivity as a function of specificity, when the threshold value of possibility increses from 0 to 1. See the Wikipedia page (http://en.wikipedia.org/wiki/Receiver_operating_characteristic) for more detailed introduction.
## Now, let us plot the ROC curve for the above model. To do this you need:
## 1. Download, load the pROC package by install.packages("pROC")
## 2. Check out the examples of roc() function in http://www.inside-r.org/packages/cran/pROC/docs/pROC. Plot the ROC curve.
## 3. The data you may want to use in roc() are:
## zip.test.observations
## and
## zip.test.predictions.probabilities
