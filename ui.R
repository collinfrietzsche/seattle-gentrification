library(shiny)
library(plotly)
library(plyr)
library(shinythemes)
library(leafletR)

source("./data_wrangle.R")

# Make the map, x - years, y - price
shinyUI(navbarPage(theme = shinythemes::shinytheme("flatly"),
                  
                   title = 'Exploring Gentrification in Seattle',
                   
                   # Home Page
                   tabPanel('Home Page',
                            titlePanel("Home")
                   
                  # Police Activity tab                 
                   ),
                   tabPanel('Police Activity',
                            titlePanel("Police Activity")
                   ),
                   
                   # Scatter Plot
                   tabPanel('Scatter',
                            titlePanel("Price vs Time"),
                            # Create sidebar layout
                            sidebarLayout(
                              # Side Bars
                              sidebarPanel(
                                selectInput('neighborhood', label = 'Select Neighborhood:', 
                                            choices = price.time.names),
                                sliderInput("time", "Time range:", min = 2010.01, max = 2017.09,
                                            value = c(2010.05, 2016.1), step = 0.01)  ##### change the step = ?
                              ),  
                              # Main panel display plotly map
                              mainPanel(
                                plotlyOutput('scatter')
                              )
                            )
                          ),
                   
                   # Police Incident Page
                   tabPanel('Police Incidents',
                            titlePanel("Police Incidents"),
                            mainPanel(fluidRow(
                              htmlOutput("police.density"),
                              plotlyOutput("police.scatter")
                            )
                            )
                   ),
                   
                   tabPanel('Lookup Information',
                            titlePanel("Address Statistics")
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


         
         
         