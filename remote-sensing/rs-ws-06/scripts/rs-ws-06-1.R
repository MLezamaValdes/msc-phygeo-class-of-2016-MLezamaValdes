source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
library("sp","rgdal", "raster")

ogrListLayers("TM_WORLD_BORDERS_SIMPL-0.3.shp") #will show you available layers for the above dataset
shape=readOGR("TM_WORLD_BORDERS_SIMPL-0.3.shp", layer="TM_WORLD_BORDERS_SIMPL-0.3") #will load the shapefile to your dataset.
plot(shape) #to get an overview

?