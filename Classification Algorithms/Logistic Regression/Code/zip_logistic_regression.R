######################################################################################
## Objective: Machine learning on hand-written digits recognition with            	##
##		  logistic regression model.								##
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

###### create new training and testing datasets for logistic regression ######

log.zip.training<-zip.training
log.zip.testing<-zip.testing


###### convert V1 (response) to factor for training and testing dataset#####
log.zip.training[,1]<-as.factor(log.zip.training[,1])
log.zip.testing[,1]<-as.factor(log.zip.testing[,1])



###### Build logistic regression model with log.zip.training dataset####


zip.logMod<-glm(ModForm,data=log.zip.training, family = "binomial",maxit=200)

###### extract logistic regression model summary #####

zip.logMod

####### To predict using logistic regression model #####

zip.logModPred = predict(zip.logMod, log.zip.testing, type="response")

###### Visualize partial prediction output####

head(zip.logModPred)

########assign labels with decision rule, >0.5= "2", <0.5="3"#####

zip.logLabel<-ifelse(zip.logModPred>=0.5, "3", "2")


###### extract out true label for zip.testing dataset####

zip.logTrueLabel<-as.character(log.zip.testing[,1])

########reassign "2" and "3" to factor in testing set#####

zip.logPredTable<-cbind(zip.logTrueLabel, zip.logLabel)

zip.logPredTable<-as.data.frame(zip.logPredTable)

####### To compare how many false prediction ###
zip.logPredTable$check<-ifelse(zip.logPredTable$zip.logTrueLabel==zip.logPredTable$zip.logLabel,0,1)




####### Count the number of wrong prediction ###
sum(zip.logPredTable$check)

####### extract out the row that has wrong prediction####

log.error.pred<-subset(zip.logPredTable,zip.logPredTable$check==1)
log.error.pred


##### visualize error prediction from both linear and logistic regression ####
##### eg. row 128, 280, 510 on testing set ######

levelplot(matrix(zip.test[280,2:257],nrow=16, byrow=TRUE))

###### confusion table for classification
zip.table<-table(zip.logPredTable$zip.logTrueLabel,zip.logPredTable$zip.logLabel)
zip.table




