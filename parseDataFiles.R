
################################
# Read in the CSV data and store it in a variable
# Iterate through all data files

files <- list.files(path="./data/", pattern = ".csv")
for(i in 1:length(files)) {
  # Update temp file
  fileToLoad <- files[i]
  print(paste("Parsing:",fileToLoad))
  # Read in file
  origFile <- read.csv(paste0("./data/",fileToLoad), stringsAsFactors = FALSE)
  origFile <- read.csv("./data_modified/Police_Incidents.csv", stringsAsFactors = FALSE)
  # Loop through the addresses to get the latitude and longitude of each address and add it to the
  # origFile data frame in new columns lat and lon
  for(i in 1:nrow(origFile))
  {
    test.location <- SpatialPoints(list(origFile$Longitude[i],origFile$Latitude[i]))
    proj4string(test.location) <- CRS.new # verify same identity
    # add neighborhood to csv for each row
    # the over function shows the overlap between the two regions
    origFile$Neighborhood[i] <- as.character(over(test.location, WA)$Name)
  }
  # Write a CSV file containing origFile to the working directory
  write.csv(origFile, paste0("./data_modified/",strsplit(fileToLoad, ".csv"),"-modified.csv"), row.names=FALSE)
}

################################