######################################################################################
## Objective: Machine learning on ozone prediction with linear regression model   	##
##		  												##
## Data source: ozone.data.txt   (please download from GitHub to your local drive)  ##
##		    												##
##														##
######################################################################################
	







####### load data from working directory ######

ozone.data<-read.table("ozone.data.txt", header=T)

####### check the attributes of the data ######
str(ozone.data)

####### data visualization   #########
plot(ozone.data)      

#######  creating training and testing set by splitting the data ######

n.points<-nrow(ozone.data)  
sampling.rate<-0.8

#######  randomly sample which rows will go in the trainning set  #######

random.training<-sample(1:n.points,sampling.rate*n.points,replace=F)

####### subset out the training set     ########
ozone.training<-subset(ozone.data[random.training,])
dim(ozone.training)

#######  data not selected from training set selection will assign as testing set ####

random.testing<-setdiff(1:n.points,random.training)

####### subset out the testing set ######
ozone.testing<-subset(ozone.data[random.testing,])
dim(ozone.testing)

####### building a linear regression

ozone.linMod<-lm(ozone~., data=ozone.training)
summary(ozone.linMod)

####### visualize linear model #######

layout(matrix(c(1,2,3,4),2,2)) # optional 4 graphs/page 
plot(ozone.linMod)

####### To predict using linear regression model #####

ozone.linModPred = predict(ozone.linMod, newdata=ozone.testing)



####### Creating function that returns Root Mean Squared Error
rmse <- function(error)
{
    sqrt(mean(error^2))
}
 
####### Function that returns Mean Absolute Error
mae <- function(error)
{
    mean(abs(error))
}

####### Extract out the true response from test set ######

ozone.true.response<-ozone.testing[,1]

####### define error #######
 
error<-ozone.true.response-ozone.linModPred

####### calculate Root Mean Squared Error and Mean Absolute Error ####

ozone.rmse<-rmse(error)
ozone.rmse

ozone.mae<-mae(error)
ozone.mae


 





