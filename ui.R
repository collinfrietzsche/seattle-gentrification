library(shiny)
library(plotly)

df <- read.csv('./data_modified/Seattle_Median_House_Prices.csv', stringsAsFactors = FALSE, check.names = FALSE)
# Arrange region name in order
df <- df %>%
  select(2:length(df)) %>%
  arrange(RegionName)
# Get all the names in the region
names <- df$RegionName
####################### source this

# Make the map, x - years, y - price
shinyUI(navbarPage('Seattle Median House Prices',
                   # Create a tab panel for your map
                   tabPanel('Scatter',
                            titlePanel("Years vs Price"),
                            # Create sidebar layout
                            sidebarLayout(
                              # Side Bars
                              sidebarPanel(
                                selectInput('neighborhood', label = 'Select Neighborhood:', 
                                            choices = names),
                                sliderInput("time", "Time range:", min = 2010.01, max = 2017.09,
                                            value = c(2010.05, 2016.1))
                              ),  
                              # Main panel display plotly map
                              mainPanel(
                                plotlyOutput('scatter')
                              )
                            )
                          )
))




neighborhood.map <- ggplot(WA.df) +
  aes(long,lat,group=group, text = paste("Neighborhood", all.summary.data$Neighborhood)) +
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  scale_fill_brewer("Seattle Neighborhoods")
