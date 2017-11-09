#interactive workflow


source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
outpath <- paste0(path_data_gis, "output_test4/")
dem <- paste0(path_gis_input_clean,"elevation.tif")
x <-474266.4
y <-5630356.4
sagaCmd <- paste0(path_saga_norm, "saga_cmd.exe")

twi_watershed <- function(outpath, dem, sagaCmd, x, y){
  #convert dem to sgrd
  gdalUtils::gdalwarp(dem, paste0(outpath,"dem.sdat"), 
                      overwrite=TRUE,  of='SAGA')

  #preparation: 
  #fill sinks
  system(paste0(sagaCmd, " ta_preprocessor 4",
                " -ELEV=",outpath, "dem.sgrd",
                " -FILLED=",outpath,"dem_filled.sgrd")
  )
  
  #slope, aspect, curvature-tool (slope needed for calculation of TWI)
  system(paste0(sagaCmd, " ta_morphometry 0",
                " -ELEVATION=",outpath, "dem.sgrd",
                " -SLOPE=",outpath,"slope.sgrd")
  )
  
  #calculate flow accumulation (Top-Down)
  system(paste0(sagaCmd, " ta_hydrology 0",
                " -ELEVATION=",outpath, "dem_filled.sgrd",
                " -FLOW=",outpath,"flow_acc_td.sgrd")
  )
  
  #calculate TWI (goal of the process)
  system(paste0(sagaCmd, " ta_hydrology 20",
                " -SLOPE=",outpath, "slope.sgrd",
                " -AREA=",outpath, "flow_acc_td.sgrd",
                " -TWI=", outpath, "TWI.sgrd")
  )
  
  #calculate watershed for the outlet at 477755.4E, 5632178.4N (scale of the process)
  system(paste0(sagaCmd, " ta_hydrology 4",
                " -TARGET_PT_X",x,
                " -TARGET_PT_Y",y,
                " -ELEVATION=",outpath, "dem_filled.sgrd",
                " -AREA=",outpath, "upslope.sgrd")
  )
  
  #reconverting .sgrd to .tif
  gdalUtils::gdalwarp(paste0(outpath,"upslope.sdat"),
                      paste0(outpath,"upslope.tif"), 
                      overwrite=TRUE, of="GTiff") 
  
  gdalUtils::gdalwarp(paste0(outpath,"TWI.sdat"),
                      paste0(outpath,"TWI.tif"), 
                      overwrite=TRUE, of="GTiff") 
  
  #read upslope and twi-Rasters
  upslope <- raster(paste0(outpath, "upslope.tif"))
  twi <- raster(paste0(outpath, "TWI.tif"))
  
  #form grid with twi for catchment area
  twi_upslope <- twi
  twi_upslope[upslope==0] <- NA

  writeRaster(twi_upslope,paste0(outpath,"twi_upslope.tif"))
}

twi_watershed(outpath, dem, sagaCmd, x, y)
  
#Jannis' Kram:
saga2 <- shQuote("C:\\Program Files\\QGIS 2.18\\bin\\saga_gui.bat")
saga3 <- sagaCmd
cmd<-paste0(saga2, ' ta_channels 5 ', 
            " -DEM ",outpath, "dem.sgrd",
            " -DIRECTION ", outpath,"flow_dir.sdat")
system(cmd)



cmd<- paste0(saga3, " ta_channels 0 ", "-ELEVATION=", outpath, "elevation.sgrd ", 
             "-SINKROUTE=", outpath,"flow_dir.sgrd"," -CHNLNTWRK=", outpath,
             "chnlntwrk.sdat ", "-CHNLROUTE=", outpath,"chnl_route.sdat ", "-SHAPES=" , outpath,
             "chnl.shp", " -INIT_GRID=", outpath,"CAREA.sgrd ", 
             "-INIT_METHOD=2 -INIT_VALUE=0.000000 -DIV_GRID=NULL -DIV_CELLS=5 -TRACE_WEIGHT=NULL -MINLEN=10")

system(cmd)

###overland flow distance to channel network

cmd<- paste0(saga3, " ta_channels 4 ", "-ELEVATION=", outpath, "elevation.sgrd ", 
             " -CHANNELS=", outpath,"chnlntwrk.sdat ",  "-ROUTE=", outpath,"flow_dir.sgrd ",
             "-DISTANCE=", outpath,"DISTANCE.sdat ", "-DISTVERT=" , outpath,
             "DISTVERT.sdat", " -DISTHORZ=", outpath,"DISTHORZ.sgrd ", 
             "-PASSES=", outpath, "fields_visited.sgrd")

system(cmd)

#form grid with Overland Flow Distance for catchment area
upslope<-raster(paste0(outpath, "upslope.tif"))
dist_horz_upslope<-raster(paste0(outpath, "DISTANCE.sdat"))
dist_horz_upslope[upslope==0] <- NA

writeRaster(dist_horz_upslope,paste0(outpath,"dist_upslope.tif"))