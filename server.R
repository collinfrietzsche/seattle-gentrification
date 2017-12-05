library(dplyr)
library(plotly)

buildMinMaxList <- function(min, max) {
  count <- 1
  range <- list()
  check.range <- ((min*100):(max*100))/100
  for(i in 1:length(check.range)) {
    test.val <- (as.double(substr(as.character(check.range[i]), 5, 7)) / 0.12)
    if (!is.na(test.val) & test.val <= 1) {
      print(check.range[i])
      range[count] <- as.double(check.range[i])
      count <- count + 1
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
  output$scatter <- renderPlotly({
    # Get the row of the neighborhood
    region.data <- df %>%
      filter(RegionName == input$neighborhood)
    
    # Get all data from the range
    range <- buildMinMaxList(input$time[1], input$time[2])
    
    return(plot_ly(data = df, x= df[,input$xvar], y= df[,input$yvar], 
                   xlab = input$xvar, ylab = input$yvar,
                   type = 'scatter', color = ~type, mode = 'markers', 
                   hoverinfo = 'text',                                 #### Title: the neighboorhood
                   text = ~paste0("Years: ", df[,input$xvar], "<br />",    ###### hover info?
                                  "Price: ", df[,input$yvar], " unit")) %>%
             layout(xaxis = list(title = "my.x"), 
                    yaxis = list(title = "my.y"))
    )
  })
})
