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