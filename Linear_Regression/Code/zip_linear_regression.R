######################################################################################
## Objective: Machine learning on hand-written digits recognition with            	##
##		  linear regression model.								##
## Data source: zip.train.csv    (please download from GitHub to your local drive)  ##
##		    zip.test.csv     (please download from GitHub to your local drive)  ##
##														##
######################################################################################
																										##
####import both zip.train and zip.test to R, make sure you set up your known working directory.########

zip.train<-read.csv("zip.train.csv", header=FALSE)
zip.test<-read.csv("zip.test.csv", header=FALSE)


####visualize data####

library(lattice)
levelplot(matrix(zip.train[5,2:257],nrow=16, byrow=TRUE))

####check for dataset dimension#####
dim(zip.train)
dim(zip.test)
head(zip.train)

######  Retaining Labels "2" and "3" in training and testing datasets  ####

zip.training<-subset(zip.train,zip.train$V1==2 | zip.train$V1==3)
zip.testing<-subset(zip.test,zip.test$V1==2 | zip.test$V1==3)


###### to create a linear regression formula#####

ModForm<-paste("V1~",paste(paste("V",2:257,sep=""),collapse="+"),sep="")


###### To check for attributes, make sure they are in the right attributes#####

str(zip.training)
str(zip.testing)

###### Build linear model with zip.training dataset####

zip.linMod<-lm(ModForm,data=zip.training)


###### extract linear regression model summary #####
summary(zip.linMod)

head(zip.linMod$coefficients)

head(zip.linMod$fitted.values)

head(zip.linMod$residuals)

####### To predict using linear regression model #####

zip.linModPred = predict(zip.linMod, newdata=zip.testing)


###### Visualize partial prediction output####

head(zip.linModPred)

########round the number to obtain digit#####

zip.ln.result<-round(zip.linModPred, digit=0)


###### Visualize partial output####
head(zip.ln.result)

###### extract out true label for zip.testing dataset####

zip.true.label<-zip.testing[,1]

ln.pred.table<-cbind(zip.true.label, zip.ln.result)

ln.pred.table<-as.data.frame(ln.pred.table)

####### To compare how many false prediction ###
ln.pred.table$check<-ifelse(ln.pred.table$zip.ln.result==ln.pred.table$zip.true.label, 0, 1)


####### Count the number of wrong prediction ###
sum(ln.pred.table$check)

####### extract out the row that has wrong prediction####

ln.error.pred<-subset(ln.pred.table, ln.pred.table$check==1)

ln.error.pred

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

####### define error #######
 
error<-ln.pred.table$zip.true.label-ln.pred.table$zip.ln.result


####### calculate Root Mean Squared Error and Mean Absolute Error ####

zip.rmse<-rmse(error)
zip.rmse

zip.mae<-mae(error)
zip.mae








