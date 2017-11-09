
#ein Durchlauf
lmt82 <- lapply(seq(1), function(n){
  testdata <- x[sample(nrow(x), nrow(x)*0.8), ]
  traindata <- x[sample(nrow(x), nrow(x)*0.2), ]
  mod <- lm(Winter_wheat~Winter_barley, data=traindata)
  pred <- predict(mod, newdata = testdata)
  obsv <- testdata$Winter_wheat
  model_r_squared <- summary(mod)$r.squared
  dflmt = list(pred=pred, obsv=obsv, model_r_squared=model_r_squared)
  attributes(dflmt) = list(names = names(dflmt),
                           row.names=1:max(length(pred), length(obsv), 
                                           length(model_r_squared)), 
                           class='data.frame')
  dflmt
})

dflmt <- do.call("rbind", lmt82)


#100 Durchläufe, alles gedruckt für pred
lmt82 <- lapply(seq(100), function(n){
  testdata <- x[sample(nrow(x), nrow(x)*0.8), ]
  traindata <- x[sample(nrow(x), nrow(x)*0.2), ]
  mod <- lm(Winter_wheat~Winter_barley, data=traindata)
  pred <- predict(mod, newdata = testdata)
  obsv <- testdata$Winter_wheat
  model_r_squared <- summary(mod)$r.squared
  dflmt = data.frame(min=quantile(pred)[1],
                     q25=quantile(pred)[2],
                     q50=quantile(pred)[3],
                     q75=quantile(pred)[4],
                     max=quantile(pred)[5],
                     model_r_squared=model_r_squared,
                     rmse=rmse(pred,obsv))
  dflmt
})
dflmt <- do.call("rbind", lmt82)
rownames(dflmt) <- c(1:100)
dflmt
