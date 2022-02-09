list(

## Finds the End of the Test Depending on VO2 Dropping
end_test_machine <- function(distribution_input) {
  for (i in 1:length(distribution_input)){
    if (distribution_input[i] < -0.05) {
      if(distribution_input[i] < -0.05) {
        end_test_position <- i
        next
      }
    } # End If Statement
    else {
      next
    }
  } # End For Loop
  return(end_test_position)
}, # End Function

end_test_machine_coop <- function(vo2data) {
  vo2max <- max(vo2data)
  for (i in 1:length(vo2data)) {
    if (vo2data[i] == vo2max) {
      position_vo2max = i
    }
  }
  vo2data <- vo2data[-c(1:position_vo2max), ]
  
  for (i in 1:length(vo2data)) {
    if (vo2data[i] <= vo2max - .05) {
      new_pos == i
    }
  }
  
  return(position_vo2max+new_pos)
},



## Finds the End of the Test Depending on RPM
end_test_machine_brett <- function(data_input) {
  for (i in 1:length(data_input)){
    if (data_input[i] < 50) {
      end_test_position <- i
    } # End If Statement
    else {
      next
    }
  } # End For Loop
  return(end_test_position)
} # End Function



)