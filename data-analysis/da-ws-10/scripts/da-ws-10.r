source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
stat_c <- paste0(path_da_stat, "dwd_stationsdaten_3164_coelbe/")

dat <- read.csv(paste0(stat_c, "produkt_synop_Terminwerte_20060701_20151231_03164.txt"), sep=";", header=T)

#nicht nötig: Datumsformat anpassen
dat$DATUM<- strptime(paste0(dat$MESS_DATUM, "00"), format = "%Y%m%d%H%M")
head(dat$DATUM)

#Monatsaggregation
dat$AGG_M <- substr(dat$MESS_DATUM, 1, 6)
head(dat$AGG_M)

#Aggregation der Monatsniederschläge
nd <- aggregate(dat$NIEDERSCHLAGSHOEHE, by=list(dat$AGG_M), FUN= sum)
head(nd)
colnames(nd) <- c("Date", "precip")

#try to find an ARIMA model for predicting monthly precipitation data
#split test (ab Jan 2014) und train (bis Dez 2013)
which(nd$Date == 201312)
train <- nd[1:90,] 
test <- nd[91:114,] 

#Parameterkombis erstellen und jeweils ein Modell rechnen
expg <- expand.grid(p=seq(0,5), d=seq(0,2), q=seq(0,5),
                    ps=seq(0,2), ds=seq(0,2), qs=seq(0,2))

#model_ready
precpred <- lapply(seq(nrow(expg)), function(x){
  armod <- arima(train$precip, order = unlist(expg[x,1:3]), 
                 seasonal=unlist(expg[x,4:6]), method = "ML")
  pred <- predict(armod, n.ahead = 24)
  predn <- unlist(pred$pred)#hier Fehler
  obs <- test$precip
  rmse <- sqrt(mean((predn-obs)**2))
  list(rmse, armod)
  })

#saveRDS(precpred,file=paste0(stat_c, "prediction_best_model.rds"))
#testprecpred <- readRDS(paste0(stat_c, "prediction_best_model.rds"))

#find optimal model: rmse min 
v <- lapply(seq(length(precpred)), function(x){
  v <- precpred[[x]][[1]]
})
rmse <- unlist(v)
which.min(rmse)
#best model 
best <- precpred[[2054]][[1]]

#comparison with forecast auto-arima
#install.packages("forecast")
library(forecast)
auto <- auto.arima(train$precip, max.p = 5, max.d = 2, max.q = 5)
summary(auto)

#compare rmse's of self- and autoprediction
rmse_best <- precpred[[1021]][[1]] ##32.03936
summary(auto) ##rmse hier 27.6043 - gegen was testet der denn? haben hier ja 
#nicht den test-Datensatz angegeben?!

#results: pedict with retrieved and automatic model (2 plots+observed values)
#automatic model
autopred <- predict(auto, n.ahead = 24)
df_autopred <- data.frame(unlist(autopred))
#weitere Angaben (se1:24) kürzen
df_auto <- data.frame(df_autopred[1:24,1])
#add empty lines in order to plot prediction for final 2 years
df0 <- as.data.frame(matrix(data=NA, nrow=90, ncol=1))
colnames(df0) <- "autopred"
colnames(df_auto) <- "autopred"
pred_data <- rbind(df0,df_auto)

#best retrieved model with parameter test
selfpred <- predict(best, n.ahead=24)
df_selfpred <- data.frame(unlist(autopred))
df_self <- data.frame(df_selfpred[1:24,1])
colnames(df0) <- "selfpred"
colnames(df_self) <- "selfpred"
selfpred_data <- rbind(df0, df_self)
pred_data$selfpred <- selfpred_data
#rmse-Fehlerspanne self
pred_data$rmseplus <- pred_data$selfpred+rmse_best
pred_data$rmseminus <- pred_data$selfpred-rmse_best
pred_data$autoplus <- pred_data$autopred+27.60431
pred_data$autominus <- pred_data$autopred-27.60431
head(pred_data)

#plot results: 
##arima_Modell$x ist Modellinput (Training bei uns)
par(mfrow=c(1,2), oma=c(2,2,2,2),xpd=NA)
plot(nd$precip, type="l", col="black", xlim=c(0,115), main="autoprediction", 
     ylab="montly precipitation height", xlab="months") 
lines(fitted(auto),col="blue")
lines(pred_data$selfpred,type="l", col="green")
lines(pred_data$autoplus, type="l", col="gray")
lines(pred_data$autominus, type="l", col="gray")
plot(nd$precip, type="l", col="black", xlim=c(0,115), main="prediction with 
     parameters", ylab="montly precipitation height", xlab="months")
lines(fitted(best), col="blue")
lines(pred_data$autopred,type="l", col="red") 
lines(pred_data$rmseplus, col="gray")
lines(pred_data$rmseminus, col="gray")
legend(-120,-40, legend=c("observed monthly precipitation", 
                                                 "fitted values", "autoprediction",
                            "prediction with parameters", "prediction_rmse"), cex = 0.5,
       horiz=F, col=c("black", "blue", "green", "red", "gray"), lty = 1)
#statement about differences: 
#The two predictions are exactly the same.