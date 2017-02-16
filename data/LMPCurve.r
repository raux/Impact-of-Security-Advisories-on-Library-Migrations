
#Combine to make the libVersion
library(ggplot2)
library(gridExtra)
library(sqldf)
library(plyr)
require(stringr) 

lib.getThreeCurve <- function(lib1,lib2,lib3,dataSet,timePeriod,timePeriodPre,timePeriodPost, endtime){
#get the LMP1
ver2 <- paste("'", lib1, sep="")
ver3 <- paste(ver2,"'order by dependsDate,repoSys, type  ASC" , sep="")
focus <- paste("SELECT repo,repoSys, dependsDate, initial, latest, type,libSum FROM ",dataSet," where artifactLib = ", ver3, sep=" ")
system.time(sampleLib1 <- sqldf(focus))

#get the LMP2
ver2 <- paste("'", lib2, sep="")
ver3 <- paste(ver2,"'order by dependsDate,repoSys, type  ASC" , sep="")
focus <- paste("SELECT repo,repoSys, dependsDate, initial, latest, type,libSum FROM ",dataSet," where artifactLib = ", ver3, sep=" ")
sampleLib2 <- sqldf(focus)

#get the LMP3
ver2 <- paste("'", lib3, sep="")
ver3 <- paste(ver2,"'order by dependsDate,repoSys, type  ASC" , sep="")
focus <- paste("SELECT repo,repoSys, dependsDate, initial, latest, type,libSum FROM ",dataSet," where artifactLib = ", ver3, sep=" ")
sampleLib3 <- sqldf(focus)


sampleLib1$population <- 0
sampleLib2$population <- 0
sampleLib3$population <- 0

art <- nrow(sampleLib1)
count = 1;
for (i in 1:art){
	
	if (sampleLib1[i,6]=="a"){
		sampleLib1[i,8] <- count
		count <- count+1
	}
	
	if (sampleLib1[i,6]== "b"){
		#check if a and b are same
		if(as.numeric(difftime(as.Date(sampleLib1[i,5]),
		as.Date(sampleLib1[i,3]),units = "mins"))== 0){
			#sampleLib[i,7]<- count
		}else{
			sampleLib1[i,8] <- count
			count <- count-1
		}
	}
}
art <- nrow(sampleLib2)
count = 1;
for (i in 1:art){
	
	if (sampleLib2[i,6]=="a"){
		sampleLib2[i,8] <- count
		count <- count+1
	}
	
	if (sampleLib2[i,6]== "b"){
		#check if a and b are same
		if(as.numeric(difftime(as.Date(sampleLib2[i,5]),
		as.Date(sampleLib2[i,3]),units = "mins"))== 0){
			#sampleLib[i,7]<- count
		}else{
			sampleLib2[i,8] <- count
			count <- count-1
		}
	}
}
art <- nrow(sampleLib3)
count = 1;
for (i in 1:art){
	
	if (sampleLib3[i,6]=="a"){
		sampleLib3[i,8] <- count
		count <- count+1
	}
	
	if (sampleLib3[i,6]== "b"){
		#check if a and b are same
		if(as.numeric(difftime(as.Date(sampleLib3[i,5]),
		as.Date(sampleLib3[i,3]),units = "mins"))== 0){
			#sampleLib[i,7]<- count
		}else{
			sampleLib3[i,8] <- count
			count <- count-1
		}
	}
}

ver2 <- paste("'", timePeriod, sep="")
ver3 <- paste(ver2,"'" , sep="")
focus <- paste("SELECT  * from sampleLib1 where population !='0' AND latest > ", ver3, sep=" ")
sampleLib1 <- sqldf(focus)
sampleLib1$lib<-lib1
sampleLib1$t<-0

ver2 <- paste("'", timePeriod, sep="")
ver3 <- paste(ver2,"'" , sep="")
focus <- paste("SELECT  * from sampleLib2 where population !='0' AND latest > ", ver3, sep=" ")
sampleLib2 <- sqldf(focus)
sampleLib2$lib<-lib2
sampleLib2$t<-0

ver2 <- paste("'", timePeriod, sep="")
ver3 <- paste(ver2,"'" , sep="")
focus <- paste("SELECT  * from sampleLib3 where population !='0' AND latest > ", ver3, sep=" ")
sampleLib3 <- sqldf(focus)
sampleLib3$lib<-lib3
sampleLib3$t<-0

focus <- paste("SELECT  * from sampleLib1 group by t")
newrow <- sqldf(focus)
newrow [3] <- "2015-12-12"
sampleLib1 <- rbind(sampleLib1,newrow) 

focus <- paste("SELECT  * from sampleLib2 group by t")
newrow <- sqldf(focus)
newrow [3] <- "2015-12-12"
sampleLib2 <- rbind(sampleLib2,newrow)

focus <- paste("SELECT  * from sampleLib3 group by t")
newrow <- sqldf(focus)
newrow [3] <- "2015-12-12"
sampleLib3 <- rbind(sampleLib3,newrow)  

art <- nrow(sampleLib1)
for (i in 1:art){
	sampleLib1[i,10]<-i	
}

art <- nrow(sampleLib2)
for (i in 1:art){
	sampleLib2[i,10]<-i	
}

art <- nrow(sampleLib3)
for (i in 1:art){
	sampleLib3[i,10]<-i	
}

focus <- paste("SELECT  repo, repoSys, count(repoSys) as C from sampleLib1 group by repoSys order by C DESC")

general<-rbind(sampleLib1,sampleLib2)
general<-rbind(general,sampleLib3)

general$dependsDate<- as.Date(general$dependsDate, "%Y-%m-%d")

p2 <- ggplot(general,aes(x=dependsDate,y= population, group=libSum, colour=libSum,))

p2+ geom_point(size=1)+stat_smooth()+ theme_bw(base_size = 12, base_family = "")+ theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+ scale_shape(solid = FALSE)+ labs(title= paste(""), y=" Library Usage by Systems ", x=" Time t")+ geom_vline(xintercept=as.numeric(timePeriodPost), linetype=4,colour="black")+ geom_vline(xintercept=as.numeric(timePeriodPre), linetype=4,colour="black")
}