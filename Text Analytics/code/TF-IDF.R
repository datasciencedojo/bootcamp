###################################################################################
## This code is part of Data Science Dojo's bootcamp
## Copyright (C) 2015

## Objective: Building TF-IDF matrices using R, including stemming for dictionary compression
## Packages: tm, lsa
###################################################################################

# Load the library
library(tm)
library(lsa)

# Load the test dataset
data(crude)

# Explore the dataset
str(crude)

# Remove punctuation, apply a stemmer, and build a document-term matrix using TF-IDF
crude.dt <- DocumentTermMatrix(crude, control=list(weighting=weightTfIdf,
                                                   removePunctuation=T,
                                                   stemming=T))

# Inspect the document-term matrix
inspect(crude.dt)

#Compute a matrix of cosine similarity scores between each document pair