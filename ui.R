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
                   # Home Page
                   tabPanel('Home Page',
                            titlePanel("Home Page"),
                            # Create sidebar layout
                            sidebarLayout(
                              # Side Bars
                              sidebarPanel(
                                selectInput('neighborhood', label = 'Select Neighborhood:', 
                                            choices = names)
                              ),  
                              # Main panel display plotly map
                              mainPanel(
                                plotlyOutput('scatter')
                              )
                            )
                   ),
                   
                   # Scatter Plot
                   tabPanel('Scatter',
                            titlePanel("Price vs Time"),
                            # Create sidebar layout
                            sidebarLayout(
                              # Side Bars
                              sidebarPanel(
                                selectInput('neighborhood', label = 'Select Neighborhood:', 
                                            choices = names),
                                sliderInput("time", "Time range:", min = 2010.01, max = 2017.09,
                                            value = c(2010.05, 2016.1), step = 0.01)  ##### change the step = ?
                              ),  
                              # Main panel display plotly map
                              mainPanel(
                                plotlyOutput('scatter')
                              )
                            )
                          ),
                   
                   # Map
                   tabPanel('Map',
                            titlePanel("Maps"),
                            # Create sidebar layout
                            sidebarLayout(
                              # Side Bars
                              sidebarPanel(
                                selectInput('neighborhood', label = 'Select Neighborhood:', 
                                            choices = names),
                                sliderInput("time", "Time range:", min = 2010.01, max = 2017.09,
                                            value = c(2010.05, 2016.1), step = 0.01)  ##### change the step = ?
                              ),  
                              # Main panel display plotly map
                              mainPanel(
                                plotlyOutput('map')
                              )
                            )
                   ),
                   
                   # About Us
                   tabPanel('About Us',
                            titlePanel("About Us"),
                            # Create sidebar layout
                            sidebarLayout(
                              # Side Bars
                              sidebarPanel(
                                selectInput('neighborhood', label = 'Select Neighborhood:', 
                                            choices = names)
                              ),  
                              # Main panel display plotly map
                              mainPanel(
                                plotlyOutput('scatter')
                              )
                            )
                   )
))