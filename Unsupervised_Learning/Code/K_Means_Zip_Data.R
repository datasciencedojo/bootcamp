###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on hand-written digits recognition with K-Means clustering. In this task, we just do the binary classification between digits '2' and '3'.
## Data source: zip.train.csv  
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Unsupervised_Learning/Zip
## Please install "stats" package: install.packages("stats")
## Please install "fpc" package: install.packages("fpc")
###################################################################################

## load the libraries
library(stats)
library(fpc)

## LOAD THE DATA
zip.data <- read.csv("../Data/Zip/zip.train.csv", header= F)

## BUILD MODEL
## randomly sample 500 rows in the training set
set.seed(100)
random.rows <- sample(1:nrow(zip.data),500,replace=F)
zip.data <- zip.data[random.rows,]
## scale the data
zip.data <- as.data.frame(scale(zip.data[,-1]))
## K-means clustering model
zip.model <- kmeans(zip.data, 10, iter.max = 100, nstart = 25)
zip.model

## VISUALIZE THE CLUSTERS
## subset out each cluster to investigate the data
zip.kmean.clusters <- lapply(1:10, function(nc) zip.data[zip.model$cluster==nc, 1])
zip.kmean.clusters
##  plot to visualize the clusters
plotcluster(zip.data, zip.model$cluster, xlab="dc1", ylab="dc2", method="dc")
title(main="Discriminant Projection Plot of 10 Hand-Written Digits")

## EXERCISE
## This is a 256 dimensional clustering problem. But plotcluster() function enables us to see the clusters in a two-dimensional plane. To do this all the 256 features are transformed to discriminant coordinates, and only the first two main discriminant coordinates are kept. Check the Wikipedia page of linear discriminant analysis (http://en.wikipedia.org/wiki/Linear_discriminant_analysis) for more information.
