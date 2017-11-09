#GIS Hausaufgabe 

#settings
source("C:/Users/mleza/Documents/msc-phygeo-ws-16/msc-phygeo-class-of-2016-MLezamaValdes/fun/paths.r")
inpath <- paste0(path_data_gis, "input_6_1/") #Tabelle und gefülltes DEM drin, 
#nach erstem Tool auch .shp mit gauges
outpath <- paste0(path_data_gis, "output/")
dem <- paste0(path_gis_input_clean,"elevation.tif")
sagaCmd <- paste0(path_saga_norm, "saga_cmd.exe")

#Tool "Convert table to points"
system(paste0(sagaCmd, " shapes_points 0",
                              " -TABLE=",inpath, "gauges.txt",
                              " -POINTS=",inpath,"gauges.shp",
              " -X=X", 
              " -Y=Y")
)

#dem already filled with Wang&Liu, if not dem.tif needs to be converted to 
#dem.sdat, then ta_preprocessor 4 to fill sinks.
system(paste0(sagaCmd, " sim_hydrology 1",
              " -DEM=",inpath, "dem_filled.sgrd",
              " -GAUGES=",inpath,"gauges.shp",
              " -FLOW=", outpath, "flow_grid.sgrd",
              " -GAUGES_FLOW=", outpath, "flow_gauges.txt",
              " -TIME_SPAN", 24, 
              " -TIME_STEP", 1,
              " -ROUGHNESS", 0.3, #default-no information
              " -PRECIP", 0) #homogenous
       )

system(paste0(sagaCmd, " sim_hydrology 1",
              " -DEM=",inpath, "dem_filled.sgrd",
              " -GAUGES=",inpath,"gauges.shp",
              " -FLOW=", outpath, "flow_grid_24_1.sgrd",
              " -GAUGES_FLOW=", outpath, "flow_gauges_24_1.txt",
              " -TIME_SPAN", 24, 
              " -TIME_STEP", 0.1,
              " -ROUGHNESS", 0.3, #default-no information
              " -PRECIP", 0) #homogenous
)

system(paste0(sagaCmd, " sim_hydrology 1",
              " -DEM=",inpath, "dem_filled.sgrd",
              " -GAUGES=",inpath,"gauges.shp",
              " -FLOW=", outpath, "flow_grid_200_1.sgrd",
              " -GAUGES_FLOW=", outpath, "flow_gauges_200_1.txt",
              " -TIME_SPAN", 200, #8,3 days of rain
              " -TIME_STEP", 1,
              " -ROUGHNESS", 0.3, #default-no information
              " -PRECIP", 0) #homogenous
)

system(paste0(sagaCmd, " sim_hydrology 1",
              " -DEM=",inpath, "dem_filled.sgrd",
              " -GAUGES=",inpath,"gauges.shp",
              " -FLOW=", outpath, "flow_grid_360_1.sgrd",
              " -GAUGES_FLOW=", outpath, "flow_gauges_360_1.txt",
              " -TIME_SPAN", 360, #15 days of rain
              " -TIME_STEP", 1,
              " -ROUGHNESS", 0.3, #default-no information
              " -PRECIP", 0) #homogenous
)

system(paste0(sagaCmd, " sim_hydrology 1",
              " -DEM=",inpath, "dem_filled.sgrd",
              " -GAUGES=",inpath,"gauges.shp",
              " -FLOW=", outpath, "flow_grid_360_0_1.sgrd",
              " -GAUGES_FLOW=", outpath, "flow_gauges_360_0_1.txt",
              " -TIME_SPAN", 360, #15 days of rain
              " -TIME_STEP", 0.1,
              " -ROUGHNESS", 0.3, #default-no information
              " -PRECIP", 0) #homogenous
)

#read table of results
tables <- list.files(outpath, pattern=".txt")
t24_1 <- read.table(paste0(outpath, "flow_gauges.txt"), header=T)
t24_0_1 <- read.table(paste0(outpath, "flow_gauges_24_1.txt"), header=T)
t200_1 <- read.table(paste0(outpath, "flow_gauges_200_1.txt"), header=T)
t360_1 <- read.table(paste0(outpath, "flow_gauges_360_1.txt"), header=T)
t360_0_1 <- read.table(paste0(outpath, "flow_gauges_360_0_1.txt"), header=T)

#24h Vergleich TIME_STEP=1 bzw. 0.1
plot(t24_1$TIME, t24_1$GAUGE_01, type="l", col="red", ylim=c(0,15830))
lines(t24_0_1$TIME, t24_0_1$GAUGE_01, type="l", col="green")

#nur für ca. 8 Tage
plot(t200_1$TIME, t200_1$GAUGE_01, type="l", col="orange")

# ---> 360h (15 Tage) Vergleich TIME_STEP=1 bzw. 0.1
plot(t360_1$TIME, t360_1$GAUGE_01, type="l", col="darkblue", ylim=c(0,30430.0), 
     main="overland flow kinematic wave at gauge, \nhomogenous rainfall", xlab="time", ylab="overland flow")
lines(t360_0_1$TIME, t360_0_1$GAUGE_01, type="l", col="lightblue")
legend("topright", legend=c("15 days [1h]","15 days [6min]"), lty=c(1,1), col=c("darkblue", "lightblue"))
