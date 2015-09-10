###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning of iris species classification with decision tree
## Data source: spam data set (included in the package "ElemStatLearn")	
## Please install "klaR" package for the naive Bayes algorithm: install.packages("klaR")
## Please install "ElemStatLearn" package for the spam data: install.packages("ElemStatLearn")
###################################################################################

library(klaR)

## DATA EXPLORATION
## load the spam data in R
data(spam, package="ElemStatLearn")
## explore the data set
###################################################################################
## This data frame "spam" is the result of a text mining task based on 4601 emails.
## We want to classify an email as spam or regular email, which is recorded in the "spam" column.
## The 1st to the 54th columns are the frequences of some important words or characters in each email.
## The 55th to 57th columns are some features reflecting the appearance of capital letters
## A more detailed explanation of these features is explained in the manual of the ElemStatLearn
## library at: http://cran.r-project.org/web/packages/ElemStatLearn/ElemStatLearn.pdf
###################################################################################
str(spam)
summary(spam)
dim(spam)

## One attribute, A.41 has a perfect relationship with the spam/email label. As a result,
## if we leave the column in, the NaiveBayes function will error. Why is this good behavior?
spam.data <- spam[,-41]

## BUILD MODEL
## randomly choose 70% of the data set as training data
set.seed(102)
spam.train.indices <- sample(1:nrow(spam.data), 0.7*nrow(spam.data), replace=F)
spam.train <- spam.data[spam.train.indices,]
dim(spam.train)
## Use the 30% left as testing data
spam.test <- spam.data[-spam.train.indices,]
dim(spam.test)
## Look at the relative frequency of target labels in training and test sets
summary(spam.train$spam)
summary(spam.test$spam)

## fitting decision model on training set
spam.nb.model <- NaiveBayes(spam ~ ., data=spam.train)

## visualize the calculated prior conditional probabilities of each feature
par(mfrow=c(2,4))
plot(spam.nb.model)

## MODEL EVALUATION
## make prediction using decision model
spam.nb.predictions <- predict(spam.nb.model, spam.test)
summary(spam.nb.predictions$class)
## calculate the confusion matrix
spam.nb.confusion <- table(spam.nb.predictions$class, spam.test$spam)
print(spam.nb.confusion)
## accuracy
spam.nb.accuracy <- sum(diag(spam.nb.confusion)) / sum(spam.nb.confusion)
print(spam.nb.accuracy)
## precision
spam.nb.precision <- spam.nb.confusion[2,2] / sum(spam.nb.confusion[2,])
print(spam.nb.precision)
## recall
spam.nb.recall <- spam.nb.confusion[2,2] / sum(spam.nb.confusion[,2])
print(spam.nb.recall)
## F1 score
spam.nb.F1 <- 2 * spam.nb.precision * spam.nb.recall / (spam.nb.precision + spam.nb.recall)
print(spam.nb.F1)

## EXERCISE
## This sample code for spam data uses the library "klaR" for naive Beyes inference.
## Instead of klaR, try to use the library "e1071" as the sample code as in the Iris lab does.
## Do they give the same results?



