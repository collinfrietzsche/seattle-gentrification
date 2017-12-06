library(shiny)
library(plotly)
library(shinythemes)
library(leafletR)

source("./functions.R")

df <- read.csv('./data_modified/Seattle_Median_House_Prices.csv', stringsAsFactors = FALSE, check.names = FALSE)
# Arrange region name in order
df <- df %>%
  select(2:length(df)) %>%
  arrange(RegionName)
# Get all the names in the region
names <- df$RegionName
####################### source this


# Make the map, x - years, y - price
shinyUI(navbarPage(theme = shinythemes::shinytheme("flatly"),
                  
                   title = 'Exploring Gentrification in Seattle',
                   
                   # Home Page
                   tabPanel('Home Page',
                            titlePanel("Home")
                          
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
                   
                   #PUT TABLE HERE KYLE
                   tabPanel('General Table of Information',
                            titlePanel("Table")
                            
                   ),
                   
                   tabPanel('About Us',
                            tags$h1("About Us", align = "center", class = "header"),
                            tags$p("We are a group of students in Informatics 201, Technical Foundations, at the University of Washington.", align = "center"),
                            tags$p("This project was created by ", strong("Hannah, Kyle, James, and Collin"), "as a final for the class.", align = "center"),
                            tags$p("We chose to investigate the components of gentrification within Seattle because it is an important topic of discussion in civic life.", align = "center")
                          
                   )
))


         
         
         