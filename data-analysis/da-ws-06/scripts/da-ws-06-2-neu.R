#da-ws-06-2-neu
source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")

cp <- readRDS(paste0(path_da_rds,"feldfr_clean.rds"))
view(cp)

#CLEANING OF DATASET
#vector logical: na-values in rows?
row.has.na <- apply(cp[,c(7,9)], 1, function(n){any(is.na(n))})
sum(row.has.na)
#test how many cases remain
nrow(cp)-sum(row.has.na)
x <- cp[!row.has.na,]

#80-20-IMPLEMENTATION
lm82 <- lapply(seq(100), function(n){
  set.seed(n)
  s1 <-sample(nrow(x), 0.8*nrow(x)) 
  traindata <- x[s1,]
  testdata <- x[-s1,]
  mod <- lm(Winter_wheat~Winter_barley, data=traindata)
  pred <- predict(mod, newdata = testdata)
  obsv <- testdata$Winter_wheat
  modrmse <- sqrt(mean((obsv-pred)**2))
})

summary(unlist(lm82))
boxplot(unlist(lm82))

#leave-one-out-IMPLEMENTATION
lm82 <- lapply(seq(100), function(n){
  set.seed(n)
  traindata <- x[-n,]
  testdata <- x[n,]
  mod <- lm(Winter_wheat~Winter_barley, data=traindata)
  pred <- predict(mod, newdata = testdata)
  obsv <- testdata$Winter_wheat
  modrmse <- sqrt(mean((obsv-pred)**2))
})

summary(unlist(lm82))
boxplot(unlist(lm82))

#50-50-IMPLEMENTATION
lm82 <- lapply(seq(100), function(n){
  set.seed(n)
  s1 <-sample(nrow(x), 0.5*nrow(x)) 
  traindata <- x[s1,]
  testdata <- x[-s1,]
  mod <- lm(Winter_wheat~Winter_barley, data=traindata)
  pred <- predict(mod, newdata = testdata)
  obsv <- testdata$Winter_wheat
  modrmse <- sqrt(mean((obsv-pred)**2))
})

summary(unlist(lm82))
boxplot(unlist(lm82))