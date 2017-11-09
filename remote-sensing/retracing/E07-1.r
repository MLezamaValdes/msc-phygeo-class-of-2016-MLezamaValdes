#Land-cover classification with R
install.packages("devtools")
library(devtools)
install.packages("DBI")
devtools::install_github("environmentalinformatics-marburg/gpm")
library(gpm)
library(raster)
library(rgdal)
library(sp)

source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
rasterOptions(tmpdir = path_rs_E7) #Set, inspect, reset, save a number of global 
#options used by the raster package.
#Most of these options are used when writing files to disk.


#extract raster values (UV) from satellite dataset
#ta = training areas polygons 
#store all in data frame
rgb <- stack(paste0(path_rs_muf_merged, "geonode-muf_merged_001m.tif"))
vi <- raster(paste0(path_rs_muf_merged, 
                    "geonode-muf_merged_001m_visible_vegetation_index.tif"))
ii <- raster(paste0(path_rs_muf_merged, 
                    "geonode-muf_merged_001m_intensity_index.tif"))
sat <- stack(rgb, vi, ii)

ta <- readOGR(paste0(path_rs_train, "training_final.shp"),
              "training_final")

###
data <- extract(sat, ta)
summary(data)
#saveRDS(data, file = paste0(path_rs_rdata, "muf_training_combined.RDS"))
#data <- readRDS(file = paste0(path_rs_rdata, "muf_training_combined.RDS"))

data_cmb <- lapply(seq(length(data)), function(i){
  data.frame(ID = ta@data$ID[i],
             NAME = ta@data$NAME[i],
             data[[i]])
})
data_cmb <- do.call("rbind", data_cmb)
data_cmb <- data_cmb[complete.cases(data_cmb[, c(1,3:7)]),]
#saveRDS(data_cmb, file=paste0(path_rs_rdata, "df_training.RDS"))

#build gpm-object: which is UV, which AV
data_cmb$ID <- as.factor(data_cmb$ID) #braucht gpm da nen Faktor?
# The column "ID" which holds the ID of the land-cover classes is transformed 
#to a factor since otherwise, the machine learning models would run in 
#regression mode (i.e. predict numeric values including decimal values and not 
#classes)



meta <- createGPMMeta(data_cmb, 
                      type = "input",
                      selector = 1, response = 1, #selector: sampling of subsets
                      #control, response=AV column
                      predictor = c(3:7), meta = NULL) #hier hieß predictor 
#independent und daher nicht funktioniert
muf_gpm <- gpm(data_cmb, 
               meta, scale = TRUE)