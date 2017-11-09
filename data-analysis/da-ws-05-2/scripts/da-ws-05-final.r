
install.packages("car")
library(car)

# da-ws-05-1
path_main<- "E:/da-ws-05-2/"

cp_final<-readRDS(paste0(path_main,"feldfr_clean.rds"))
ind<-cp_final$Winter_barley
dep<-cp_final$Winter_wheat
## Assignment 1: visualize relationship between winter wheat and winter barley
# result of modeling and visual test for homoscedasticity
par(mfrow=c(2,2))
lmo<- lm(dep~ind)

#standardize fitted values
lmo_fv<- lmo$fitted.values
lmo_fv_st<-scale(lmo_fv)
#test if standardization worked
mean(lmo_fv_st)
sd(lmo_fv_st)

#standardize model residuals
lmo_r<- lmo$residuals
lmo_r_st<- scale(lmo_r)
#test if standardization worked
mean(lmo_r_st)
sd(lmo_r_st)

#plot standardized residuals x standardized fitted values in order to visualize
#heteroscedasticity
plot(lmo)  
par(mfrow=c(1,1))
plot(lmo_r_st~lmo_fv_st)
# as no funnel-Shaped distribution can be detected, data seem to be distributed
#in a homoscedastic way

## Assignment 2: distribution test with random data from the columns 
#winter_barley and winter_wheat
pvalues1<- NULL
pvalues2<-NULL

for (i in (1:100)){
  set.seed(i)
  s1 <-sample(nrow(subset(cp_final,(!is.na(cp_final[,7]))&
                            (!is.na(cp_final[,9])))),50)
  s2 <-sample(nrow(subset(cp_final,(!is.na(cp_final[,7]))&
                            (!is.na(cp_final[,9])))),100)
  #samples only with non-na-data
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

#We decided to use Shapiro-Wilkinson as its decisions are more conservative, 
#which means that Null-Hypothesis (distribution being normal distributed) is 
#being rejected more often.
#In our case in the random sample of 50cases, 27 turn out to be non-normal
#distributed and in case of 100 in 45 cases. 


