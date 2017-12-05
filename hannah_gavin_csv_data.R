# Map stuff
library("rgdal") # librarys sp, will use proj.4 if installed
library("maptools")
library("ggplot2")
library("plyr")
library("dplyr")
library("rgeos")
library("ggmap")
source('kyle_lindquist_csv_data.R')

# Read in Neighborhood Data
WA <- readOGR(dsn = "./ZillowNeighborhoods-WA/")
WA@data$id = rownames(WA@data)
WA.points = fortify(WA, region="id")
WA.df = join(WA.points, WA@data, by="id") %>%
  filter(City == "Seattle") # only grab data local to seattle

#read in CSV files:
bike.racks <- read.csv('./data_modified/City_of_Seattle_Bicycle_Racks-modified.csv', stringsAsFactors=FALSE)
food.banks <- read.csv('./data_modified/Food_Banks-modified.csv', stringsAsFactors=FALSE)
neighborhood.details <- read.csv('./data_modified/Neighborhood_Details-modified.csv', stringsAsFactors=FALSE)

#provides the count(number) of neighborhoods 
#do we want to override the existing data frame or create a new one?
bike.neighborhood <- group_by(bike.racks, Neighborhood) %>%
  summarise(
    "# of Bike Racks" = n()
  )

#gives you the number of food banks in each neighborhood
food.bank.neighborhood <- group_by(food.banks, Neighborhood)%>%
  summarise(
    "Number of Food Banks" = n()
  )

#provides the number of city features in the dataset 
#FIX THIS
sum.city.feature <- group_by(neighborhood.details, City.Feature)%>%
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

neighborhood.map <- ggplot(WA.df) +
  aes(long,lat,group=group) +
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  scale_fill_brewer("Seattle Neighborhoods")


#now we need to add hover over feature to the map using the all.summary.data frame from above!
