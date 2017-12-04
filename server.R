library(dplyr)
library(plotly)

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
    
    range <- list()
    print(as.character((as.integer(input$time[1] * 100):as.integer(input$time[2] * 100))%%12)/100)
    
    # Get all data from the range
    range <- region.data %>%
      select(as.character(input$time[1]):as.character(input$time[2]))
    
    return(plot_ly(data = df, x= df[,input$xvar], y= df[,input$yvar], 
                   xlab = input$xvar, ylab = input$yvar,
                   type = 'scatter', color = ~type, mode = 'markers', 
                   hoverinfo = 'text',                                 #### Title: the neighboorhood
                   text = ~paste0("Years: ", df[,input$xvar], "<br />",    ###### hover info?
                                  "Price: ", df[,input$yvar], " unit")) %>%
             layout(xaxis = list(title = my.x), 
                    yaxis = list(title = my.y))
    )
  })
})
