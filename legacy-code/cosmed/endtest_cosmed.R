## End Test of Cosmed
list(
endtest_cosmed <- function(vo2data) {
  ## Finds the position of the end of the cosmed test
  vo2max <- max(vo2data)
  for (i in 1:length(vo2data)) {
    if (vo2data[i] == vo2max) {
      position_vo2max <- i
    }
  }
  return(position_vo2max+2)
}
)