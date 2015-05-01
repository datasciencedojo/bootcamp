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
iris.model <- rpart(Species~., data = iris.train)

## VISUALIZE THE MODEL
## visualize the tree structure
plot(iris.model)
title(main = "Decision Tree Model of Iris Data")
text(iris.model, use.n = TRUE)

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
## Besides the rpart library, another library called "party" can be also used to build decision trees. It provides nonparametric regression trees for nominal, ordinal, numeric, censored, and multivariate responses. Tree growth is based on statistical stopping rules, so pruning should not be required. Mannual of party library: http://cran.r-project.org/web/packages/party/party.pdf. 
## Instead of rpart(), try to use ctree() in "party" for the same data. They implement different algorithm when building the trees. But for this small iris data, would these two functions (with two algorithms) give us the same tree?
