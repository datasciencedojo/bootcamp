######################################################################################
## Objective: K-Means clustering on hand-written digits recognition.           	##
##		 												##
## Data source: zip.train.csv    (please download from GitHub to your local drive)  ##
##		    												##
##														##
######################################################################################

install.packages("stats")
install.packages("fpc")

library(stats)
library(fpc)

zip.data<-read.csv("zip.train.csv",header= F)

n.points<-nrow(zip.data)  


#######  randomly sample which rows will go in the trainning set  #######
set.seed(100)

random.no<-sample(1:n.points,500,replace=F)

zip.sub<-zip.data[random.no,]

######## scale the data  #####

zip.scale<-as.data.frame(scale(zip.sub[,-1]))

attach(zip.scale)

######## K-means clustering model ####

zip.KM<-kmeans(zip.scale, 10,iter.max = 100, nstart = 25)

zip.KM

######## subset out each cluster to investigate the data #####

zip.KM.clust<- lapply(1:10, function(nc) zip.sub[,1][zip.KM$cluster==nc])  

zip.KM.clust

########  plots to visualize the clusters #####

par(mfrow=c(1,1))

plotcluster(zip.scale, zip.KM$cluster)
