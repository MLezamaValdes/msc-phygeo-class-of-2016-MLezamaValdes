#install.packages("ggplot2")
#install.packages("lattice")
library(lattice)
library(ggplot2)
library(gridExtra)

source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
lu <- readRDS(paste0(path_da_rds,"AI001_clean.rds"))
colnames(lu)<-c("ID", "Year", "Placea", "att_1", "att_2", "Placeb", "Settlement", "Recreation", "Agriculture", "Forest")
numc <- names(lu[,7:10])
#saveRDS(lu, file=paste0(path_da_rds, "AI001_clean_2.rds"))head(lu)

#change format
lul <- reshape2::melt(lu, id.vars = c("ID", "Year", "Placea", "att_1", "att_2", "Placeb"))

#1
boxplot(lu[, numc])

#ggplot: 
ggplot(lul, aes(x=variable, y=value)) + geom_boxplot() +
  stat_boxplot(geom = "errorbar", width = 0.5) +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill=F, colour = "black", size = 1))+
  labs(y="", x="")+geom_boxplot(fatten = 2.5) 


#2
par_org <- par()
par(mfrow = c(2,2))
boxplot(lu[, numc], main = "Original")
boxplot(lu[, numc]**0.5, main = "Square root")
boxplot(lu[, numc]**(1/3), main = "Cube root")
boxplot(log(lu[, numc]), main = "Log")

dev.off()

p1 <- ggplot(lul, aes(x=variable, y=value)) + geom_boxplot()+ggtitle("Original")+
  stat_boxplot(geom = "errorbar", width = 0.5) +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill=F, colour = "black", size = 1))+
  labs(y="", x="")+geom_boxplot(fatten = 2.5) 
p2 <- ggplot(lul, aes(x=variable, y=value**0.5)) + geom_boxplot()+ggtitle("Square root")+
  stat_boxplot(geom = "errorbar", width = 0.5) +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill=F, colour = "black", size = 1))+
  labs(y="", x="")+geom_boxplot(fatten = 2.5) 
p3 <- ggplot(lul, aes(x=variable, y=value**(1/3))) + geom_boxplot()+ggtitle("Cube root")+
  stat_boxplot(geom = "errorbar", width = 0.5) +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill=F, colour = "black", size = 1))+
  labs(y="", x="")+geom_boxplot(fatten = 2.5) 
p4 <- ggplot(lul, aes(x=variable, y=log(value))) + geom_boxplot()+ggtitle("Log")+
  stat_boxplot(geom = "errorbar", width = 0.5) +
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill=F, colour = "black", size = 1))+
  labs(y="", x="")+geom_boxplot(fatten = 2.5) 
grid.arrange(p1, p2, p3, p4, ncol = 2, top = "Landuse and Transformations")


#3
par(mfrow=c(1,1))
hist(lu$Settlement)

ggplot(data=lu, aes(lu$Settlement)) + 
  geom_histogram(color = "black", fill = "white", binwidth = 5)+
  theme(panel.background = element_rect(fill = "white"))+
  labs(y="Frequency", x="lu$Settlement")+ggtitle("Histogram of lu$Settlement")+
  theme(plot.title = element_text(hjust = 0.5))

#4
qqnorm(lu$Agriculture)
qqline(lu$Agriculture, col = "red", lwd = 2)
abline(h=quantile(lu$Agriculture, probs = c(0.25,0.75), na.rm = TRUE), col="blue", lty = 3)
abline(v=qnorm(c(0.25,0.75)), col="blue", lty = 3)

#ggplot
y <- quantile(lu$Agriculture[!is.na(lu$Agriculture)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
ggplot(lu, aes(sample=lu$Agriculture)) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  geom_vline(xintercept = as.numeric(x[1L]), colour="blue", linetype = "longdash")+
  geom_vline(xintercept = as.numeric(x[2L]), colour="blue", linetype = "longdash")+
  geom_hline(yintercept = y, colour="blue", linetype = "longdash")+
  ggtitle("Normal Q-Q Plot")+
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill=F, colour = "black", size = 1),
        plot.title = element_text(hjust = 0.5))+labs(y="Sample Quantiles", 
                                                     x="Theoretical Quantiles")

#5
par(mfrow = c(2,2))
for(p in c(1, 0.5, 0.25, 0)){
  if(p != 0){
    qqnorm((lu$Agriculture**p-1)/p, main = paste0("Normal Q-Q Plot, y**p-1/p for ", p))
    qqline((lu$Agriculture**p-1)/p, col = "red")  
  } else {
    qqnorm(log(lu$Agriculture), main = "Normal Q-Q Plot, log(y)")
    qqline(log(lu$Agriculture), col = "red")
  }
}

#speichert nicht den Plot an sich, sondern ruft ihn neu auf, deshalb Problem mit
#variierendem p, man kann nicht ein Grid vorgeben in das geprintet werden soll. 
p <- 1
y <- quantile(((lu$Agriculture**p-1)/p)[!is.na(lu$Agriculture)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
p1 <- ggplot(lu, aes(sample=(lu$Agriculture**p-1)/p)) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  ggtitle(paste0("Normal Q-Q Plot, y**p-1/p for ", p))+
  theme(panel.background = element_rect(fill = "white"))

q <- 0.5
y <- quantile(((lu$Agriculture**q-1)/q)[!is.na(lu$Agriculture)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
p2 <- ggplot(lu, aes(sample=(lu$Agriculture**q-1)/q)) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  ggtitle(paste0("Normal Q-Q Plot, y**p-1/p for ", q))+
  theme(panel.background = element_rect(fill = "white"))

r <- 0.25
y <- quantile(((lu$Agriculture**r-1)/r)[!is.na(lu$Agriculture)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
p3 <- ggplot(lu, aes(sample=(lu$Agriculture**r-1)/r)) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  ggtitle(paste0("Normal Q-Q Plot, y**p-1/p for ", r))+
  theme(panel.background = element_rect(fill = "white"))

y <- quantile((log(lu$Agriculture))[!is.na(lu$Agriculture)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
p4 <- ggplot(lu, aes(sample=log(lu$Agriculture))) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  ggtitle("Normal Q-Q Plot, log(y)")+
  theme(panel.background = element_rect(fill = "white"))
grid.arrange(p1, p2, p3, p4, ncol = 2)


#6
dev.off()
par(mfrow = c(2,2))
dist <- rnorm(ppoints(length(lu$Settlement)))
qqplot(dist, lu$Settlement, main = "Normal")
abline(lm(quantile(lu$Settlement, na.rm = TRUE, probs = c(0.25, 0.75)) ~ 
            quantile(dist, probs = c(0.25, 0.75))), col = "red", lwd = 2)

dist <- rchisq(ppoints(length(lu$Settlement)), df = 2)
qqplot(dist, lu$Settlement, main = "Chi squared")
abline(lm(quantile(lu$Settlement, na.rm = TRUE, probs = c(0.25, 0.75)) ~ 
            quantile(dist, probs = c(0.25, 0.75))), col = "red", lwd = 2)

dist <- rgamma(length(lu$Settlement), shape = 0.6)
qqplot(dist, lu$Settlement, main = "Gamma")
abline(lm(quantile(lu$Settlement, na.rm = TRUE, probs = c(0.25, 0.75)) ~ 
            quantile(dist, probs = c(0.25, 0.75))), col = "red", lwd = 2)

dist <- rweibull(length(lu$Settlement), shape = 1)
qqplot(dist, lu$Settlement, main = "Weibull")
abline(lm(quantile(lu$Settlement, na.rm = TRUE, probs = c(0.25, 0.75)) ~ 
            quantile(dist, probs = c(0.25, 0.75))), col = "red", lwd = 2)

#ggplot
lu$dist_norm <- rnorm(ppoints(length(lu$Settlement)))
y <- quantile(lu$dist_norm[!is.na(lu$dist_norm)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
p1 <- ggplot(lu, aes(sample=(lu$dist_norm))) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  ggtitle("Normal")+theme(panel.background = element_rect(fill = "white"))

lu$dist_chi <- rchisq(ppoints(length(lu$Settlement)), df = 2)
y <- quantile(lu$dist_chi[!is.na(lu$dist_chi)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
p2 <- ggplot(lu, aes(sample=lu$dist_chi)) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  ggtitle("Chi squared")+theme(panel.background = element_rect(fill = "white"))

lu$dist_gamma <-  rgamma(length(lu$Settlement), shape = 0.6)
y <- quantile(lu$dist_gamma[!is.na(lu$dist_gamma)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
p3 <- ggplot(lu, aes(sample=lu$dist_gamma)) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  ggtitle("Gamma")+theme(panel.background = element_rect(fill = "white"))

lu$dist_weib <- rweibull(length(lu$Settlement), shape = 1)
y <- quantile(lu$dist_weib[!is.na(lu$dist_weib)], c(0.25, 0.75))
x <- qnorm(c(0.25, 0.75))
slope <- diff(y)/diff(x)
int <- y[1L] - slope * x[1L]
p4 <- ggplot(lu, aes(sample=lu$dist_weib)) +stat_qq()+
  geom_abline(slope = slope, intercept = int, col="red", lwd=1,5)+
  ggtitle("Weibull")+theme(panel.background = element_rect(fill = "white"))
grid.arrange(p1, p2, p3, p4, ncol = 2)


#7
dev.off()
plot(lu$Settlement, lu$Recreation)

ggplot(lu, aes(lu$Settlement, lu$Recreation)) + geom_point()+
  theme(panel.background = element_rect(fill = "white"),
        panel.border = element_rect(fill=F, colour = "black", size = 0.75))

#8
plot(lu[, numc])
pairs(lu[,numc])