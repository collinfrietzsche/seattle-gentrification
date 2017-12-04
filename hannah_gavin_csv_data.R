library("dplyr")
library("plyr")

#read in CSV files:
bike.racks <- read.csv('City_of_Seattle_Bicycle_Racks-modified.csv', stringsAsFactors=FALSE)
food.banks <- read.csv('Food_Banks-modified.csv', stringsAsFactors=FALSE)
neighborhood.details <- read.csv('Neighborhood_Details-modified.csv', stringsAsFactors=FALSE)

#provides the count(number) of neighborhoods 
#do we want to override the existing data frame or create a new one?
bike.neighborhood <- group_by(bike.racks, Neighborhood)%>%
  summarise(
    "# of Bike Racks" = n()
  )

#gives you the number of food banks in each neighborhood
food.bank.neighborhood <- group_by(food.banks, Neighborhood)%>%
  summarise(
    "# of Food Banks" = n()
  )

#provides the number of city features in the dataset 
#FIX THIS
sum.city.feature <- group_by(neighborhood.details, City.Feature)%>%
  summarise(
    "# of City Feature" = n()
  )
  
#we need to make a giant dataframe of all the summary 
#data we got so that we can use it in the hover-over code

#we need to fix sum.city.feature by adding the groupby Neighborhood!!!!!
all.summary.data <- join_all(list(bike.neighborhood,
               food.bank.neighborhood,
               #sum.city.feature, FIX THIS
               garages.parking.by.neighborhood,
               public.spaces.by.neighborhood,
               tennis.courts.by.neighborhood),
               by= 'Neighborhood', type = 'left')



