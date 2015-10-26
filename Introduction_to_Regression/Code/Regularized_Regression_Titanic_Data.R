###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of Titanic data's survival classification regularized logistic regression
## Data source: Titanic data set
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Datasets
## Please install "glmnet" package: install.packages("glmnet")
## Please install "Metrics" package: install.packages("Metrics")
###################################################################################

## load the library
library(glmnet)
library(Metrics)

## DATA EXPLORATION AND CLEANING
## load the iris data in R
titanic.data <- read.csv("Datasets/titanic.csv", header=TRUE)
## explore the data set
dim(titanic.data)
str(titanic.data)
summary(titanic.data)
## ignore the PassengerID, Name, Ticket, and Cabin; set Survived as a factor
titanic.data <- titanic.data[, -c(1, 4, 9, 11)]
titanic.data$Survived <- as.factor(titanic.data$Survived)
## there are some NAs in Age, fill them with the median value
titanic.data$Age[is.na(titanic.data$Age)] = median(titanic.data$Age, na.rm=TRUE)

## BUILD MODEL
set.seed(27)
## randomly choose 70% of the data set as training data
titanic.train.indices <- sample(1:nrow(titanic.data), 0.7*nrow(titanic.data), replace=F)
titanic.train <- titanic.data[titanic.train.indices,]
dim(titanic.train)
## use the remaining 30% as the testing data
titanic.test <- titanic.data[-titanic.train.indices,]
dim(titanic.test)

## fit a logistic regression model to training set
## glmnet requires a matrix input to the model function. 
## See ?glmnet and ?cv.glmnet for the documentation
## alpha determines the regularization penalty - 1 is lasso, 0 is ridge regression
## glmnet uses cross validation to determine the best lambda value
x.train <- model.matrix(Survived ~ ., data=titanic.train)[,-1] 
titanic.rl.model <- cv.glmnet(x.train, titanic.train$Survived, family="binomial", alpha=1)
print(titanic.rl.model)

## MODEL EVALUATION
## predict test set values, reporting probabilities
x.test <- model.matrix(Survived ~ ., data=titanic.test)[,-1]
titanic.rl.predictions <- predict(titanic.rl.model, newx=x.test, type="response")
## Calculate the AUC
titanic.rl.auc <- auc(titanic.test$Survived, titanic.rl.predictions)
print(titanic.rl.auc)
## assign labels with 50% threshold for survival
titanic.rl.predictions.rd <- ifelse(titanic.rl.predictions >= 0.5, 1, 0)
## calculate the confusion matrix
titanic.rl.confusion <- table(titanic.rl.predictions.rd, titanic.test$Survived)
print(titanic.rl.confusion)
## accuracy
titanic.rl.accuracy <- sum(diag(titanic.rl.confusion)) / sum(titanic.rl.confusion)
print(titanic.rl.accuracy)
## precision
titanic.rl.precision <- titanic.rl.confusion[2,2] / sum(titanic.rl.confusion[2,])
print(titanic.rl.precision)
## recall
titanic.rl.recall <- titanic.rl.confusion[2,2] / sum(titanic.rl.confusion[,2])
print(titanic.rl.recall)
## F1 score
titanic.rl.F1 <- 2 * titanic.rl.precision * titanic.rl.recall / (titanic.rl.precision + titanic.rl.recall)
print(titanic.rl.F1)

## Exercise:
## Experiment with value of alpha, the type of regularization.
## You can also adjust what measure it uses to choose the "best" lambda using a "type.measure"
## argument passed to cv.glmnet. Look at ?cv.glmnet and experiment with different measures.