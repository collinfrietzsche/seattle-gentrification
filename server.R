library(dplyr)
library(plotly)
library(leafletR)

buildMinMaxList <- function(min, max) {
  range <- c()
  check.range <- ((min*100):(max*100))/100
  for(i in 1:length(check.range)) {
    test.val <- (as.double(substr(as.character(check.range[i]), 5, 7)) / 0.12)
    if (!is.na(test.val) & test.val <= 1) {
      range <- c(range, as.character(check.range[i]))
    }
  }
  return(range)
}

df <- read.csv('./data_modified/Seattle_Median_House_Prices.csv', stringsAsFactors = FALSE, check.names = FALSE)
# Arrange region name in order
df <- df %>%
  select(2:length(df)) %>%
  arrange(RegionName)
# Get all the names in the region
names <- df$RegionName
####################### source this

shinyServer(function(input, output) {
  
  ###### Police Incident Heatmap ######
  # output$police.density <- renderLeaflet({
  #   map
  # })
  
  ###### Time vs Housing Price ######
  output$scatter <- renderPlotly({
    # Get the row of the neighborhood
    region.data <- df %>%
      filter(RegionName == input$neighborhood)
      # filter(RegionName == "Admiral")
    
    # Get all data from the range
    range <- buildMinMaxList(input$time[1], input$time[2])
    # range <- buildMinMaxList(2010.05, 2015.11) 

    # select data range
    range.data <- region.data %>%
      select(range)
    
    # make the values into list
    values <- list()
    for(i in 1:length(range.data)) {
      values[i] <- range.data[1, i]
    }
    
    #range.data[1,]

    return(plot_ly(data = df, x= range, y= values,
                   xlab = range, ylab = values,
                   type = 'scatter', mode = 'markers', #color = ~type
                   hoverinfo = 'text',
                   text = ~paste0("Price: ", values, " unit<br />",
                                  "Years.Month: ", range)) %>%
             add_trace(x = range, y = values, type = "scatter", 
                       mode = "line", name = "", line = list(width = 2)) %>%
             layout(title = paste0(input$neighborhood, " Neighborhood"),
                    xaxis = list(title = "Time"),
                    yaxis = list(title = "Price ($)"),
                    margin = list(b = 200))   #### regression line abline(lm(values~range), col="red")
    )
  })
})
