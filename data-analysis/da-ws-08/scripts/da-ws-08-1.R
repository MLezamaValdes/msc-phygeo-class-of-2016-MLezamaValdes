#Ablauf Aufgabe 08-1

#install.packages("mgcv")
library(mgcv)
#install.packages("hydroGOF")
#library(hydroGOF)

source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
wood <- read.csv(paste0(path_data_da, "csv/hessen_holzeinschlag_1997-2014_clean.csv"))
#k=3

gamt<-lapply(seq(3,13), function(k){
  ret <- lapply(seq(100), function(n){
    set.seed(n)
    s1 <-sample(nrow(wood), 0.8*nrow(wood))
    train <- wood[s1,]
    test <- wood[-s1,]
    mod <- gam(Buche ~ s(Eiche, k=k, fx=TRUE), data=train) #keine penalty regression
    pred <- as.numeric(predict(mod, newdata = test))
    obsv <- test$Buche
    rmse <- sqrt(mean((pred-obsv)**2))
    r_sq <- summary(mod)$r.sq
    return(c(rmse, r_sq))
  })
  
  rmse_test <- as.numeric(lapply(ret, function(l) l[[1]]))
  mean_rmse <- mean(rmse_test)
  sd_rmse <- sd(rmse_test)
  r_sq_test <- as.numeric(lapply(ret, function(l) l[[2]]))
  mean_r_sq <- mean(r_sq_test)
  return(c(mean_rmse, sd_rmse, mean_r_sq))
})
gamtdf <- data.frame(matrix(unlist(gamt), nrow= length(gamt), byrow = T))
gamtdf$knots <- c(3:13)
names(gamtdf) <- c("mean_rmse", "SD_rmse", "adj.R2", "knots")
gamtdf$SD_rmse <- gamtdf$SD_rmse / max(gamtdf$mean_rmse)
gamtdf$mean_rmse <- gamtdf$mean_rmse / max(gamtdf$mean_rmse)

gamtdf$sdplus <- gamtdf$mean_rmse+gamtdf$SD_rmse
gamtdf$sdminus <- gamtdf$mean_rmse-gamtdf$SD_rmse
gamtdf
plot(gamtdf$knots)
plot(gamtdf$knots, gamtdf$mean_rmse, type="l", ylim=c(-0.1, 1.5), col = "black", lwd = 2)
lines(gamtdf$knots, gamtdf$sdplus, col = "red", lty = "dotted")
lines(gamtdf$knots, gamtdf$sdminus, col = "red", lty = "dotted")
lines(gamtdf$knots, gamtdf$adj.R2, col = "blue")

legend("topleft", legend=c("sdplus/sdminus", "adj.R2", "mean_rmse" ), col=c("red", "blue", "black"), lty= c(3,1,1), cex=0.8, title = "Legend")
