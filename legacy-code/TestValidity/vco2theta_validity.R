list(
  ## VCO2 Theta Validity
  ## Will provide a measure of determining if the VCO2 theta regression is 
  ## potentially inaccurate. Determines this by seeing if the difference in slopes
  ## is greater or less than 5.
  source("DataCalculation/regression_analysis.R", local = TRUE)[1],

  if (abs(slopes_vco2ve$VCO2_data[1]-slopes_vco2ve$VCO2_data[2]) < 5) {
    vco2theta_validity <- "The ventilatory threshold should be interpreted with 
    caution because an obvious inflection in the relationship between VE and 
    VCO2 could not be detected. Consider visual selection."
    vco2_fail <- 1
    vco2_pass <- 0
  }
  
  else {
    vco2theta_validity <- ""
    vco2_fail <- 0
    vco2_pass <- 1
  }
  
  
  
)