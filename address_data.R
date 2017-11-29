# XML API
library("httr")
library("XML")

source('api_keys.R')

parseAddress <- function(full.address) {
  address <- list()
  address.ret <- trimws(
    strsplit(
      geocode(full.address, output = "latlona", source = "google")$address,
      split = ",")[[1]]
  )
  address$street <- address.ret[1]
  address$city.state.zip <- paste(address.ret[2], address.ret[3])
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


# Zillow site: https://www.zillow.com/howto/api/neighborhood-boundaries.htm
# ggmap needs recognition

# https://www.zillow.com/webservice/GetSearchResults.htm

# http://www.zillow.com/webservice/GetSearchResults.htm
# ?zws-id=X1-ZWz1g4sdglhwqz_a57uf&address=2114+Bigelow+Ave&citystatezip=Seattle%2C+WA