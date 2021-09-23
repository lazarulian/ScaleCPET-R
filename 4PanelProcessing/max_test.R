list(
max_test1 <- function(max_input, parse_range) {
    distance_counter <- 0
    for(i in 1:length(parse_range)){
      if (abs(parse_range[i]-max_input) < 10) {
        distance_counter <- distance_counter + 1
      } 
      else {
        next
      }
    } # End For Loop
    return(distance_counter)
},

max_test2 <- function(parse_range) {
  max_value <- 0
  for(i in 1:length(parse_range)) {
      if (max_test1(parse_range[i], parse_range) > 1) {
          if (parse_range[i] > max_value) {
            max_value <- parse_range[i]
          }
          else {
            next
          }
      } 
        else {
          next
        }  
    }
    return(max_value)
} # End Function Declaration
) # End List
