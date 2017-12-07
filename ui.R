library(shiny)
library(plotly)
library(plyr)
library(shinythemes)
library(leafletR)
#install.packages("leaflet")

source("./data_wrangle.R")

# Make the map, x - years, y - price
shinyUI(navbarPage(theme = shinythemes::shinytheme("cerulean"),
                  
                   title = 'Exploring Housing Prices in Seattle',
                   
                   # Home Page
                   tabPanel('Home Page',
                            #titlePanel("Home"),
                            tags$div(id = "cover",
                                     tags$h1("Introduction", class = "cover-content", align = "center")
                            ),
                            img(src='seattle.jpg', align = "center"),
                            tags$h3("Overview of Project", class = "header"),
                            tags$h4("Purpose: We wanted to look at how the housing prices in greater Seattle have changed over time.",
                                    tags$br(),"Methods: We used Seattle's Open Data website to look at median housing prices in Seattle and its surrounding neighborhoods. We also looked at other factors in these neighborhoods such as the amount of police activity and the quantity of various public facilities.",
                                    tags$br(),"Claim: We believe that housing prices have increased over time due to various factors.",
                                    tags$br(),tags$br(),
                                    "Interpretation of Results:
                                    
                                    There is a positive, linear trend between housing prices and time, in general.",tags$br(),
                                    "We were expecting a stronger correlation between housing price and police activity but there isn't too strong of a negative trend.",tags$br(),
                                    "The areas with the most police activity are mainly Downtown, Capitol Hill and University District.",tags$br(),
                                    "The number of bike racks and public garages/parking lots are highest in areas where the most people are visiting where as the number of food banks and tennis courts are more spread all over the place.", class = "para 1")
                            
                            

                   ),
                   # Housing Prices Scatter Plot Page
                   tabPanel('Housing Prices',
                            titlePanel("Price vs. Time"),
                            
                            # Scatter Plot
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
                              tags$h3("About the Map:", class  = "header"),
                              tags$h5("The map below uses colors to display the number of incidents in each
                                      neighborhood in Seattle. The colors are associated with the values shown in
                                      the legend. To view a particular neighborhood, simply hover over with your mouse.
                                      As you can see, University District is dark red, which is particularly interesting 
                                      being students at the University of Washington."),
                               htmlOutput("police.density"),
                              tags$h3("About the Scatter plot", class = "header"),
                              tags$h5("The scatter plot below shows the relationship between housing prices and 
                                      police incidents. We expected the number of police incidents to cause a 
                                      decrease in housing prices, however as you can see based on the trend shown in
                                      the scatter plot, that is not the case. We can assume that location is more 
                                      important than police activity when determining price in the Seattle area. To 
                                      get more information on the data, simply hover over the points displayed on the 
                                      scatter plot to median housing price and number of police incidents for the given neighborhood."),
                              plotlyOutput("police.scatter")
                            )
                            )
                   ),
                   
                   tabPanel('Lookup Information',
                            titlePanel("Address Statistics"),
                            tags$p("Seattle Address: 4741 19th Ave NE, Seattle, WA 98105"),
                            tags$p("Ballard Address: 2226 NW 62nd St APT 3, Seattle, WA 98107"),
                            textInput("user.address", h3("Address Information"), 
                                      value = "2226 NW 62nd St APT 3, Seattle, WA 98107"),
                            plotlyOutput("address.map"),
                            tags$h5(textOutput("address.price")),
                            tags$h3(textOutput("address.neighborhood")),
                            tags$h5("For this neighborhood, we found that..."),
                            tags$p(htmlOutput("address.parks")),
                            tags$p(htmlOutput("address.playareas")),
                            tags$p(htmlOutput("address.viewpoints")),
                            tags$p(htmlOutput("address.landmarks")),
                            tags$p(htmlOutput("address.garages")),
                            tags$p(htmlOutput("address.bikes"))
                            ),
                   
                   tabPanel('General Table of Information',
                            titlePanel("Table of City Features"),
                            tags$h3("Select the areas of interest and see how they differ in 
                                       neighborhoods across Seattle"),
                            checkboxGroupInput("all.table", "Choose Columns:",
                                                choiceNames = colnames(all.summary.data),
                                                choiceValues = colnames(all.summary.data),
                                               selected = "Neighborhood",
                                                inline = TRUE
                            ),
                            DT::dataTableOutput("mytable")
                   ),
                   
                   tabPanel('About Us',
                            tags$h1("About Us", align = "center", class = "header"),
                            tags$p("We are a group of students in Informatics 201, Technical Foundations, at the University of Washington.", align = "center"),
                            tags$p("This project was created by ", strong("Hannah, Kyle, James, and Collin"), "as a final for the class.", align = "center"),
                            tags$p("We chose to investigate the housing prices in Seattle as we have found through
                                   personal experience that it is very expensive to live in this beautiful
                                   city.", align = "center")
                          
                   )
))


         
         
         