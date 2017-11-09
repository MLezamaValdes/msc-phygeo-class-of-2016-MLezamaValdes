source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")

#Optimum des Fehlers bei Vorwärtsauswahl = Abbruchkriterium
path_cp <- paste0(path_da_rds,"feldfr_clean.rds")
cp <- readRDS(path_cp)

biv <- combn(ncol(cp[7:16]),2)
for i in seq(biv){
  lm(biv[y]~biv[,i])
if (lmod) {
  statement1
} else {
  statement2
}
  
#Abbruch: wenn Fehler größer ist als im letzten Lauf
  
}

{
  1.	Lm(bivariat)
  Best: adjR² max / aic min
  2.	lm(bivariat best+alle andern einzeln)
  Best: adjR² max
  3.	lm(trivariat best + alle andern einzeln)
  n. adjR² max
}

