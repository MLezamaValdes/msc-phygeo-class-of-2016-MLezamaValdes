source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
library(raster)
catchment <- raster(paste0(path_data_gis, "output_catchmenttwi_upslope.tif"))
plot(catchment)


cells <- sum(!is.na(catchment))    
[catchment==0]
cells <- !is.na
[catchment==2]
cells <- catchment[values(catchment)!="NA"] 
length(cells)

