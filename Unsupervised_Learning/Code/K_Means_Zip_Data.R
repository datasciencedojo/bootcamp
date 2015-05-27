###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on hand-written digits recognition with K-Means clustering. In this task, we just do the binary classification between digits '2' and '3'.
## Data source: zip.train.csv  
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Datasets/Zip
## Please install "stats" package: install.packages("stats")
## Please install "fpc" package: install.packages("fpc")
###################################################################################

## load the libraries
library(stats)
library(fpc)

## LOAD THE DATA
zip.data <- read.csv("Zip/zip.train.csv", header= F)

## BUILD MODEL
## randomly sample 500 rows in the training set
set.seed(100)
random.rows <- sample(1:nrow(zip.data),500,replace=F)
zip.data <- zip.data[random.rows,]
## scale the data
zip.train <- as.data.frame(scale(zip.data[,-1]))
## K-means clustering model
zip.model <- kmeans(zip.train, 10, iter.max = 100, nstart = 25)
zip.model

## VISUALIZE THE CLUSTERS
## subset out each cluster to investigate the data
zip.kmean.clusters <- lapply(1:10, function(nc)zip.data[zip.model$cluster==nc, 1])
zip.kmean.clusters
##  plot to visualize the clusters
plotcluster(zip.train, zip.data$V1, xlab="dc1", ylab="dc2", method="dc")


title(main="Discriminant Projection Plot of 10 Hand-Written Digits")


####Scree plot to determine the number of clusters####

####calcuate within-cluster sum of squared ####

wcss <- (nrow(zip.train)-1)*sum(apply(zip.train,2,var))   

  for (i in 2:15) {
    wcss[i] <- sum(kmeans(zip.train,centers=i)$withinss)
}   

#### plot a scree plot ####

plot(1:15, wcss, type="b", xlab="Number of Clusters",ylab="Within clusters sum of squares")




