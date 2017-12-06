# Data Wrangling File
source("./load_all_csv.R")
source("./functions.R")

# provides num of garages/parking lots by neighborhood
garages.parking.by.neighborhood <- group_by(garages.and.parking.lots, Neighborhood) %>%
  summarise(
    "Number of Garages and Parking Lots" = n()
  )

# provides num of tennis courts by neighborhood
tennis.courts.by.neighborhood <- group_by(tennis.courts, Neighborhood) %>%
  summarise(
    "Number of Tennis Courts" = n()
  )

# provides num of public spaces by neighborhood
public.spaces.by.neighborhood <- group_by(public.spaces, Neighborhood) %>%
  summarise(
    "Number of Public Spaces" = n()
  )

# provides num of police incidents by type of offense
police.incidents.by.neighborhood <- group_by(police.incidents, Neighborhood) %>%
  summarise(
    "Incidents" = n()
  )

#provides the count(number) of neighborhoods 
#do we want to override the existing data frame or create a new one?
bike.neighborhood <- group_by(bike.racks, Neighborhood) %>%
  summarise(
    "Number of Bike Racks" = n()
  )

#gives you the number of food banks in each neighborhood
food.bank.neighborhood <- group_by(food.banks, Neighborhood)%>%
  summarise(
    "Number of Food Banks" = n()
  )

#provides the number of city features in the dataset 
#FIX THIS we need the data frame to include neighborhood 
sum.city.feature <- group_by(neighborhood.details, Neighborhood, City.Feature)%>%
  summarise(
    "Number of City Feature" = n()
  )


#we need to fix sum.city.feature by adding the groupby Neighborhood!!!!!
all.summary.data <-  join_all(list(bike.neighborhood,
                                   food.bank.neighborhood,
                                   #sum.city.feature, FIX THIS
                                   garages.parking.by.neighborhood,
                                   public.spaces.by.neighborhood,
                                   tennis.courts.by.neighborhood),
                              by= 'Neighborhood', type = 'left')

# Grab data from Sept 2016 to be the same
police.housing.df <- median.housing.prices %>%
  select(RegionName, `2016.09`) %>%
  rename(Neighborhood = RegionName, Price = `2016.09`) %>%
  left_join(police.incidents.by.neighborhood, by = "Neighborhood")

# Arrange region name in order
price.time.df <- median.housing.prices %>%
  select(2:length(median.housing.prices)) %>%
  arrange(RegionName)

# Get all the names in the region
price.time.names <- price.time.df$RegionName


# Save Police Heatmap
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

# cuts <- round(quantile(subdat$Incidents, probs = seq(0, 1, 0.20), na.rm = TRUE), 0)
# cuts[1] <- 0
# 
# popup <- c("Name", "Incidents")
# 
# sty <- styleGrad(prop = "Incidents", breaks = cuts, right = FALSE, style.par = "col",
#                  style.val = rev(heat.colors(5)), leg = "Incidents Sep 2016", lwd = 1)
# 
# map <- leaflet(data = leafdata, dest = ".", style=sty,
#                title = "index", base.map = "osm", 
#                incl.data = TRUE, popup = popup)