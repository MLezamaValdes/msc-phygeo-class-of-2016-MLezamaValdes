#paths
path_main <- "E:/msc-phygeo-Ordnerstruktur/2016-data-analysis/"     #Ordner in 
#dem der Ordner data ist, Ebene über data
path_data <- paste0(path_main, "data/")
path_csv <- paste0(path_data, "csv/")
path_rdata <- paste0(path_data, "rdata/")
path_repo <- "E:/msc-phygeo-Ordnerstruktur/github-Repo/data-analysis/da-ws-04-2"

#read .txt
ai <- read.table(paste0(path_csv, "AI001_gebiet_flaeche.txt"), sep=";", 
                 skip=4, header=T, fill=T)
head(ai)
str(ai)

#change factor -> numeric
for (i in c(1,4:7)){
  ai[,i]<-as.numeric(gsub(",", ".",as.character(ai[,i])))
}
str(ai)

#change names
names(ai)
names(ai) <-c("Year", "ID", "Place", 
              "share_settlement_transport_infrastructure_in_total_areas", 
              "share_recreational_in_total_areas", "share_agric_in_total_areas",
              "share_forests_in_total_areas")

##homework: generate function---
place_sep <- function(x) {
  place <- strsplit(as.character(x[,3]), ",")
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
  place_df <- do.call("rbind", place_df)# convert diverse dataframes into one do.call("rbind", df)
  place_df$ID <- x$ID #in kleinen df die Spalten aus cpc schreiben zum mergen
  place_df$Year <- x$Year
  return (place_df)
}
#save("place_sep", file="place_sep.Rdata")
###---

load("place_sep.Rdata")
#run function
place_df <- place_sep(ai)
head(place_df)

#clear 
unique(place_df[,3])
unique(place_df[,2])
unique(place_df$B[!is.na(place_df$C)])#What is stored in the second column for the 
#cases in which C is Kreisfreie Stadt?

#switch column two and three for the rows with a non-NA entry in the third column
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
head(place_df)


#merge back to original dataframe
aicl <- merge(ai, place_df, by = c("ID", "Year"))
aiclo <- aicl[,c(1, 2, 8,9,10,3:7)]
head(aiclo)

#u.U. noch names ändern

saveRDS(aiclo,paste0(path_rdata,"AI001_clean.rds"))
AI001 <- readRDS(paste0(path_rdata,"AI001_clean.rds"))