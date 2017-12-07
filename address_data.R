# XML API
library("httr")
library("XML")
library(plotly)

source('./api_keys.R')
source('./functions.R')

seattle.address <- "4742 19th Ave NE, Seattle, WA 98105"
ballard.address <- "2226 NW 62nd St APT 3, Seattle, WA 98107"
getHousePrice(seattle.address)
getHousePrice(ballard.address)

getAddressNeighborhood(ballard.address)


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

plot_geo(data, locationmode = 'USA-states', sizes = c(1, 50)) %>%
  add_markers(
    x = ~long, y = ~lat, size = 1, hoverinfo = "text",
    text = ~paste(street, city.state.zip, "\n",
                  "Latitude:", lat, "\n",
                  "Longitude:", long)
  ) %>%
  layout(title = 'Address Location', geo = g)


# Zillow site: https://www.zillow.com/howto/api/neighborhood-boundaries.htm
# ggmap needs recognition

# https://www.zillow.com/webservice/GetSearchResults.htm

# http://www.zillow.com/webservice/GetSearchResults.htm
# ?zws-id=X1-ZWz1g4sdglhwqz_a57uf&address=2114+Bigelow+Ave&citystatezip=Seattle%2C+WA