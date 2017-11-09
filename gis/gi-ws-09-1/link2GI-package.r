install.packages("link2GI")
library(link2GI)
obj <- raster::raster(paste0(path_gis_input, "neig.tif"))
linkGRASS7(obj)