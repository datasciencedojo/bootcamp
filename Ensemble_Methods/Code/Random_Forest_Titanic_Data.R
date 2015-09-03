###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of Titanic data's survival classification with ensemble methods (random forest and boosted decision tree)
## Data source: Titanic data set
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Datasets
## Please install "randomForest" package: install.packages("randomForest")
###################################################################################

## load the library
library(randomForest)

## DATA EXPLORATION AND CLEANING
## load the Titanic data in R
## Be sure your working directory is set to bootcamp base directory
titanic.data <- read.csv("Datasets/titanic.csv", header=TRUE)
## explore the data set
dim(titanic.data)
str(titanic.data)
summary(titanic.data)

## remove PassengerID, Name, Ticket, and Cabin attributes
titanic.data <- titanic.data[, -c(1, 4, 9, 11)]
## Cast target attribute to factor
titanic.data$Survived <- as.factor(titanic.data$Survived)
levels(titanic.data$Survived) <- c('Dead', 'Alive')
## there are some NAs in Age, fill them with the median value
titanic.data$Age[is.na(titanic.data$Age)] = median(titanic.data$Age, na.rm=TRUE)

## BUILD MODEL
## randomly choose 70% of the data set as training data
set.seed(27)
random.rows.train <- sample(1:nrow(titanic.data), 0.8*nrow(titanic.data), replace=F)
titanic.train <- titanic.data[random.rows.train,]
dim(titanic.train)
summary(titanic.train$Survived)
## select the other 30% as the testing data
random.rows.test <- setdiff(1:nrow(titanic.data),random.rows.train)
titanic.test <- titanic.data[random.rows.test,]
dim(titanic.test)
summary(titanic.test$Survived)
## fitting decision model on training set
titanic.model <- randomForest(Survived~., data=titanic.train, importance=TRUE, ntree=500)
print(titanic.model)

## MODEL EVALUATION
## Predict test set outcomes and report probabilities
titanic.test.predictions <- predict(titanic.model, titanic.test, type="response")
## extract out the observation for titanic.testing dataset
titanic.test.observations <- titanic.test[,1]
## show the confusion matrix
confusion.matrix <- table(titanic.test.predictions, titanic.test.observations)
confusion.matrix
## accuracy
accuracy <- sum(diag(confusion.matrix)) / sum(confusion.matrix)
accuracy
## precision
precision <- confusion.matrix[2,2] / sum(confusion.matrix[2,])
precision
## recall
recall <- confusion.matrix[2,2] / sum(confusion.matrix[,2])
recall
## F1 score
F1.score <- 2 * precision * recall / (precision + recall)
F1.score
## show the importance of variables
importance(titanic.model)
varImpPlot(titanic.model)

## EXERCISE
## Random forest has built-in feature selection.
## varImpPlot() function helps us visualize the importance of the features passed to 
## the model. Look at the importance table/graph, remove the least important predictor
## and re-build this model. Does it have similar performance? 
## If so, iterate, removing the new least important feature and re-building the model,
## until your model has much worse performance than the original one. 
## Imagine you are dealing with a much larger dataset, so memory and calculation time
## are something that you must be concerned about. In such a situation, what are the
## features you would choose to use in production?