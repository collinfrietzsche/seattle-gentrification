library("dplyr")

# read in .csv files
garages.and.parking.lots <- read.csv('./data_modified/Public_Garage_or_Parking_Lot-modified.csv', stringsAsFactors = FALSE)
tennis.courts <- read.csv('./data_modified/Tennis_Courts-modified.csv', stringsAsFactors = FALSE)
public.spaces <- read.csv('./data_modified/Public_Spaces-modified.csv', stringsAsFactors = FALSE)
police.incidents <- read.csv('./data_modified/Police_Incidents-modified.csv', stringsAsFactors = FALSE)

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
police.incidents.by.offense <- group_by(police.incidents, Summarized.Offense.Description) %>%
  summarise(
    count = n()
  ) %>%
  arrange(-count)