#settlement & recreation: leave 1 out, HA dann 80:20, lassen es 100x laufen

source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")

ai<-readRDS(paste0(path_da_rds,"AI001_clean.rds"))

#lmo_r2<- summary(lm(dep~ind))$r.squared

x <- ai[!is.na(ai$share_recreational_in_total_areas),] 
x <- ai[!is.na(ai$share_settlement_transport_infrastructure_in_total_areas),]
nrow(x)

cv <- lapply(seq(nrow(ai)), function(n){
  lmod <- lm(share_recreational_in_total_areas~share_settlement_transport_infrastructure_in_total_areas,data=ai)
  train <- ai[-n,]
  test <- ai[n,]
  pred <- predict(lmod, newdata = test)
  obsv <- test$share_recreational_in_total_areas
  model_r_squared <- summary(lmod)$r.squared
  data.frame(pred = pred,
             obsv = obsv,
             model_r_squared = summary(lmod)$r.squared)
  })
cv <- do.call("rbind", cv)
cv

#man sagt mit neuen Daten hervor, die sind in test
#data=train steht da, weil R sonst denkt die Spaltennamen, die in der Funktion die Spaltennamen angeben, sind Objekte
#osbv = test$recreation tatsächlich beobachteter Wert aus dem Datensatz, 
data.frame(pred=pred,
           obsv=obsv,
           r_squared=summary(lmod.... siehe oben))
cv=do.call()
#mean(cv$pred-cv$obs)

#HA genauso wie im Code-example 100 zufällige Sample, 80% in Training, -80 in Test
