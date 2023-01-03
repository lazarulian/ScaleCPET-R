list(
max_test1 <- function(max_comparison, data_input) {
    distance_counter <- 0
    for(i in 1:length(data_input)){
      if (abs(data_input[i]-max_comparison) < 10) {
        distance_counter <- distance_counter + 1
      } 
      else {
        next
      }
    } # End For Loop
    return(distance_counter)
},

max_test2 <- function(data_input) {
  max_value <- 0
  for(i in 1:length(data_input)) {
      if (max_test1(data_input[i], data_input) > 1) {
          if (data_input[i] > max_value) {
            max_value <- data_input[i]
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
