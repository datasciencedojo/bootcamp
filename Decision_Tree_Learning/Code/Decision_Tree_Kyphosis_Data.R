###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of Kyphosis classification with decision tree
## Data source: kyphosis data set in "rpart" package
## Please install "rpart" package: install.packages("rpart")
###################################################################################

## load the library
library(rpart)

## DATA EXPLORATION
## load the kyphosis data
data(kyphosis)
## explore the data set
str(kyphosis)
dim(kyphosis)
summary(kyphosis)

## randomly choose 60% of the data set as training data (Why 60% instead of 70%?)
set.seed(102)

kyphosis.train.indices <- sample(1:nrow(kyphosis), 0.6*nrow(kyphosis))
kyphosis.train <- kyphosis[kyphosis.train.indices,]
dim(kyphosis.train)
## Use the remaining 40% as the testing data
kyphosis.test <- kyphosis[-kyphosis.train.indices,]
dim(kyphosis.test)

## You could also do the following to get the test data
#kyphosis.test.indices <- setdiff(1:nrow(kyphosis),random.rows.train)
#kyphosis.test <- kyphosis[kyphosis.test.indices,]

## check testing and training set target distributions
table(kyphosis.train$Kyphosis)
table(kyphosis.test$Kyphosis)

## BUILD MODEL 1
## Splitting based on Gini index, cp = 0.01, minsplit = 20
## See ?rpart.control for definitions of cp and minsplit
kyphosis.dt.1.model <- rpart(Kyphosis ~ ., data = kyphosis.train)

## Display model
summary(kyphosis.dt.1.model)

## MODEL EVALUATION
## Make predictions using the default decision tree
kyphosis.dt.1.predictions <- predict(kyphosis.dt.1.model, kyphosis.test, type = "class")

## create confusion matrix
kyphosis.dt.1.confusion <- table(kyphosis.dt.1.predictions, kyphosis.test[,"Kyphosis"])
print(kyphosis.dt.1.confusion)
## accuracy
kyphosis.dt.1.accuracy <- sum(diag(kyphosis.dt.1.confusion)) / sum(kyphosis.dt.1.confusion)
print(kyphosis.dt.1.accuracy)
## precision
kyphosis.dt.1.precision <- kyphosis.dt.1.confusion[2,2] / sum(kyphosis.dt.1.confusion[2,])
print(kyphosis.dt.1.precision)
## recall
kyphosis.dt.1.recall <- kyphosis.dt.1.confusion[2,2] / sum(kyphosis.dt.1.confusion[,2])
print(kyphosis.dt.1.recall)
## F1 score
kyphosis.dt.1.F1 <- 2 * kyphosis.dt.1.precision * kyphosis.dt.1.recall / (kyphosis.dt.1.precision + kyphosis.dt.1.recall)
print(kyphosis.dt.1.F1)

## BUILD MODEL 2
## Splitting based on information gain, cp = 0.01, minsplit = 20
kyphosis.dt.2.model <- rpart(Kyphosis ~ ., data = kyphosis.train, parms = list(split = "information"))

## Display model
summary(kyphosis.dt.2.model)

## MODEL 2 EVALUATION
## make prediction using decision model
kyphosis.dt.2.predictions <- predict(kyphosis.dt.2.model, kyphosis.test, type = "class")
## build the confusion matrix
kyphosis.dt.2.confusion <- table(kyphosis.dt.2.predictions, kyphosis.test[,"Kyphosis"])
print(kyphosis.dt.2.confusion)
## accuracy
kyphosis.dt.2.accuracy <- sum(diag(kyphosis.dt.2.confusion)) / sum(kyphosis.dt.2.confusion)
print(kyphosis.dt.2.accuracy)
## precision
kyphosis.dt.2.precision <- kyphosis.dt.2.confusion[2,2] / sum(kyphosis.dt.2.confusion[2,])
print(kyphosis.dt.2.precision)
## recall
kyphosis.dt.2.recall <- kyphosis.dt.2.confusion[2,2] / sum(kyphosis.dt.2.confusion[,2])
print(kyphosis.dt.2.recall)
## F1 score
kyphosis.dt.2.F1 <- 2 * kyphosis.dt.2.precision * kyphosis.dt.2.recall / (kyphosis.dt.2.precision + kyphosis.dt.2.recall)
print(kyphosis.dt.2.F1)


## BUILD MODEL 3
## Splitting on gini index; cp = 0.1, minsplit = 10
kyphosis.dt.3.model <- rpart(Kyphosis ~ ., data = kyphosis.train, control = rpart.control(cp = 0.1, minsplit = 10))

## MODEL 3 EVALUATION
## make prediction using decision model
kyphosis.dt.3.predictions <- predict(kyphosis.dt.3.model, kyphosis.test, type = "class")
## show the confusion matrix
kyphosis.dt.3.confusion <- table(kyphosis.dt.3.predictions, kyphosis.test[,"Kyphosis"])
print(kyphosis.dt.3.confusion)
## accuracy
kyphosis.dt.3.accuracy <- sum(diag(kyphosis.dt.3.confusion)) / sum(kyphosis.dt.3.confusion)
print(kyphosis.dt.3.accuracy)
## precision
kyphosis.dt.3.precision <- kyphosis.dt.3.confusion[2,2] / sum(kyphosis.dt.3.confusion[2,])
print(kyphosis.dt.3.precision)
## recall
kyphosis.dt.3.recall <- kyphosis.dt.3.confusion[2,2] / sum(kyphosis.dt.3.confusion[,2])
print(kyphosis.dt.3.recall)
## F1 score
kyphosis.dt.3.F1 <- 2 * kyphosis.dt.3.precision * kyphosis.dt.3.recall / (kyphosis.dt.3.precision + kyphosis.dt.3.recall)
print(kyphosis.dt.3.F1)

## VISUALIZE THE THREE MODELS
par(mfrow = c(1,3), xpd = TRUE)
plot(kyphosis.dt.1.model)
title(main = "Model 1")
text(kyphosis.dt.1.model, use.n = TRUE)
plot(kyphosis.dt.2.model)
title(main = "Model 2")
text(kyphosis.dt.2.model, use.n = TRUE)
plot(kyphosis.dt.3.model)
title(main = "Model 3")
text(kyphosis.dt.3.model, use.n = TRUE)

## EXERCISE
## Several parameters of rpart function can be used to tune the tree. 
## Some parameters used in the above 3 models are:
## parms = list(split = "information"))
## rpart.control(cp = 0.1, minsplit = 10)
## Check out ?rpart.control and ?rpart to read the documentation on the model function
## Fine-tune the parameters, can you build a better decision tree model with less error?
