#paste-Funktion: names in main schreiben
#cat("\014")  
#Tools, Global Options, Code, Display, ShowMargins


path_main <- "E:/msc-phygeo-Ordnerstruktur/2016-data-analysis/"     #Ordner in 
#dem der Ordner data ist, Ebene über data
path_data <- paste0(path_main, "data/")
path_csv <- paste0(path_data, "csv/")
path_rdata <- paste0(path_data, "rdata/")

cp <- read.table(paste0(path_csv, "115-46-4_feldfruechte.txt"), sep=";", 
                     skip=6, header=T, fill=T)
head(cp)
str(cp)
#alles Faktoren.

#get rid of last lines
tail(cp, 10) #number of lines to display
cpc <- cp[1:8925,]
tail(cpc)
str(cpc) #problem: variables are factors, something like character

#convert factor to character 
# replace commas by dots as decimal sign
# convert character to numeric

cpc$Hafer
cpc$Hafer <- gsub(",", ".",cpc$Hafer)
as.numeric(as.character(cpc$Hafer))


act_col <- as.numeric(gsub(",", ".",as.character(cpc$Hafer)))
str(cpc)
cpc
#warning message: NAs intruduced by coercion: 
# just a comma or - or something -> can't convert it to numerical values.
#subselect column
for(i in c(1:13)){
cpc[,i][cpc[,i]=="."|
          cpc[,i]=="-"|
          cpc[,i]==","|
          cpc[,i]=="/"]<-NA
}

for (i in c(1,4:13)){
  cpc[,i]<-as.numeric(gsub(",", ".",as.character(cpc[,i])))
}

# all accesed, no warning message
#Rename columns
names(cpc)
names(cpc) <-c("Year", "ID", "Place", "Winter_wheat", "Rye", 
                       "Winter_barley", "Spring_barley", "Oat", "Triticale",
                       "Potatos", "Sugar_beets", "Rapeseed", "Silage_maize")
names(cpc)
#seperate Place
place <- strsplit(as.character(cpc[,3]), ",")
place

#converting splitted place-information -> df
place_df <- lapply(place, function(i){
  p1 <- sub("^\\s+", "", i[1])  # Trim leading white spaces
  if(length(i) > 2){
    p2 <- sub("^\\s+", "", i[2])
    p3 <- sub("^\\s+", "", i[3])
  } else if (length(i) > 1){
    p2 <- sub("^\\s+", "", i[2])
    p3 <- NA
  } else {
    p2 <- NA
    p3 <- NA
  }
  data.frame(A = p1,
             B = p2,
             C = p3)
})

place_df
place_df <- do.call("rbind", place_df)# convert diverse dataframes into one do.call("rbind", df)
place_df$ID <- cpc$ID #in kleinen df die Spalten aus cpc schreiben zum mergen
place_df$Year <- cpc$Year
head(place_df)

unique(place_df[, 2])#different entries in column B and C
unique(place_df[, 3]) 
unique(place_df$B[!is.na(place_df$C)])#What is stored in the second column for the 
#cases in which C is Kreisfreie Stadt?

#content of column two and three has to be switched for the rows with a non-NA entry in the third column
unique(place_df$C[place_df$C=="Kreisfreie Stadt"& !is.na(place_df$C)])
#second column = C
place_df[place_df$C=="Kreisfreie Stadt"& !is.na(place_df$C),] <- 
  place_df[place_df$C=="Kreisfreie Stadt"& !is.na(place_df$C),c(1,3,2,4,5)]

#Kram example, B sollte keine NAs mehr haben
unique(place_df$A[is.na()])

#ADDITIONAL STUFF
sum(is.na(place_df$B))
for(r in seq(nrow(place_df))){
  if(is.na(place_df$B[r]) &
     grepl("kreis", tolower(place_df$A[r]))){
    place_df$B[r] <- "Landkreis"
  }
}
place_df$B=="Landkreis" #testen
sum(is.na(place_df$B))

place_df$B[is.na(place_df$B) & nchar(as.character(place_df$ID) == 2)] <- "Bundesland"
place_df$B[place_df$ID == "DG"] <- "Land"
head(place_df)
sum(is.na(place_df$B))


#merge back to original dataframe
cpcc <- merge(cpc, place_df, by = c("ID", "Year"))
cpcco <- cpcc[,c(1, 2, 14,15,16,3,4:13)]
head(cpcco)

saveRDS(cpcco,paste0(path_rdata,"feldfr_clean.rds"))
rds <- readRDS(paste0(path_rdata,"feldfr_clean.rds"))
