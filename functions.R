# All Functions
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


### Address Functions ###
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

getAddressNeighborhood <- function(full.address) {
  data <- data.frame(parseAddress(full.address), stringsAsFactors = FALSE)
  test.location <- SpatialPoints(list(data$long,data$lat))		
  proj4string(test.location) <- CRS.new # verify same identity	
  # the over function shows the overlap between the two regions		
  data$neighborhood <- as.character(over(test.location, WA)$Name)
  return(data)
}

calcPercentDiff <- function(test.value, mid) {
  if(is.na(test.value)) { test.value <- 0 }
  return(100 * (test.value - mid) / mid)
}

calcDiffNeighborhood <- function(test.neighborhood) {
  if(is.na(test.neighborhood)) { return(NA) }
  neighborhood.data <- all.summary.data %>%
    filter(Neighborhood == test.neighborhood)
  diffs <- list()
  diffs$neighborhood <- test.neighborhood
  diffs$bike <- calcPercentDiff(neighborhood.data$`Number of Bike Racks` , all.summary.means[["Number of Bike Racks"]])
  diffs$play.areas <- calcPercentDiff(neighborhood.data$`Childrens Play Areas` , all.summary.means[["Childrens Play Areas"]])
  diffs$landmarks <- calcPercentDiff(neighborhood.data$Landmarks , all.summary.means[["Landmarks"]])
  diffs$parks <- calcPercentDiff(neighborhood.data$Parks , all.summary.means[["Parks"]])
  diffs$viewpoints <- calcPercentDiff(neighborhood.data$Viewpoints , all.summary.means[["Viewpoints"]])
  diffs$garages <- calcPercentDiff(neighborhood.data$`Number of Garages and Parking Lots` , all.summary.means[["Number of Garages and Parking Lots"]])
  return(diffs)
}

percentRound <- function(num) {
  if(is.double(num)) {
    return(round(num, digits = 2))
  }
  return(0)
}