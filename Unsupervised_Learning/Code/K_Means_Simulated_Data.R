###################################################################################
##													   ##
## Objective: K-Means Clustering with simulated data, visualize scree plot
## 
##################################################################################



######Simulate Dataset for Clustering

n.objects = 150
n.cluster = 6
set.seed(27)
sim.data <- data.frame(x = unlist(lapply(1:n.cluster, function(i) rnorm(n.objects = 150/n.cluster, runif(1)*i^2))), 
                y = unlist(lapply(1:n.cluster, function(i) rnorm(n.objects = 150/n.cluster, runif(1)*i^2))))

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

## Exercise:
## Play with changing n.objects and n.cluster. What do you notice about the shape of the scree plot
## as you change these values? What does this suggest about the strengths and weaknesses of kmeans?

