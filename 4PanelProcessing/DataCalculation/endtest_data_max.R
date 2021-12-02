# Finds the End of Everything 
list(
  
  #============================#
  # Loading Functions and Such #
  #============================# 
  source("TestValidity/linearity_machine.R", local = TRUE)[1],
  source("Global/end_test.R", local = TRUE)[1],

  #============================#
  # Creating Max Point Machine #
  #============================# 
  
  ## This function takes two variables, finds the linear relationship and finds
   # a maximum value on the y' based off of the value of the x variable. 
  
 linreg_machine_point_data <- function(range_x, range_y, dataset, value) {
    data_summary <- lm(range_y ~ range_x, data = dataset)
    data_intercept <- summary(data_summary)$coef[[1]]
    data_slope <- summary(data_summary)$coef[[2]]
    
    corrected_data_point <- ((value)*data_slope)+data_intercept
    corrected_data_point <- as.numeric(corrected_data_point)
    
    return(corrected_data_point)
  },
  
  
  #============================#
  # Actually Caluclating Data  #
  #============================#  
 
# Calculating Position of End Test Based on RPM 
end_test_position_brett <- end_test_machine_brett(cleaned_data()$Revolution),

# Calculating Accurate Max Watts Based on End Test 
t_powerindex <- linreg_machine_data(cleaned_data()$t, cleaned_data()$Power, cleaned_data()),
end_power <- t_powerindex[end_test_position_brett],

# Calculating Accurate Max VO2 Based on Max Watts 
end_VO2 <- linreg_machine_point_data(cleaned_data()$Power, cleaned_data()$VO2, cleaned_data(), end_power),

# Calculating Accurate Max HR Based on Max VO2 
end_HR <- linreg_machine_point_data(cleaned_data()$VO2, cleaned_data()$HR, cleaned_data(), end_VO2)

) # End List