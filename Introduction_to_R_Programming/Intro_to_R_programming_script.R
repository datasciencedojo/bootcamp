# Intro to R Script
# To be used line by line or in small collections to reduce typing time during webinar

library(plyr)

# Factor vector example
v <- c("New York", "Chicago", "Seattle", "San Jose", "Gary", "Seattle", 
       "Seattle", "San Jose", "New York", "New York", "New York")
v
v.factor <- as.factor(v) # This is an inline comment
v.factor
levels(v.factor) <- c("Chicago", "Gary", "Brooklyn", "San Jose", "Seattle")
v.factor
length(v.factor)

# Data frame examples
data("iris")
names(iris)
nrow(iris)
ncol(iris)
dim(iris)
names(iris)
head(iris)
tail(iris)
str(iris)
summary(iris)
head(iris[,"Sepal.Length"])
head(iris[,c("Petal.Length", "Petal.Width")])
head(iris[,2])
head(iris[,1:3])
head(iris[,-c(1,2)])
head(iris[iris$Species=="virginica",])
