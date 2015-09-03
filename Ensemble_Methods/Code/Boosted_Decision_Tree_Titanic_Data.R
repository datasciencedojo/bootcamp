###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of Titanic data's survival classification with ensemble methods (random forest and boosted decision tree)
## Data source: Titanic data set
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Datasets
## Please install "bst" package: install.packages("bst")
###################################################################################

## load the library
library(bst)

## DATA EXPLORATION AND CLEANING
## load the Titanic data in R
## Be sure your working directory is set to bootcamp base directory
titanic.data <- read.csv("Datasets/titanic.csv", header=TRUE)
## explore the data set
dim(titanic.data)
str(titanic.data)
summary(titanic.data)
## ignore the PassengerID, Name, Ticket, and Cabin
titanic.data <- titanic.data[, -c(1, 4, 9, 11)]
## bst requires that binary target classes have the values {-1, 1}
## map 0 -> -1 in Survived column; so 'Dead' is now coded as -1 rather than 0
titanic.data[titanic.data$Survived == 0, "Survived"] <- -1
## there are some NAs in Age, fill with the median value
titanic.data$Age[is.na(titanic.data$Age)] = median(titanic.data$Age, na.rm=TRUE)

## BUILD MODEL
## randomly choose 70% of the data set as training data
set.seed(27)
random.rows.train <- sample(1:nrow(titanic.data), 0.7*nrow(titanic.data), replace=F)
titanic.train <- titanic.data[random.rows.train,]
dim(titanic.train)
summary(titanic.train$Survived)
## select the other 30% as the testing data
random.rows.test <- setdiff(1:nrow(titanic.data),random.rows.train)
titanic.test <- titanic.data[random.rows.test,]
dim(titanic.test)
summary(titanic.test$Survived)
## fitting decision model on training set
## note that bst doesn't take formula variables like previous models
## different models often have different requirements. Look at package manuals,
## or use ? to figure out what a given model requires
titanic.model <- bst(titanic.train[,2:8], titanic.train$Survived, learner = "tree")
#titanic.model <- bst(titanic.train[,2:8], titanic.train$Survived, learner = "tree", control.tree=list(maxdepth=2))
titanic.model

## MODEL EVALUATION
## Predict test set outcomes and report probabilities
titanic.test.predictions <- predict(titanic.model, titanic.test, type="class")
## extract out the observations from the titanic.test dataset
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

## EXERCISE
## In the function of bst(), we can pass a parameter maxdepth to control.tree in the
## bst function to control the maximum depth of any node of the final tree, with the
## root node coded as depth 0. The default value is 1. If we increase the value of
## maxdepth does this lead to a better model?
## Why does changing this parameter lead to better or worse models?
## bst library's mannual: http://cran.r-project.org/web/packages/bst/bst.pdf

