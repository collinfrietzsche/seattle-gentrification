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