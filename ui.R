library(shiny)
library(plotly)
library(plyr)
library(shinythemes)
library(leafletR)
#install.packages("leaflet")

source("./data_wrangle.R")

# Make the map, x - years, y - price
shinyUI(navbarPage(theme = shinythemes::shinytheme("flatly"),
                  
                   title = 'Exploring Housing Prices in Seattle',
                   
                   # Home Page
                   tabPanel('Home Page',
                            #titlePanel("Home"),
                            tags$div(id = "cover",
                                     tags$h3("Introduction", class = "cover-content", align = "center")
                            ),
                            tags$h3("Overview of Project", class = "header"),
                            tags$h4("Here is where you can put overview information", class = "para 1"),
                            tags$h3("Questions", class = "header"),
                            
                            # Scatter Plot
                            tags$h3("Price vs. Year", class = "header"),
                            tags$h5("In the following graph, you can select the specific neighborhood in 
                                    a specific time range that you are interested in. You can clearly see the
                                    how are the housing prices in these areas moving within the time range you selected.", class = "para 1"),
                            # Create sidebar layout
                            sidebarLayout(
                              # Side Bars
                              sidebarPanel(
                                selectInput('neighborhood', label = 'Select Neighborhood:', 
                                            choices = price.time.names),
                                sliderInput("time", "Time range:", min = 2010.01, max = 2017.09,
                                            value = c(2010.05, 2016.1), step = 0.01, sep = "")  ##### change the step = ?
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
                            titlePanel("This table provides the number of city features in 
                                       each neighborhood as described by the column names"),
                            DT::dataTableOutput("mytable")
                   ),
                   
                   tabPanel('About Us',
                            tags$h1("About Us", align = "center", class = "header"),
                            tags$p("We are a group of students in Informatics 201, Technical Foundations, at the University of Washington.", align = "center"),
                            tags$p("This project was created by ", strong("Hannah, Kyle, James, and Collin"), "as a final for the class.", align = "center"),
                            tags$p("We chose to investigate the components of gentrification within Seattle because it is an important topic of discussion in civic life.", align = "center")
                          
                   )
))


         
         
         