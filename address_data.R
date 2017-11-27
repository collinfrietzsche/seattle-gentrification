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

address.ret <- parseAddress("2114 Bigelow Ave Seattle, WA 98109")
data <- getAddressData(address.ret)


# Zillow site: https://www.zillow.com/howto/api/neighborhood-boundaries.htm
# ggmap needs recognition

# zestimate: https://www.zillow.com/howto/api/GetZestimate.htm
# https://www.zillow.com/webservice/GetSearchResults.htm

# http://www.zillow.com/webservice/GetSearchResults.htm
# ?zws-id=X1-ZWz1g4sdglhwqz_a57uf&address=2114+Bigelow+Ave&citystatezip=Seattle%2C+WA