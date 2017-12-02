library("dplyr")

#read in CSV files:
bike.racks <- read.csv('City_of_Seattle_Bicycle_Racks-modified.csv', stringsAsFactors=FALSE)
#provides the count(number) of neighborhoods 
#do we want to override the existing data frame or create a new one?
bike.neighborhood <- group_by(bike.racks, Neighborhood)%>%
  summarise(
    count = n()
  )

food.banks <- read.csv('Food_Banks-modified.csv', stringsAsFactors=FALSE)
#gives you the number of food banks in each neighborhood
food.bank.neighborhood <- group_by(food.banks, Neighborhood)%>%
  summarise(
    num.food.banks <- n()
  )

  
neighborhood.details <- read.csv('Neighborhood_Details-modified.csv', stringsAsFactors=FALSE)
#provides the number of city features in the dataset 
sum.city.feature <- group_by(neighborhood.details, City.Feature)%>%
  summarise(
    count.feat = n()
  )  

