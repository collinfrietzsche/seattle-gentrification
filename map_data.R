# Map stuff
library("leafletR")
library("rgdal") # librarys sp, will use proj.4 if installed
library("maptools")
library("ggplot2")
library("plyr")
library("dplyr")
library("rgeos")
library("ggmap")


housing.prices <- read.csv('./data_modified/Seattle_Median_House_Prices.csv', stringsAsFactors = FALSE) %>%
  select(RegionName, "X2016.09") %>%
  rename(Name = RegionName, Price = "X2016.09")

police.incidents <- read.csv('./data_modified/Police_Incidents-modified.csv', stringsAsFactors = FALSE)
# provides num of police incidents by type of offense
police.incidents.by.neighborhoods <- group_by(police.incidents, Neighborhood) %>%
  summarise(
    Incidents = n()
  ) %>%
  rename(Name = Neighborhood)

# Read in WA Neighborhood Data
WA <- readOGR(dsn = "./ZillowNeighborhoods-WA/")
SEA <- WA[WA$City == "Seattle",]
SEA@data <- left_join(SEA@data, police.incidents.by.neighborhoods, by = "Name") %>%
  left_join(housing.prices, by = "Name")
SEA@data[is.na(SEA@data)] <- 0
SEA@data$id = rownames(SEA@data)
SEA.points = fortify(SEA, region="id")
SEA.df = join(SEA.points, SEA@data, by="id")

subdat <- SEA
subdat <- spTransform(subdat, CRS("+init=epsg:4326"))
subdat.data <- subdat@data[,c("id", "Name", "Incidents", "Price")]
subdat.data <- rename(subdat.data, ID = id)
subdat.data$ID <- as.character(as.numeric(subdat.data$ID) + 92)
subdat <- gSimplify(subdat, tol = 0.01, topologyPreserve = TRUE)
subdat <- SpatialPolygonsDataFrame(subdat, data = subdat.data, match.ID = FALSE)

leafdata <- paste0("./spacial.geojson")
writeOGR(subdat, leafdata, layer="", driver = "GeoJSON")

cuts <- round(quantile(subdat$Incidents, probs = seq(0, 1, 0.20), na.rm = TRUE), 0)
cuts[1] <- 0

popup <- c("Name", "Incidents")

sty <- styleGrad(prop = "Incidents", breaks = cuts, right = FALSE, style.par = "col",
                 style.val = rev(heat.colors(5)), leg = "Incidents Sep 2016", lwd = 1)

map <- leaflet(data = leafdata, dest = ".", style=sty,
               title = "index", base.map = "osm", 
               incl.data = TRUE, popup = popup)


browseURL(map)

