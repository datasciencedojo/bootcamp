###################################################################################
##													   ##
## Objective: K-Means Clustering with simulated data, visualize scree plot
## 
##################################################################################



######Simulate Dataset for Clustering

n = 150
g = 6 
set.seed(g)
d <- data.frame(x = unlist(lapply(1:g, function(i) rnorm(n/g, runif(1)*i^2))), 
                y = unlist(lapply(1:g, function(i) rnorm(n/g, runif(1)*i^2))))
sim.data<-d

#####Plots

par(mfrow=c(1,2))

#Plot the original dataset
plot(sim.data$x,sim.data$y,main="Original Dataset")

#Scree plot to determine the number of clusters
wcss <- (nrow(sim.data)-1)*sum(apply(sim.data,2,var))
  for (i in 2:15) {
    wcss[i] <- sum(kmeans(sim.data,centers=i)$withinss)
}   
plot(1:15, wcss, type="b", xlab="Number of Clusters",ylab="Within groups sum of squares")


