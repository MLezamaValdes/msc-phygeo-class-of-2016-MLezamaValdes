install.packages("mapview")
library(mapview)
library(raster)

require(rgdal)
# Read SHAPEFILE.shp from the current working directory (".")
shape <- readOGR(dsn = "C:/Users/mleza/Documents/msc-phygeo-ws-16/data/remote_sensing/train", "training_final")

vector()
ras <- raster("C:/Users/mleza/Documents/msc-phygeo-ws-16/data/gis/output_test/TWI.tif")
mapview(ras)+shape
