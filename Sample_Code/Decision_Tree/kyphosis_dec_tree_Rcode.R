###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of Kyphosis classification with decision tree
## Data source: kyphosis data set in "rpart" package
## Please install "rpart" package: install.packages("rpart")
###################################################################################

## load the rpart library
library(rpart)

## DATA EXPLORATION
## load the kyphosis data
data(kyphosis)
## explore the data set
str(kyphosis)
dim(kyphosis)

## BUILD MODEL 1
## randomly choose 80% of the data set as training data
random.rows.train <- sample(1:nrow(kyphosis), 0.8*nrow(kyphosis), replace=F)
kyphosis.train <- kyphosis[random.rows.train,]
dim(kyphosis.train)
## select the other 20% as the testing data
random.rows.test <- setdiff(1:nrow(kyphosis),random.rows.train)
kyphosis.test <- kyphosis[random.rows.test,]
dim(kyphosis.test)
## fitting decision model on training set 
kyphosis.model1 <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis.train)

## MODEL 1 EVALUATION
## make prediction using decision model
kyphosis.test.predictions1 <- predict(kyphosis.model1, kyphosis.test, type = "class")
## extract out the observations in testing set
kyphosis.test.observations <- kyphosis.test[,1]
## show the confusion matrix
confusion.matrix1 <- table(kyphosis.test.predictions1, kyphosis.test.observations)
confusion.matrix1

## BUILD MODEL 2
## fitting decision model on training set 
kyphosis.model2 <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis.train, parms = list(prior = c(0.65, 0.35), split = "information"))

## MODEL 2 EVALUATION
## make prediction using decision model
kyphosis.test.predictions2 <- predict(kyphosis.model2, kyphosis.test, type = "class")
## show the confusion matrix
confusion.matrix2 <- table(kyphosis.test.predictions2, kyphosis.test.observations)
confusion.matrix2

## BUILD MODEL 3
## fitting decision model on training set 
kyphosis.model3 <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis.train, control = rpart.control(cp = 0.05))

## MODEL 2 EVALUATION
## make prediction using decision model
kyphosis.test.predictions3 <- predict(kyphosis.model3, kyphosis.test, type = "class")
## show the confusion matrix
confusion.matrix3 <- table(kyphosis.test.predictions3, kyphosis.test.observations)
confusion.matrix3

## VISUALIZE THE THREE MODELS
par(mfrow = c(1,3), xpd = TRUE)
plot(kyphosis.model1)
title(main = "Model 1")
text(kyphosis.model1, use.n = TRUE)
plot(kyphosis.model2)
title(main = "Model 2")
text(kyphosis.model2, use.n = TRUE)
plot(kyphosis.model3)
title(main = "Model 3")
text(kyphosis.model3, use.n = TRUE)


