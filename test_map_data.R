# Map stuff
library("rgdal") # librarys sp, will use proj.4 if installed
library("maptools")
library("ggplot2")
library("plyr")
library("rgeos")
library("ggmap")

# Read in Neighborhood Data
WA <- readOGR(dsn = "./ZillowNeighborhoods-WA/ZillowNeighborhoods-WA.shp")
WA@data$id = rownames(WA@data)
WA.points = fortify(WA, region="id")
WA.df = join(WA.points, WA@data, by="id") %>%
  filter(City == "Seattle") # only grab data local to seattle

# CRS shizzz
CRS.new<-CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0+datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0")

# Apply CRS
proj4string(WA) <- CRS.new 

# Plot neighborhood
ggplot(WA.df) +
  aes(long,lat,group=group) +
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  scale_fill_brewer("Seattle Neighborhoods")

# Test location
# result <- geocode("6724 24th Ave NW Seattle, WA 98117", output = "latlona", source = "google")
# test.location <-SpatialPoints(list(result$lon,result$lat))
