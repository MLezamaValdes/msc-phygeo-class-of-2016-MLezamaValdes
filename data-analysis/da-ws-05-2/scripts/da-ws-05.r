install.packages("car")
library(car)
# da-ws-05-1
path_main<- "C:/Users/lukas/Documents/Uni/Master/Grundlagen/data/data_analysis/"
path_csv<- paste0(path_main, "csv/")
path_result<- "C:/Users/lukas/Documents/Uni/Master/Grundlagen/msc-phygeo-class-of-2016-LDitzel/data_analysis/da-ws-05-1/" 


path_result<- paste0(path_main, "msc-phygeo-class-of-2016-LDitzel/data_analysis/da-ws-05-2")

cp_final<-read.csv(paste0(path_csv, "cp_final.csv"))
ind<-cp_final$winter.barley
dep<-cp_final$winter.wheat

par(mfrow=c(2,2))
lmo<- lm(dep~ind)
lmo_fv<- lmo$fitted.values
lmo_fv_st<-scale(lmo_fv)
mean(lmo_fv_st)
sd(lmo_fv_st)
lmo_r<- lmo$residuals
lmo_r_st<- scale(lmo_r)
plot(lmo_r_st~lmo_fv_st)
plot(lmo)     

## Assignment 2: distribution test with random data from the columns winter_barley and winter_wheat
pvalues1<- NULL
pvalues2<-NULL

for (i in (1:100)){
  set.seed(i)
  s1 <-sample(nrow(subset(cp_final,(!is.na(cp_final[,7]))&(!is.na(cp_final[,9])))),50)
  s2 <-sample(nrow(subset(cp_final,(!is.na(cp_final[,7]))&(!is.na(cp_final[,9])))),100)
  lmod1 <- lm(dep[s1] ~ ind[s1])
  lmod2 <- lm(dep[s2] ~ ind[s2])
  p1<-shapiro.test(lmod1$residuals)$p.value
  p2<-shapiro.test(lmod2$residuals)$p.value
  pvalues1<-c(p1,pvalues1)
  pvalues2<-c(p2,pvalues2)
  num1<-sum(pvalues1<0.05)
  num2<-sum(pvalues2<0.05)
  df<-data.frame("sample of 50"=num1, "sample of 100"=num2)
  }
print(df)

