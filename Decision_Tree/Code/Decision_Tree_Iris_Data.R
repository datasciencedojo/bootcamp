###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of iris species classification with decision tree
## Data source: iris data set (included in R)	
## Please install "rpart" package: install.packages("rpart")
## Please install "party" package: install.packages("party")
###################################################################################

## load the library
library(rpart)

## DATA EXPLORATION
## load the iris data in R
data(iris)
## explore the data set
str(iris)
dim(iris)
summary(iris)

## BUILD MODEL
## randomly choose 70% of the data set as training data
set.seed(27)
random.rows.train <- sample(1:nrow(iris), 0.7*nrow(iris), replace=F)
iris.train <- iris[random.rows.train,]
dim(iris.train)
## select the other 30% left as the testing data
random.rows.test <- setdiff(1:nrow(iris),random.rows.train)
iris.test <- iris[random.rows.test,]
dim(iris.test)
## fitting decision model on training set
iris.model <- rpart(Species~., data = iris.train)

## VISUALIZE THE MODEL
## visualize the tree structure
plot(iris.model)
title(main = "Decision Tree Model of Iris Data")
text(iris.model, use.n = TRUE)
## print the tree structure
summary(iris.model)

## MODEL EVALUATION
## make prediction using decision model
iris.test.predictions <- predict(iris.model, iris.test, type = "class")
## extract out the observations in testing set
iris.test.observations <- iris.test$Species
## show the confusion matrix
confusion.matrix <- table(iris.test.predictions, iris.test.observations)
confusion.matrix
## calculate accuracy, precision, recall, F1 for predictions
accuracy <- sum(diag(confusion.matrix)) / sum(confusion.matrix)
accuracy

precision <- confusion.matrix1[2,2] / sum(confusion.matrix1[2,])
precision

recall <- confusion.matrix1[2,2] / sum(confusion.matrix1[,2])
recall

F1.score <- 2 * precision1 * recall1 / (precision1 + recall1)
F1.score

## EXERCISE
## Another library called "party" can be also used to build decision trees.
## It provides nonparametric regression trees for nominal, ordinal,
## numeric, censored, and multivariate responses. Tree growth is based on statistical 
## stopping rules, so pruning should not be required. 
## party manual: http://cran.r-project.org/web/packages/party/party.pdf or ?party 
## Instead of rpart(), try to use ctree() in "party" for the same data. 
## They implement a different algorithm for building the tree. 
## But for this small iris data, do these different functions (with different algorithms) 
## give us the same tree?
