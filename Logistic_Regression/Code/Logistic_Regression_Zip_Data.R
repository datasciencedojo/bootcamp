###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on hand-written digits recognition with logistic regression model. In this task, we just do the binary classification between digits '2' and '3'.
## Data source: zip.train.csv  and zip.test.csv   
## at: https://github.com/datasciencedojo/bootcamp/tree/master/Datasets/Zip
## Needs lattice package -> Run "install.packages('lattice')"
###################################################################################

## DATA EXPLORATION
## import both zip.train and zip.test to R 
## Be sure that you set working dirctory to root bootcamp folder
zip.train <- read.csv("Datasets/Zip/zip.train.csv", header=FALSE)
zip.test <- read.csv("Datasets/Zip/zip.test.csv", header=FALSE)
## check dataset dimensions
dim(zip.train)
dim(zip.test)
## check the first few lines of zip.train dataset 
## V1 represents the number, V2 -> V257 are the gray levels of all pixels
head(zip.train)
## visualize data
library(lattice)
levelplot(matrix(zip.train[5,2:257],nrow=16, byrow=TRUE))

## BUILD MODEL
## retain the rows with labels "2" and "3" in training and testing datasets
zip.train <- subset(zip.train, zip.train$V1==2 | zip.train$V1==3)
zip.test <- subset(zip.test, zip.test$V1==2 | zip.test$V1==3)
## convert V1 (response) to factor for the training & testing datasets
zip.train[,1] <- as.factor(zip.train[,1])
zip.test[,1] <- as.factor(zip.test[,1])
## fit a logistic regression model with the training dataset
zip.glm.model <- glm(formula=V1 ~ ., data=zip.train, family = "binomial", maxit=200)
### extract logistic regression model summary
summary(zip.glm.model)

## MODEL EVALUATION
## to predict using logistic regression model, probablilities obtained
zip.glm.predictions <- predict(zip.glm.model, zip.test, type="response")
## Look at probability output
head(zip.glm.predictions)
## assign labels with decision rule, >0.5= "2", <0.5="3"
zip.glm.predictions.rd <- ifelse(zip.glm.predictions >= 0.5, "3", "2")
## calculate the confusion matrix
zip.glm.confusion <- table(zip.glm.predictions.rd, zip.test[,1])
print(zip.glm.confusion)
## calculate the accuracy, precision, recall, F1
zip.glm.accuracy <- sum(diag(zip.glm.confusion)) / sum(zip.glm.confusion)
print(zip.glm.accuracy)

zip.glm.precision <- zip.glm.confusion[2,2] / sum(zip.glm.confusion[2,])
print(zip.glm.precision)

zip.glm.recall <- zip.glm.confusion[2,2] / sum(zip.glm.confusion[,2])
print(zip.glm.recall)

zip.glm.F1 <- 2 * zip.glm.precision * zip.glm.recall / (zip.glm.precision + zip.glm.recall)
print(zip.glm.F1)

## extract out a row with a wrong prediction using the 50% threshold
zip.glm.prediction.matrix <- cbind(zip.glm.predictions, zip.test[,1])
zip.glm.prediction.wrong <- subset(zip.glm.prediction.matrix, zip.test[,1] != zip.glm.predictions)
print(zip.glm.prediction.wrong)

## visualize one of the wrong prediction from logistic regression
levelplot(matrix(zip.test[161,2:257],nrow=16, byrow=TRUE))

## EXERCISE
## Besides confusion matrix, and error, another important evaluation method for classification 
## models is the area under the ROC curve. 
## The ROC (Receiver Operating Characteristic) curve shows how true and false positive rates
## vary with threshold. 
## The Wikipedia page (http://en.wikipedia.org/wiki/Receiver_operating_characteristic) has more details.
## Now, let us plot the ROC curve for the above model. To do this you need:
## 1. Download, load the pROC package by install.packages("pROC")
## 2. Check out the examples of roc() function in http://www.inside-r.org/packages/cran/pROC/docs/pROC. Plot the ROC curve.
## 3. The data you may want to use in roc() are:
## zip.test[,1]
## and
## zip.glm.prediction
## 4. You can use the auc() function to calculate the area under the ROC curve, can you improve
##    this metric by varying model parameters? See ?glm and ?glm.control for information about
##    varying parameters for glm models

## EXERCISE
## This zip classification problem is already solved in our Linear Regression session. 
## But in this sample code, logistic regression is used for this classification problem. 
## And it gives us slightly worse result (with more error)! 
## What this tells us is: whenever a machine learning problem comes, choose algorithms by thinking 
## about their principle, instead of the names! 
## (I am not saying linear regression is better for this case, since the performance of logistic regression may be improved by fine-tuning the parameters.)
## Compare linear regression, and logistic regression. 
## What are the differences and similarities?

