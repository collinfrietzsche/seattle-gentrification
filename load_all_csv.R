# Load in all CSV files

# Housing Prices
median.housing.prices <- read.csv('./data_modified/Seattle_Median_House_Prices.csv', stringsAsFactors = FALSE, check.names = FALSE)

# Seattle Features
# Parsed to include neighborhood location from ggmap api
bike.racks <- read.csv('./data_modified/City_of_Seattle_Bicycle_Racks-modified.csv', stringsAsFactors=FALSE)
food.banks <- read.csv('./data_modified/Food_Banks-modified.csv', stringsAsFactors=FALSE)
neighborhood.details <- read.csv('./data_modified/Neighborhood_Details-modified.csv', stringsAsFactors=FALSE)
garages.and.parking.lots <- read.csv('./data_modified/Public_Garage_or_Parking_Lot-modified.csv', stringsAsFactors = FALSE)
tennis.courts <- read.csv('./data_modified/Tennis_Courts-modified.csv', stringsAsFactors = FALSE)
public.spaces <- read.csv('./data_modified/Public_Spaces-modified.csv', stringsAsFactors = FALSE)

# Police Incidents September, 2016 (data file too large)
# Parsed to include neighborhood location from ggmap api
police.incidents <- read.csv('./data_modified/Police_Incidents-modified.csv', stringsAsFactors = FALSE)

