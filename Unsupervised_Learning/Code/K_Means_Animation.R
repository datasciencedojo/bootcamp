###################################################################################
## 
## Objective: Visualize simulated K-Means clustering animation.
## Please install "animation" package: install.packages("animation")
###################################################################################


library(animation)


## set larger or smaller 'interval' if the speed is too fast or too slow
ani.opt.orig = ani.options(interval = 2)
par(mar = c(3, 3, 1, 1.5), mgp = c(1.5, 0.5, 0))
kmeans.ani()

## kmeans() default example converges very rapidly. What if we generate some sample data and see
## how long it can take?
## Change the seed to change the initial distribution of points.
set.seed(27)
x = rbind(matrix(rnorm(100, sd = 0.3), ncol = 2), matrix(rnorm(100, mean = 1, sd = 0.3), 
    ncol = 2))
colnames(x) = c("x", "y")
kmeans.ani(x, centers = 2)
 
## what if we cluster them into 3 groups?
kmeans.ani(x, centers = 3)
