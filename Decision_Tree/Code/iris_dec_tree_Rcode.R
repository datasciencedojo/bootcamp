######################################################################################
## Objective: Machine learning of Iris species classification with  decision tree	##
##		  												##
## Data source: iris data set (included with R installment)					##
##		    please install "rpart" package 							##
##														##
######################################################################################




#install.packages("rpart")   ##please remove "#" if you need to install "rpart" package ###

library(rpart)

data(iris)

str(iris)

dim(iris)

####### creating random number for training set #######

n.points<-nrow(iris)  
sampling.rate<-0.5

random.training<-sample(1:n.points,sampling.rate*n.points,replace=F)

####### subset out the training set     ########
iris.training<-subset(iris[random.training,])
dim(iris.training)

#######  data not selected from training set selection will assign as testing set ####

random.testing<-setdiff(1:n.points,random.training)

####### subset out the testing set ######
iris.testing<-subset(iris[random.testing,])
dim(iris.testing)

####### fitting decision model on training set #######
iris.fit <- rpart( Species~., data = iris.training)

####### make prediction using decision model ########

iris.pred<-predict(iris.fit, ,newdata=iris.testing,type = "class")

####### extract out the true label #######

iris.true.label<-iris.testing$Species

####### confusion table ######

iris.table<-table(iris.pred,iris.true.label)
iris.table

###### visualize the tree structure ######

plot(iris.fit)
text(iris.fit, use.n = TRUE)



