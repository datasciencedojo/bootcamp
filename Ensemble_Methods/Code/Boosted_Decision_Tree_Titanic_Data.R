###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of Titanic data's survival classification with ensemble methods (random forest and boosted decision tree)
## Data source: Titanic data set
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Ensemble_Methods
## Please install "bst" package: install.packages("bst")
###################################################################################

## load the library
library(bst)

## DATA EXPLORATION AND CLEANING
## load the iris data in R
titanic.data <- read.csv("../Data/Titanic_train.csv", header=TRUE)
## explore the data set
dim(titanic.data)
str(titanic.data)
summary(titanic.data)
## ignore the PassengerID, Name, Ticket, and Cabin
titanic.data <- titanic.data[, -c(1, 4, 9, 11)]
## replace all 0 in Survived to -1, to consistent with the bst library
titanic.data[titanic.data$Survived == 0, "Survived"] <- -1
## there are some NAs in Age, fill it with the median value
titanic.data$Age[is.na(titanic.data$Age)] = median(titanic.data$Age, na.rm=TRUE)

## BUILD MODEL
## randomly choose 80% of the data set as training data
random.rows.train <- sample(1:nrow(titanic.data), 0.8*nrow(titanic.data), replace=F)
titanic.train <- titanic.data[random.rows.train,]
dim(titanic.train)
## select the other 20% as the testing data
random.rows.test <- setdiff(1:nrow(titanic.data),random.rows.train)
titanic.test <- titanic.data[random.rows.test,]
dim(titanic.test)
## fitting decision model on training set
titanic.model <- bst(titanic.train[,2:8], titanic.train$Survived, learner = "tree")
titanic.model
# control.tree = list(maxdepth = 1)

## MODEL EVALUATION
## to predict using logistic regression model, probablilities obtained
titanic.test.predictions <- predict(titanic.model, titanic.test, type="class")
## extract out the observation for titanic.testing dataset
titanic.test.observations <- titanic.test[,1]
## show the confusion table
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

## EXERCISE
## In the function of bst(), one parameter
## control.tree = list(maxdepth = 1)
## can control the maximum depth of any node of the final tree, with the root node counted as depth 0. The default value is 1. If we increaseing the value of maxdepth leads to a better model?
## Try it by yourself, and think about the reason why this leads to better or worse model.
## bst library's mannual: http://cran.r-project.org/web/packages/bst/bst.pdf

