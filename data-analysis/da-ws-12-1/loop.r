#5 loop??
#loop wohl so, klappt aber nicht.
p <- c(1, 0.5, 0.25, 0)
plotlist <- lapply(p, function(x){
  if(p != 0){
    p1[p] <- ggplot(lu, aes(sample=(lu$Agriculture**p-1)/p)) +stat_qq()+
      geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
      ggtitle(paste0("Normal Q-Q Plot, y**p-1/p for ", p))
  } else {
    p2[p] <- ggplot(lu, aes(sample=log(lu$Agriculture))) +stat_qq()+
      geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
      ggtitle("Normal Q-Q Plot, log(y)")
  }
  res <- list(p1,p2)
  return(res)
})
grid.arrange(plotlist, ncol = 2)



#6
lu$dist_norm <- rnorm(ppoints(length(lu$Settlement)))
pl1 <- ggplot(lu, aes(sample=(lu$dist_norm))) +stat_qq()+
  geom_abline(lm(quantile(lu$Settlement, probs = c(0.25, 0.75)) ~ 
                   quantile(lu$dist_gamma, probs = c(0.25, 0.75))), col = "red", lwd = 2)+
  ggtitle("Normal")

lu$dist_chi <- rchisq(ppoints(length(lu$Settlement)), df = 2)
p2 <- ggplot(lu, aes(lu$dist_chi)) +stat_qq()+
  geom_abline(lm(quantile(lu$Settlement, probs = c(0.25, 0.75)) ~ 
                   quantile(lu$dist_chi, probs = c(0.25, 0.75))), col = "red", lwd = 2)+
  ggtitle("Chi squared")

lu$dist_gamma <-  rgamma(length(lu$Settlement), shape = 0.6)
p3 <- ggplot(lu, aes(sample=lu$dist_gamma)) +stat_qq()+
  geom_abline(lm(quantile(lu$Settlement, na.rm = TRUE, probs = c(0.25, 0.75)) ~ 
                   quantile(lu$dist_gamma, probs = c(0.25, 0.75))), col = "red", lwd = 2)+
  ggtitle("Gamma")

lu$dist_weib <- rweibull(length(lu$Settlement), shape = 1)
p4 <- ggplot(lu, aes(lu$dist_weib)) +stat_qq()+
  geom_abline(lm(quantile(lu$Settlement, na.rm = TRUE, probs = c(0.25, 0.75)) ~ 
                   quantile(lu$dist_weib, probs = c(0.25, 0.75))), col = "red", lwd = 2)+
  ggtitle("Weibull")
grid.arrange(p1, p2, p3, p4, ncol = 2)
