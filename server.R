library(dplyr)
library(plotly)
library(leaflet)

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
                   hoverinfo = 'text',
                   text = ~paste0("Price: ", values, " unit<br />",
                                  "Years.Month: ", range)) %>%
             add_lines(x = range, y = values, name = "Trend") %>%
             layout(title = paste0(input$neighborhood, " Neighborhood"),
                    xaxis = list(title = "Time"),
                    yaxis = list(title = "Price ($)"),
                    margin = list(b = 200))   #### regression line abline(lm(values~range), col="red")
    )
  })
})
