#rs-ws-02-1
setwd("D:/Ben/Lez/474000_5630000/")
getwd()

install.packages("mapview")
library(mapview)
library(raster)
library(rgdal)
install.packages("sp")
library(sp)

raster <- raster("474000_5630000.tif")
projection(raster)
raster

plot(raster)

#3 Kanäle jeweils RGB 255 Ganzzahl -> In Kombi 16Mio Farbmöglichkeiten.

stack <- stack(raster, "474000_5632000.tif", 
                 "LC82100502014328LGN00_B2.tif", "LC82100502014328LGN00_B3.tif")
projection(stack)
raster <- raster()

stack()