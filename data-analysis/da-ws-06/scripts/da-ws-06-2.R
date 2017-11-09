#da-ws-06-2

#assess prediction performance winter barley yield 
# (based on yield numbers winter wheat), biv lin model
#cross-validation: mean of the root mean square error, its minimum, 25% 50% 
#and 75% quantile and maximum value across the cross-validation runs.

source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")

cp <- readRDS(paste0(path_da_rds,"feldfr_clean.rds"))

#vector logical: na-values in rows?
row.has.na <- apply(cp[,c(7,9)], 1, function(n){any(is.na(n))})
sum(row.has.na)
#test how many cases remain (7020)
nrow(cp)-sum(row.has.na)
x <- cp[!row.has.na,]

#root mean sqare error implemented in function rmse() in this package:
#install.packages("hydroGOF")
library(hydroGOF)

#Ausgabe: nur Fehler und Quantile des Fehlers
lmt82 <- lapply(seq(100), function(n){
  testdata <- x[sample(nrow(x), nrow(x)*0.8), ]
  traindata <- x[sample(nrow(x), nrow(x)*0.2), ]
  mod <- lm(Winter_wheat~Winter_barley, data=traindata)
  pred <- predict(mod, newdata = testdata)
  obsv <- testdata$Winter_wheat
  modrmse <- rmse(pred,obsv)
  model_r_squared <- summary(mod)$r.squared
  dflmt = data.frame(modrmse=modrmse, r_sq = model_r_squared,
                     pred=pred, obsv=obsv)
  dflmt
})
dflmt <- do.call("rbind", lmt82)
#rownames(dflmt) <- c(1:100)
dflmt
summary(dflmt[,1])
boxplot(dflmt[,1])

summary(dflmt$pred)
range(dflmt$pred)
boxplot(dflmt$pred)
mean(dflmt$pred)
sd(dflmt$pred)

summary(dflmt$obsv)
range(dflmt$obsv)
boxplot(dflmt$obsv)
mean(dflmt$obsv)
sd(dflmt$obsv)



#ADDITIONAL: return model in oder to plot residuals
lmt82 <- lapply(seq(100), function(n){
  testdata <- x[sample(nrow(x), nrow(x)*0.8), ]
  traindata <- x[sample(nrow(x), nrow(x)*0.2), ]
  mod <- lm(Winter_wheat~Winter_barley, data=traindata)
  pred <- predict(mod, newdata = testdata)
  obsv <- testdata$Winter_wheat
  modrmse <- rmse(pred,obsv)
  model_r_squared <- summary(mod)$r.squared
  df <- data.frame(pred = pred,
             obsv = obsv)
  df
})
df <- do.call("rbind", lmt82)
head(df)
df$res <- df$obsv-df$pred
par(mfrow=c(1,1))
plot(df$obsv, df$res)
