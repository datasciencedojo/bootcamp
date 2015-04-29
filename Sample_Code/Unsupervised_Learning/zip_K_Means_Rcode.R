###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Machine learning on hand-written digits recognition with K-Means clustering. In this task, we just do the binary classification between digits '2' and '3'.
## Data source: zip.train.csv  
##              at: https://github.com/datasciencedojo/bootcamp/tree/master/Unsupervised_Learning/Zip
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
zip.data <- as.data.frame(scale(zip.data[,-1]))
## K-means clustering model
zip.km <- kmeans(zip.data, 10, iter.max = 100, nstart = 25)
zip.km

## VISUALIZE THE CLUSTERS
## subset out each cluster to investigate the data
zip.km.clust<- lapply(1:10, function(nc) zip.data[zip.km$cluster==nc, 1])  
zip.km.clust
##  plot to visualize the clusters
plotcluster(zip.scale, zip.KM$cluster, xlab="dc1", ylab="dc2")
title(main="Discriminant Projection Plot of 10 Hand-Written Digits")
