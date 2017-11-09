source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/gis/gi-ws-05/scripts/msc-phygeo-class-of-2016-creuden/fun/initOTB.r")
source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/gis/gi-ws-05/scripts/msc-phygeo-class-of-2016-creuden/fun/makGlobalVar.r")
source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/gis/gi-ws-05/scripts/msc-phygeo-class-of-2016-creuden/fun/add2Path.r")

#rs-toolbox oder so direkt über Google installieren, was ausführen


install.packages("satelliteTools")
library (satelliteTools)
otbPath
otb<- "C://Users/mleza/AppData/Local/Temp/http%3a%2f%2fdownload.osgeo.org%2fosgeo4w%2f/x86_64/release/orfeotoolbox/otb-bin/"
initOTB(otb)
image <- (paste0(path_rs_input, "geonode-ortho_muf_rgb_idx_pca_scaled.tif"))
output <- paste0(path_data_rs, "segmentation/") #just the path

#Step1 - Smoothing
otbcli_MeanShiftSmoothing(image, outfile_filter = paste0(output, "filter_file.tif"), 
                          outfile_spatial = paste0(output, "spatial_file.tif"))

#Step2 - Segmentation
spectral_range <- c(15,30)
for(i in seq(length(spectral_range))){
  otbcli_ExactLargeScaleMeanShiftSegmentation(paste0(output, "filter_file.tif"), 
                                              inpos = paste0(output, "spatial_file.tif"), 
                                              out = paste0(output,"spectral_range",
                                                           spectral_range[i],"_segmentation.tif"), 
                                              tmpdir = output, spatialr = 1, ranger = spectral_range[i])}

#Step3 - SmallRegionsMerging
matrix_step3 <- expand.grid(c(15,30), c(40,50,60,70))
names(matrix_step3) <- c("spectral_range", "minimum_size")

for(i in seq(nrow(matrix_step3))){
  otbcli_LSMSSmallRegionsMerging(paste0(output, "filter_file.tif"),
                                 inseg = (paste0(output, "spectral_range",
                                                 matrix_step3$spectral_range[i],"_segmentation.tif")),
                                 out = (paste0(output, 
                                               "spectral_range", matrix_step3$spectral_range[i], 
                                               "_minimum_size", matrix_step3$minimum_size[i],
                                               "small_regions_merged_.tif")),
                                 minsize = matrix_step3$minimum_size[i])}

#Step4 - Shapes erstellen
for(i in seq(nrow(matrix_step3))){
  otbcli_LSMSVectorization(image, 
                           inseg = paste0(output, "spectral_range",
                                          matrix_step3$spectral_range[i], "_minimum_size",
                                          matrix_step3$minimum_size[i],
                                          "small_regions_merged_.tif"),
                           out = paste0(output, 
                                        "vectorization_spectral_range", 
                                        matrix_step3$spectral_range[i],
                                        "minimum_size", 
                                        matrix_step3$minimum_size[i], ".shp"))}