library(dplyr)
library(plotly)
library(leaflet)
library(DT)

source("./data_wrangle.R")

shinyServer(function(input, output) {
  
  ###### Police Incident Heatmap ######
  output$police.density <- renderUI({
    my_test <- tags$iframe(src="http://students.washington.edu/collinaf/info201/", width = "100%", height = "500px")
    return(my_test)
  })
  
  ###### Price v Incident Scatter ######
  output$police.scatter <- renderPlotly({
    return(plot_ly(data = police.housing.df, x= ~Incidents, y = ~Price,
                   type = 'scatter', mode = 'markers',
                   hoverinfo = 'text',
                   text = ~paste0("Neighborhood: ", Name, "\n",
                                  "Price: ", Price, "\n",
                                  "Incidents: ", Incidents)) %>%
             layout(title = "Price vs # of Incidents",
                    xaxis = list(title = "Number of Incidents"),
                    yaxis = list(title = "Price ($)")
                    )
    )
  })

  ###### Time vs Housing Price ######
  output$scatter <- renderPlotly({
    # Get the row of the neighborhood
    region.data <- price.time.df %>%
      filter(RegionName == input$neighborhood)
      # filter(RegionName == "Admiral")
    
    # Get all data from the range
    range <- buildMinMaxList(input$time[1], input$time[2])
    # range <- buildMinMaxList(2010.05, 2015.11) 

    # select data range
    range.data <- region.data %>%
      select(range)
    
    # make the values into list
    values <- c()
    for(i in 1:length(range.data)) {
      values[i] <- range.data[1, i]
    }

    return(plot_ly(data = price.time.df, x= range, y= values,
                   xlab = range, ylab = values,
                   type = 'scatter', mode = 'markers', #color = ~type
                   hoverinfo = 'text', name = "Data Points",
                   text = ~paste0("Price: ", values, " unit<br />",
                                  "Years.Month: ", range)) %>%
             add_lines(x = range, y = values, name = "Trend") %>%
             layout(title = paste0(input$neighborhood, " Neighborhood"),
                    xaxis = list(title = "Time (Year.Month)"),
                    yaxis = list(title = "Price ($)"),
                    margin = list(b = 200))   #### regression line abline(lm(values~range), col="red")
    )
  })
  
  #### Address Search Summary ####
  
  reactive.values <- reactiveValues(neighborhood = "", price = 0.0)
  
  reactive.neighborhood <- observe({
    reactive.values$neighborhood <- as.character(getAddressNeighborhood(input$user.address))
    reactive.values$price <- getHousePrice(input$user.address)
  })
  
  output$address.map <- renderPlotly({
    if(!is.na(input$user.address) & length(input$user.address > 10)) {
      user.data <- getAddressNeighborhood(input$user.address)
      
      g <- list(
        scope = 'usa',
        projection = list(type = 'albers usa'),
        showland = TRUE,
        landcolor = toRGB("gray85"),
        subunitwidth = 1,
        countrywidth = 1,
        subunitcolor = toRGB("white"),
        countrycolor = toRGB("white"),
        lonaxis = list(range = c(-125, -115)),
        lataxis = list(range = c(45, 49))
      )
      
      return(plot_geo(user.data, locationmode = 'USA-states', sizes = c(1, 50)) %>%
        add_markers(
          x = ~long, y = ~lat, size = 1, hoverinfo = "text",
          text = ~paste(street, city.state.zip, "\n",
                        "Latitude:", lat, "\n",
                        "Longitude:", long)
        ) %>%
        layout(title = 'Address Location', geo = g))
    }
    return(NA)
  })
  
  output$address.neighborhood <- renderText({
    paste(reactive.values$neighborhood[5], "statistics:")
  })
  
  output$address.parks <- renderUI({
    neighborhood <- reactive.values$neighborhood[5]
    neighborhood.stats <- calcDiffNeighborhood(neighborhood)
    HTML(paste0(neighborhood, " has ", percentRound(neighborhood.stats$parks), "% off of the average number of parks."))
  })
  
  output$address.playareas <- renderUI({
    neighborhood <- reactive.values$neighborhood[5]
    neighborhood.stats <- calcDiffNeighborhood(neighborhood)
    HTML(paste0(neighborhood, " has ", percentRound(neighborhood.stats$play.areas), "% off of the average number of play areas."))
  })
  
  output$address.landmarks <- renderUI({
    neighborhood <- reactive.values$neighborhood[5]
    neighborhood.stats <- calcDiffNeighborhood(neighborhood)
    HTML(paste0(neighborhood, " has ", percentRound(neighborhood.stats$landmarks), "% off of the average number of play landmarks."))
  })
  
  output$address.viewpoints <- renderUI({
    neighborhood <- reactive.values$neighborhood[5]
    neighborhood.stats <- calcDiffNeighborhood(neighborhood)
    HTML(paste0(neighborhood, " has ", percentRound(neighborhood.stats$viewpoints), "% off of the average number of viewpoints"))
  })
  
  output$address.garages <- renderUI({
    neighborhood <- reactive.values$neighborhood[5]
    neighborhood.stats <- calcDiffNeighborhood(neighborhood)
    HTML(paste0(neighborhood, " has ", percentRound(neighborhood.stats$garages), "% off of the average number of garages"))
  })
  
  output$address.bikes <- renderUI({
    neighborhood <- reactive.values$neighborhood[5]
    neighborhood.stats <- calcDiffNeighborhood(neighborhood)
    HTML(paste0(neighborhood, " has ", percentRound(neighborhood.stats$bikes), "% off of the average number of bikes."))
  })
  
  output$address.price <- renderText({
    paste0("House Price for: ", input$user.address, ":\n$", reactive.values$price$amount, " ", reactive.values$price$currency)
  })
  
  ###### Summary Table ######
  output$mytable = DT::renderDataTable({
    selections <- c()
    for(i in 1:length(input$all.table)) {
      selections <- c(selections, input$all.table[i])
    }
    all.summary.data %>%
      select(selections)
  })
})