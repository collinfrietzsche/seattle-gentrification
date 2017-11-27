library("rgdal") # librarys sp, will use proj.4 if installed
library("maptools")
library("ggplot2")
library("dplyr")
library("rgeos")
library("ggmap")

# CRS shizzz
CRS.new<-CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0+datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0")

# Read in Neighborhood Data
WA <- readOGR(dsn = "./ZillowNeighborhoods-WA/")
WA@data$id = rownames(WA@data)
WA.points = fortify(WA, region="id")
WA.df = join(WA.points, WA@data, by="id") %>%
  filter(City == "Seattle")

# Plot neighborhood
# ggplot(WA.df) + 
  # aes(long,lat,group=group) + 
  # geom_polygon() +
  # geom_path(color="white") +
  # coord_equal() +
  # scale_fill_brewer("Seattle Neighborhoods")

# Test location
result <- geocode("6724 24th Ave NW Seattle, WA 98117", output = "latlona", source = "google")
test.location <-SpatialPoints(list(result$lon,result$lat))

# Apply CRS
proj4string(WA) <- CRS.new 
proj4string(test.location) <- CRS.new

# Get name of neighborhood
name <- as.character(over(test.location, WA)$Name)


################################
# Read in the CSV data and store it in a variable
fileToLoad = "./data/Tennis_Courts.csv"
origFile <- read.csv(fileToLoad, stringsAsFactors = FALSE)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origFile data frame in new columns lat and lon
for(i in 1:nrow(origFile))
{
  Print("Working...")
  # Read int
  test.location <- SpatialPoints(list(origFile$Longitude[i],origFile$Latitude[i]))
  origFile$Neighborhood[i] <- as.character(over(test.location, WA)$Name)
}
# Write a CSV file containing origFile to the working directory
write.csv(origFile, paste0(fileToLoad,"-modified"), row.names=FALSE)
################################



# Zillow site: https://www.zillow.com/howto/api/neighborhood-boundaries.htm
# ggmap needs recognition

# zestimate: https://www.zillow.com/howto/api/GetZestimate.htm
