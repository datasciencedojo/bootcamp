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
iris.train.indices <- sample(1:nrow(iris), 0.7*nrow(iris), replace=F)
iris.train <- iris[iris.train.indices,]
dim(iris.train)
## select the 30% left as the testing data
iris.test <- iris[-iris.train.indices,]
dim(iris.test)
## You could also do this
#iris.test.indices <- setdiff(1:nrow(iris),random.rows.train)
#iris.test <- iris[random.rows.test,]

## Setting control parameters for rpart
## Check ?rpart.control for what the parameters do
iris.dt.parameters <- rpart.control(minsplit=20, minbucket=7, cp=0.01, maxdepth=30)

## Fit decision model to training set
## Use parameters from above and Gini index for splitting
iris.dt.model <- rpart(Species ~ ., data = iris.train, 
                       control=iris.dt.parameters, parms=list(split="gini"))

## VISUALIZE THE MODEL
## plot the tree structure
plot(iris.dt.model)
title(main = "Decision Tree Model of Iris Data")
text(iris.dt.model, use.n = TRUE)
## print the tree structure
summary(iris.dt.model)

## MODEL EVALUATION
## make prediction using decision model
iris.dt.predictions <- predict(iris.dt.model, iris.test, type = "class")
## Extract the test data species to build the confusion matrix
iris.dt.confusion <- table(iris.dt.predictions, iris.test$Species)
print(iris.dt.confusion)
## calculate accuracy, precision, recall, F1
iris.dt.accuracy <- sum(diag(iris.dt.confusion)) / sum(iris.dt.confusion)
print(iris.dt.accuracy)

iris.dt.precision <- iris.dt.confusion[2,2] / sum(iris.dt.confusion[2,])
print(iris.dt.precision)

iris.dt.recall <- iris.dt.confusion[2,2] / sum(iris.dt.confusion[,2])
print(iris.dt.recall)

iris.dt.F1 <- 2 * iris.dt.precision * iris.dt.recall / (iris.dt.precision + iris.dt.recall)
print(iris.dt.F1)

## EXERCISE
## Another library called "party" can be also used to build decision trees.
## It provides nonparametric regression trees for nominal, ordinal,
## numeric, censored, and multivariate responses. Tree growth is based on statistical 
## stopping rules, so pruning should not be required. 
## party manual: http://cran.r-project.org/web/packages/party/party.pdf
## Instead of rpart(), try to use ctree() in "party" for the same data. 
## They implement a different algorithm for building the tree. 
## But for this small amount of data, do these different functions (with different algorithms) 
## actually give us different trees?