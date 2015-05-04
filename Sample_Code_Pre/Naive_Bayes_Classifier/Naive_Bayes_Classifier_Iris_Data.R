###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of iris species classification with decision tree
## Data source: iris data set (included in R)	
## Please install "rpart" package: install.packages("e1071")
###################################################################################

## load the library
library(e1071)

## DATA EXPLORATION
## load the iris data in R
data(iris)
## explore the data set
str(iris)
dim(iris)

## BUILD MODEL
## randomly choose 1/2 of the data set as training data
set.seed(777)
random.rows.train <- sample(1:nrow(iris), 0.5*nrow(iris), replace=F)
iris.train <- iris[random.rows.train,]
dim(iris.train)
## select the other 1/2 left as the testing data
random.rows.test <- setdiff(1:nrow(iris),random.rows.train)
iris.test <- iris[random.rows.test,]
dim(iris.test)
## fitting decision model on training set
iris.model <- naiveBayes(Species~., data = iris.train)

## MODEL EVALUATION
## make prediction using decision model
iris.test.predictions <- predict(iris.model, iris.test, type = "class")
## extract out the observations in testing set
iris.test.observations <- iris.test$Species
## show the confusion matrix
confusion.matrix <- table(iris.test.predictions, iris.test.observations)
confusion.matrix
## calculate the error in testing set
error <- 1 - sum(diag(confusion.matrix)) / sum(confusion.matrix)
error

## EXERCISE
## Check out the prior probabilities of the model by "iris.model$tables", plot the (normal) distribution of P(Sepal.Length|virginica).
## Also plot the histogram of Sepal.Length for all Virginica iris in the training set (iris.train[iris.train$Species=="virginica", "Sepal.Length"]).
## Compare these two figures. Remember the "normal distribution" is an approximation of the "histogram" in this naive Bayes model.


