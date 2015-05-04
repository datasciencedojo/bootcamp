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

## BUILD MODEL 1
## randomly choose 60% of the data set as training data
set.seed(17)
random.rows.train <- sample(1:nrow(kyphosis), 0.6*nrow(kyphosis), replace=F)
kyphosis.train <- kyphosis[random.rows.train,]
dim(kyphosis.train)
## select the other 40% as the testing data
random.rows.test <- setdiff(1:nrow(kyphosis),random.rows.train)
kyphosis.test <- kyphosis[random.rows.test,]
dim(kyphosis.test)
## fitting decision model on training set
set.seed(102)
kyphosis.model1 <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis.train)

## MODEL 1 EVALUATION
## make prediction using decision model
kyphosis.test.predictions1 <- predict(kyphosis.model1, kyphosis.test, type = "class")
## extract out the observations in testing set
kyphosis.test.observations <- kyphosis.test[,1]
## show the confusion matrix
confusion.matrix1 <- table(kyphosis.test.predictions1, kyphosis.test.observations)
confusion.matrix1
## precision
precision1 <- confusion.matrix1[2,2] / sum(confusion.matrix1[2,])
precision1
## recall
recall1 <- confusion.matrix1[2,2] / sum(confusion.matrix1[,2])
recall1
## F1 score
F1.score1 <- 2 * precision1 * recall1 / (precision1 + recall1)
F1.score1

## BUILD MODEL 2
table(kyphosis.train$Kyphosis)
## fitting decision model on training set
set.seed(102)
kyphosis.model2 <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis.train, parms = list(split = "information"))

## MODEL 2 EVALUATION
## make prediction using decision model
kyphosis.test.predictions2 <- predict(kyphosis.model2, kyphosis.test, type = "class")
## show the confusion matrix
confusion.matrix2 <- table(kyphosis.test.predictions2, kyphosis.test.observations)
confusion.matrix2
## precision
precision2 <- confusion.matrix2[2,2] / sum(confusion.matrix2[2,])
precision2
## recall
recall2 <- confusion.matrix2[2,2] / sum(confusion.matrix2[,2])
recall2
## F1 score
F1.score2 <- 2 * precision2 * recall2 / (precision2 + recall2)
F1.score2

## BUILD MODEL 3
## fitting decision model on training set
set.seed(102)
kyphosis.model3 <- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis.train, control = rpart.control(cp = 0.1, minsplit = 10))

## MODEL 3 EVALUATION
## make prediction using decision model
kyphosis.test.predictions3 <- predict(kyphosis.model3, kyphosis.test, type = "class")
## show the confusion matrix
confusion.matrix3 <- table(kyphosis.test.predictions3, kyphosis.test.observations)
confusion.matrix3
## precision
precision3 <- confusion.matrix3[2,2] / sum(confusion.matrix3[2,])
precision3
## recall
recall3 <- confusion.matrix3[2,2] / sum(confusion.matrix3[,2])
recall3
## F1 score
F1.score3 <- 2 * precision3 * recall3 / (precision3 + recall3)
F1.score3

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

## EXERCISE
## Several parameters of rpart function can be used to tune the tree. Some parameters used in the above 3 models are:
## parms = list(split = "information"))
## rpart.control(cp = 0.1, minsplit = 10)
## Check out the mannual of rpart at http://cran.r-project.org/web/packages/rpart/rpart.pdf. Fine-tune the paramters, could you build a better decision tree model with less error?
