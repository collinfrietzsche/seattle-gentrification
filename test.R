# This is a test file
library(dplyr)
data <- data %>%
  filter(Year > 2014)

data.homes <- read.csv("./data_modified/Seattle_Median_House_Prices.csv", stringsAsFactors = FALSE) %>%
  filter(City == "Seattle")

ggplot(data.homes[1, 8:length(data.homes)])
typeof(data.homes[1,8])


write.csv(data, "./data_modified/Police_Incidents.csv")