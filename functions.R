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