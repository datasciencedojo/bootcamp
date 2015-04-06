######################################################################################
## Objective: Machine learning on  with Kyphosis classification with  decision tree	##
##		  												##
## Data source: kyphosis data set from "rpart" package					##
##		    please install "rpart" package 							##
##														##
######################################################################################




#install.packages("rpart")   ### please remove if you already install "rpart" package

library(rpart)

data(kyphosis)

str(kyphosis)

dim(kyphosis)

####### creating random number for training set #######

n.points<-nrow(kyphosis)  
sampling.rate<-0.8

random.training<-sample(1:n.points,sampling.rate*n.points,replace=F)

####### subset out the training set     ########
ky.training<-subset(kyphosis[random.training,])
dim(ky.training)

#######  data not selected from training set selection will assign as testing set ####

random.testing<-setdiff(1:n.points,random.training)

####### subset out the testing set ######
ky.testing<-subset(kyphosis[random.testing,])
dim(ky.testing)

####### fitting decision model on training set #######

ky.fit <- rpart(Kyphosis ~ Age + Number + Start, data = ky.training)

####### make prediction using decision model ########

ky.pred<-predict(ky.fit, ,newdata=ky.testing,type = "class")

####### extract out the true label #######

ky.true.label<-ky.testing[,1]

####### confusion table ######

table1<-table(ky.pred,ky.true.label)
table1


###### Fit 2, adjusting for model splitting parameters #####
ky.fit2<- rpart(Kyphosis ~ Age + Number + Start, data = kyphosis,parms = list(prior = c(0.65, 0.35), split = "information"))

###### prediction for Fit2
ky.pred2<-predict(ky.fit2, ,newdata=ky.testing,type = "class")

###### confusion table for fit 2
table2<-table(ky.pred2,ky.true.label)
table2

###### Fit 3, adjusting for rpart.control #####

ky.fit3<- rpart(Kyphosis ~ Age + Number + Start, data=kyphosis,control = rpart.control(cp = 0.05))

###### prediction for Fit3

ky.pred3<-predict(ky.fit3, ,newdata=ky.testing,type = "class")

###### confusion table for fit 3
table3<-table(ky.pred3,ky.true.label)
table3

###### visualize the tree structure between two models ######
par(mfrow = c(1,2), xpd = TRUE)
plot(ky.fit)
text(ky.fit, use.n = TRUE)
plot(ky.fit2)
text(ky.fit2, use.n = TRUE)


