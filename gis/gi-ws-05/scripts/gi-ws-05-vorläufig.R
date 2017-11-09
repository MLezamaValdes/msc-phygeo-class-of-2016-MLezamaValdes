#W04-1: P&P reloaded
:-\ Please write a R script that implements the the whole workflow starting with 
the ArcGIS DSM data set and ending up with a classification of the scale 
dependent plain-plateau raster.

Use the new folder structure to organize your data and scripts.

:-\ Please copy the code of your R script as a non-executable block in a Rmd 
file with html output. Add a short code block which simply visualizes the final
aster stored above.

:-\ Knitr your Rmd file, update (i.e. commit) it in your local repository and 
publish (i.e. push) it to the GitHub classroom. Make sure that the created html
file is also part of your git repository.

source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")

install.packages("gdalUtils")
library(gdalUtils)
library(raster)
gdalUtils::gdal_setInstallation()
getOption("gdalUtils_gdalPath")

gdal_translate(paste0(path_gis_input, "elevation.tif"), 
               paste0(path_gis_input,"elevation.sgrd"))
gdal_translate(paste0(path_gis_input, "elevation.sgrd"), 
               paste0(path_gis_input,"elevationbla"))


#HA ohne Filter
#auf DEM: Mittelwertfilter, Rest genau gleich wie zuvor in HA
#alles fertig machen, Modalfilter auf Endergebnis 

focal(x, w=3, fun, filename='', na.rm=FALSE, pad=FALSE, padValue=NA, NAonly=FALSE, ...)

a<-focal(x,w=matrix(1/9), nc=4, nr=3)
für 5x5 25




