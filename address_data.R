# XML API
library("httr")
library("XML")
library(plotly)

source('api_keys.R')

parseAddress <- function(full.address) {
  address <- list()
  geo.code <- geocode(full.address, output = "latlona", source = "google")
  address.ret <- trimws(
    strsplit(
      geo.code$address,
      split = ",")[[1]]
  )
  address$street <- address.ret[1]
  address$city.state.zip <- paste(address.ret[2], address.ret[3])
  address$lat <- geo.code$lat
  address$long <- geo.code$lon
  return(address)
}

getAddressData <- function(parsed.address) {
  # send request for address
  query.params <- list("zws-id" = api.keys$zillow, "address" = parsed.address$street, "citystatezip" = parsed.address$city.state.zip)
  response <- GET("http://www.zillow.com/webservice/GetSearchResults.htm", query = query.params)
  result <- content(response, as = "parsed")
  parsed.data <- xmlToList(xmlParse(result))
  return(parsed.data)
}

getHousePrice <- function(full.address) {
  data <- getAddressData(parseAddress(full.address))$response$results[[1]]
  price <- list()
  price$amount <- data$zestimate$amount$text
  price$currency <- data$zestimate$amount$.attrs[['currency']]
  return(price)
}

seattle.address <- "4742 19th Ave NE, Seattle, WA 98105"
ballard.address <- "2226 NW 62nd St APT 3, Seattle, WA 98107"
getHousePrice(seattle.address)
getHousePrice(ballard.address)

data <- data.frame(parseAddress(seattle.address), stringsAsFactors = FALSE)


g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showland = TRUE,
  landcolor = toRGB("gray85"),
  subunitwidth = 1,
  countrywidth = 1,
  subunitcolor = toRGB("white"),
  countrycolor = toRGB("white"),
  rotation = list(),
  lonaxis = list(range = c(-125, -115)),
  lataxis = list(range = c(45, 49))
)

plot_geo(data, locationmode = 'USA-states', sizes = c(1, 50)) %>%
  add_markers(
    x = ~long, y = ~lat, size = 1, hoverinfo = "text",
    text = ~paste(street, city.state.zip)
  ) %>%
  layout(title = 'Address Location', geo = g)


# Zillow site: https://www.zillow.com/howto/api/neighborhood-boundaries.htm
# ggmap needs recognition

# https://www.zillow.com/webservice/GetSearchResults.htm

# http://www.zillow.com/webservice/GetSearchResults.htm
# ?zws-id=X1-ZWz1g4sdglhwqz_a57uf&address=2114+Bigelow+Ave&citystatezip=Seattle%2C+WA