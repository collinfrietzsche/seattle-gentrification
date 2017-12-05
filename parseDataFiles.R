# Map stuff
library("rgdal") # librarys sp, will use proj.4 if installed
library("maptools")
library("ggplot2")
library("plyr")
library("dplyr")
library("rgeos")
library("ggmap")

# Read in Neighborhood Data
WA <- readOGR(dsn = "./ZillowNeighborhoods-WA/")
WA@data$id = rownames(WA@data)
WA.points = fortify(WA, region="id")
WA.df = join(WA.points, WA@data, by="id") %>%
  filter(City == "Seattle") # only grab data local to seattle

# CRS shizzz
CRS.new<-CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0+datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0")

# Apply CRS
proj4string(WA) <- CRS.new

# Test location
# result <- geocode("6724 24th Ave NW Seattle, WA 98117", output = "latlona", source = "google")
# test.location <-SpatialPoints(list(result$lon,result$lat))

for(i in 1:nrow(data)) {
  test.location <- SpatialPoints(list(origFile$Longitude[i],origFile$Latitude[i]))
  proj4string(test.location) <- CRS.new # verify same identity
  # add neighborhood to csv for each row
  # the over function shows the overlap between the two regions
  origFile$Neighborhood[i] <- as.character(over(test.location, WA)$Name)
}



################################
# Read in the CSV data and store it in a variable
# Iterate through all data files

files <- list.files(path="./data/", pattern = ".csv")
for(i in 1:length(files)) {
  # Update temp file
  fileToLoad <- files[i]
  print(paste("Parsing:",fileToLoad))
  # Read in file
  origFile <- read.csv(paste0("./data/",fileToLoad), stringsAsFactors = FALSE)
  origFile <- read.csv("./data_modified/Police_Incidents.csv", stringsAsFactors = FALSE)
  # Loop through the addresses to get the latitude and longitude of each address and add it to the
  # origFile data frame in new columns lat and lon
  for(i in 1:nrow(origFile))
  {
    test.location <- SpatialPoints(list(origFile$Longitude[i],origFile$Latitude[i]))
    proj4string(test.location) <- CRS.new # verify same identity
    # add neighborhood to csv for each row
    # the over function shows the overlap between the two regions
    origFile$Neighborhood[i] <- as.character(over(test.location, WA)$Name)
  }
  # Write a CSV file containing origFile to the working directory
  write.csv(origFile, paste0("./data_modified/",strsplit(fileToLoad, ".csv"),"-modified.csv"), row.names=FALSE)
}

################################