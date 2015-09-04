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
## randomly choose 50% of the data set as training data (Why 50% instead of more?)
set.seed(27)
iris.train.indices <- sample(1:nrow(iris), 0.5*nrow(iris), replace=F)
iris.train <- iris[iris.train.indices,]
dim(iris.train)
summary(iris.train$Species)
## Grab the remaining 50% for the testing data
iris.test <- iris[-iris.train.indices,]
dim(iris.test)
summary(iris.test$Species)
## You could also do this
#random.rows.test <- setdiff(1:nrow(iris),random.rows.train)
#iris.test <- iris[random.rows.test,]

## fitting the decision model on the training set
iris.nb.model <- naiveBayes(Species ~ ., data = iris.train)

## MODEL EVALUATION
## Predict test set species using our naive bayes model
iris.nb.predictions <- predict(iris.nb.model, iris.test, type = "class")

## calculate the confusion matrix
iris.nb.confusion <- table(iris.nb.predictions, iris.test$Species)
print(iris.nb.confusion)
## calculate the accuracy, precision, recall, and F1
iris.nb.accuracy <- sum(diag(iris.nb.confusion)) / sum(iris.nb.confusion)
print(iris.nb.accuracy)

iris.nb.precision <- iris.nb.confusion[2,2] / sum(iris.nb.confusion[2,])
print(iris.nb.precision)

iris.nb.recall <- iris.nb.confusion[2,2] / sum(iris.nb.confusion[,2])
print(iris.nb.recall)

iris.nb.F1 <- 2 * iris.nb.precision * iris.nb.recall / (iris.nb.precision + iris.nb.recall)
print(iris.nb.F1)

## EXERCISE
## (1) Investigate prior probabilities of the model stored in "iris.model$tables"
## ([,1] = mean, [,2] = standard deviation)
## 
## (2) Plot P(Sepal.Length|virginica) based on the information from (1)
## Sample code:
##     par(mfrow=c(1,2))
##     mean <- 6.432000
##     sd <- 0.597717
##     Sepal.Length.range <- seq(3,9,length=100)
##     density <- dnorm(Sepal.Length.range,mean,sd)
##     plot(Sepal.Length.range,density, type="l", xlab="Sepal.Length")
## 
## (3) Plot a histogram of Sepal.Length for all Virginica iris in the training and testing sets
## Sample code:
##     hist(iris.train$Sepal.Length[iris.train$Species=="virginica"], main="Histogram of Sepal.Length|Virginica", xlab="Sepal.Length")
## 
## Compare these plot from (2) and (3).  What do you observe?
## Remember the normal distribution is an approximation of the histogram
## in this Naive Bayes model.

## EXERCISE
## This sample code for spam data uses the library "e1071" for naive Beyes inference.
## Instead of e1071, try to use the library "klaR" as the sample code as the Spam lab does.
## Do they give the same results?
