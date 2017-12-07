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
                            tags$h4("Purpose: We wanted to look at how the housing prices in greater Seattle have changed over time.",
                                    tags$br(),"Methods: We used Seattle's Open Data website to look at median housing prices in Seattle and its surrounding neighborhoods. We also looked at other factors in these neighborhoods such as the amount of police activity and the quantity of various public facilities.",
                                    tags$br(),"Claim: We believe that housing prices have increased over time due to various factors. (not sure what else to add here)",
                                    tags$br(),tags$br(),
                                    "Interpretation of Results:
                                    
                                    There is a positive, linear trend between housing prices and time, in general.",tags$br(),
                                    "We were expecting a stronger correlation between housing price and police activity but there isn't too strong of a negative trend.",tags$br(),
                                    "The areas with the most police activity are mainly Downtown, Capitol Hill and University District.",tags$br(),
                                    "The number of bike racks and public garages/parking lots are highest in areas where the most people are visiting where as the number of food banks and tennis courts are more spread all over the place.", class = "para 1"),
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
                                            value = c(2017.01, 2017.09), step = 0.01, sep = "")  ##### change the step = ?
                              ),  
                              # Main panel display plotly map
                              mainPanel(
                                plotlyOutput('scatter')
                              )
                            ),
                            
                            # Explain examples
                            tags$h5("Take Admiral Neighborhood from Jan 2017 to Sep 2017 for example, we can clearly see housing prices decrease 
                                    in Feb, May, and Sep in 2017, but the overall housing market is 
                                    increasing significantly. The growth rate is almost 16% over the
                                    course of eight months!", class = "para 1")
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


         
         
         