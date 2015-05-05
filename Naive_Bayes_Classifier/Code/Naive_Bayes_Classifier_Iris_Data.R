###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of iris species classification with naive Bayes inference
## Data source: iris data set (included in R)	
## Please install "e1071" package: install.packages("e1071")
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
## calculate the accuracy in testing set
accuracy <- sum(diag(confusion.matrix)) / sum(confusion.matrix)
accuracy

## EXERCISE
## (1) Investigate prior probabilities of the model by typing "iris.model$tables"
## ([,1] = mean, [,2] = standard deviation)
## 
## (2) Plot a normal distribution of P(Sepal.Length|virginica) based on information from table in 1)
## Sample code:
##     par(mfrow=c(1,2))
##     mean <- 6.432000
##     sd <- 0.597717
##     Sepal.Length.range <- seq(3,9,length=100)
##     density <- dnorm(Sepal.Length.range,mean,sd)
##     plot(Sepal.Length.range,density, type="l", xlab="Sepal.Length")
## 
## (3) Plot a histogram of Sepal.Length for all Virginica iris in the training set
## Sample code:
##     hist(iris.train$Sepal.Length[iris.train$Species=="virginica"], main="Histogram of Sepal.Length|Virginica", xlab="Sepal.Length")
## 
## Compare these plot from (2) and (3).  What do you observe?
## Remember the "normal distribution" is an approximation of the "histogram" in this Naive Bayes model.
