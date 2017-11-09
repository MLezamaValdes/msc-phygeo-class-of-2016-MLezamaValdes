
if (!require(RSAGA)){install.packages('RSAGA')}
if (!require(rgdal)){install.packages('rgdal')}
if (!require(raster)){install.packages('raster')}
if (!require(gdalUtils)){install.packages('gdalUtils')}
if(!require(raster)){install.packages("raster")}

library(RSAGA)
library(gdalUtils)
library(raster)

gdal_setInstallation()
valid.install<-!is.null(getOption("gdalUtils_gdalPath"))
if (!valid.install){stop('no valid GDAL/OGR found')} else{print('gdalUtils status is ok')}

#-set environment variables 
source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
path_saga <- shQuote("C:/Users/mleza/saga_3.0.0_x64/saga_3.0.0_x64/saga_gui.exe")
path_saga_norm <- shQuote("C:/Users/mleza/saga_3.0.0_x64/saga_3.0.0_x64/")
path_saga_tools <- shQuote("C:/Users/mleza/saga_3.0.0_x64/saga_3.0.0_x64/tools/")

list.files(path_saga)

# define working folder 
#root.dir <- main      # root folder 
#working.dir <- gis_in_base         # working folder

#  set pathes  of SAGA/GRASS modules and binaries depending on OS

#os.saga.path="C:/Gis2Go/GIS_ToGo/QGIS_portable_Chugiak_24_32bit/QGIS/apps/saga"
#saga.modules="C:/Gis2Go/GIS_ToGo/QGIS_portable_Chugiak_24_32bit/QGIS/apps/saga/modules"
#grass.gis.base= 'C:/Gis2Go/GIS_ToGo/QGIS_portable_Chugiak_24_32bit/QGIS/apps/grass/grass-6.4.3/bin'

#  delete all runtime files with filenames starting with 'run_'
#file.remove(list.files(file.path(working.dir), pattern =('run'), full.names = TRUE, ignore.case = TRUE))

#  set working directory
setwd(path_gis_run)
worksp <- path_gis_run

# (RSAGA) define SAGA environment 
myenv=rsaga.env(check.libpath=FALSE,
                check.SAGA=FALSE,
                workspace=path_gis_run,
                os.default.path=path_saga_norm,
                modules=path_saga_tools)
