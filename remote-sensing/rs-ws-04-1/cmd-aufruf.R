

source_file <- "E:/msc-phygeo-remote-sensing-2016/data/geonode-las_intensity_05.tif"
dst_file <- "E:/msc-phygeo-remote-sensing-2016/data/geonode-las_intensity_05_n.tif"

cmd <- paste0("C:/Program Files/QGIS 2.14/bin/gdal_translate.exe -of JPEG ", source_file, " ", dst_file)
system(cmd)

