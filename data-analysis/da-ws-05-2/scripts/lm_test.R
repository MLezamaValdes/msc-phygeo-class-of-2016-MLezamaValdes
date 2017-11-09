path_main <- "E:/da-ws-05-2/"

ai <- readRDS(paste0(path_main,"AI001_clean.rds"))

#W05-1: Settlement vs. recreation
#Please write an R script which helps you to statistically describe the 
#relationship between the percentage settlement area and the respective 
#recreation area. For now, please restrict yourself to some kind of 
#linear modelling analysis.
names(ai)
ind<-ai$share_settlement_transport_infrastructure_in_total_areas
dep<-ai$share_recreational_in_total_areas

e<-NULL

for (i in (1:100)){
set.seed(i)
s <- sample(nrow(ai),50) #Zufallsfälle aus der Gesamtzahl der Zeilen gezogen
lmod <- lm(dep[s] ~ ind[s])
z<-shapiro.test(lmod$residuals)$p.value
e<-c(z,e)}

sum(e<0.05)
#shapiro.test(ObejektModell$residuals)

