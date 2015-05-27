###################################################################################
## 
## Objective: Visualize simulated K-Means clustering animation.
## Please install "animation" package: install.packages("animation")
###################################################################################


library(animation)


## set larger 'interval' if the speed is too fast
oopt = ani.options(interval = 2)
par(mar = c(3, 3, 1, 1.5), mgp = c(1.5, 0.5, 0))
kmeans.ani()
 
## the kmeans() example; very fast to converge!
x = rbind(matrix(rnorm(100, sd = 0.3), ncol = 2), matrix(rnorm(100, mean = 1, sd = 0.3), 
    ncol = 2))
colnames(x) = c("x", "y")
kmeans.ani(x, centers = 2)
 
## what if we cluster them into 3 groups?
kmeans.ani(x, centers = 3)