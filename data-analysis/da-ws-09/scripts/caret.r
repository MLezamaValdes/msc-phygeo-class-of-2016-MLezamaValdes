install.packages("randomForest")
install.packages("nloptr")
install.packages("caret")
library(caret)

head(iris)
unique(iris$Species)

smpl <- createDataPartition(iris$Species, p=0.8, list=F, times=5) #5x 80% aus 
#Datensatz ziehen, Angabe Spalte AV, Verteilung Zielvariable im Datensatz
#relevant, besser als Zufall wenn Verteilung stark ungleich das h�ufiger vorkommende zu
#sch�tzen

samples <- lapply(seq(ncol(smpl)), function(x){
  list(train = iris[smpl[,x], ], test = iris[-smpl[,x],])
})

#trainings trainings- und trainings-testdatensatz mit create Folds k=5, geht 
#nach 5 auf, resp: Selektion in dem Verh�ltnis wie in Trainingsdatensatz
#vorkommen
#Geschichte mit der while-Schleife trainControl
#rfFuncs f�r Randomforest, Crossvalidation auf Basis von splits in rfe Control

#-> Variablenselektion 5-fache Kreuzvalidierung, wieder 5-fache Kreuzvalidierung: 
#Modelltuning
#STern: obendr�ber optimale Variablenanzahl, Fehler nicht Modellintern sondern 
#auf unabh�ngigem Testdatensatz

#varImp f�r Importance der Variablen



