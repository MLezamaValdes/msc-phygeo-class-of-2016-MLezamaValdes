install.packages("raster")
library(raster)

#paths
path_main <- "C:/Users/sleza/Documents/Lilian/" 
path_data <- paste0(path_main, "2016-fe/data/")
path_repo <- paste0(path_main, "msc-phygeo-class-of-2016-MLezamaValdes/remote-sensing/rs-ws-04-1/")

read<-list.files(path=path_data, pattern=glob2rx("*.tif"), full.names=TRUE)
read <- as.list(read)

st <- list()
for(i in seq(read)){
 st[i] <- stack(read[i])
}

?list2env
#Problem kann nicht auf einzelne Layer in Stacks in List zugreifen
#wenn nicht geht:raster in environment schreiben
#http://stackoverflow.com/questions/35457708/extracting-individual-layers-from-raster-stack-in-loop

testlist <- list(c(1,6,7), "hello")
st2[[1]][2]
#2×GREEN-RED-BLUE / 2×GREEN+RED+BLUE

#allgemein
x <- st[[1]][,1]
x
glist <- function(x, r=1, g=2, b=3){(2*x[[i]][g]-x[[i]][r]-x[[i]][b])-(2*x[[i]][g]+x[[i]][r]+x[[i]][b])}

glitest<-(2*x[[2]]-x[[1]]-x[[3]])-(2*x[[2]]+x[[1]]+x[[3]])
plot(glitest)
glist(st)
save(gli, file=paste0(path_repo,"gli_func.R"))
source(paste0(path_repo,"gli_func.R"))
#hier
#input list of stacks -> take stack of list and divide into stack entries
glindex <- list()
for(i in seq(st)){
  glindex[i] <- gli(st)}

i=1

x = list(list(1,2), list(3,4), list(5,6))
x1 = lapply(x, function(l) l[[1]])

st
lapply(st,function(st){
  glindex[i] <- gli(st)
})


?lapply
gli <- function(st){(2*st[[2]]-st[[1]]-st[[3]])- (2*st[[2]]+st[[1]]+st[[3]])}

gli_ras <- gli(st)


source("Pfad")
gli 

#alle Kacheln Geotiff-Datei abspeichern mit Index

