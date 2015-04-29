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
ky.train <- kyphosis[random.rows.train,]
dim(ky.train)
## select the other 20% as the testing data
random.rows.test <- setdiff(1:nrow(kyphosis),random.rows.train)
ky.test <- kyphosis[random.rows.test,]
dim(ky.test)
## fitting decision model on training set 
ky.model1 <- rpart(Kyphosis ~ Age + Number + Start, data = ky.train)

## MODEL 1 EVALUATION
## make prediction using decision model
ky.pred1 <- predict(ky.model1, ky.test, type = "class")
## extract out the observations in testing set
ky.obs <- ky.test[,1]
## show the confusion matrix
confusion.matrix1 <- table(ky.pred1, ky.obs)
confusion.matrix1

## BUILD MODEL 2
## fitting decision model on training set 
ky.model2 <- rpart(Kyphosis ~ Age + Number + Start, data = ky.train, parms = list(prior = c(0.65, 0.35), split = "information"))

## MODEL 2 EVALUATION
## make prediction using decision model
ky.pred2 <- predict(ky.model2, ky.test, type = "class")
## show the confusion matrix
confusion.matrix2 <- table(ky.pred2, ky.obs)
confusion.matrix2

## BUILD MODEL 3
## fitting decision model on training set 
ky.model3 <- rpart(Kyphosis ~ Age + Number + Start, data = ky.train, control = rpart.control(cp = 0.05))
## MODEL 2 EVALUATION
## make prediction using decision model
ky.pred3 <- predict(ky.model3, ky.test, type = "class")
## show the confusion matrix
confusion.matrix3 <- table(ky.pred3, ky.obs)
confusion.matrix3

## VISUALIZE THE THREE MODELS
par(mfrow = c(1,3), xpd = TRUE)
plot(ky.model1)
title(main = "Model 1")
text(ky.model1, use.n = TRUE)
plot(ky.model2)
title(main = "Model 2")
text(ky.model2, use.n = TRUE)
plot(ky.model3)
title(main = "Model 3")
text(ky.model3, use.n = TRUE)


