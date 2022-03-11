# Metabolic Efficiency Validity

# Metabolic efficiency (meff) is the slope of the relationship between smoothed
# oxygen uptake and corrected work rate. The slope value should be
# >8.0 and <13.0 ml/min/watt. If meff is outside this range then the
# following technical comment will be made:

list(
  source("TestValidity/linearity_machine.R", local = TRUE),
  time_minutes <- cleaned_data()$t/60,
  time_minutes <- as.numeric(time_minutes),
  
  VO2_mL <- cleaned_data()$VO2*1000,
  VO2_mL <- as.numeric(VO2_mL),
  
  corrected_work <- linreg_machine_data(time_minutes, cleaned_data()$Power, cleaned_data()),
  CPowerVO2_summary <- lm(VO2_mL ~ corrected_work, data = cleaned_data()),
  CPowerVO2_slope <- summary(CPowerVO2_summary)$coef[[2]],
  
  # IMPORTANT: Did not convert this data to mL/min/watt
  # metabolic_efficiency_validity is the textOutput for validity
  
  if (CPowerVO2_slope < 13 & CPowerVO2_slope > 8) {
    metabolic_efficiency_validity <- "The ramp increase in work was  accompanied by and appropriate 
    increase on oxygen uptake."
  } # End If
  
  else {
    metabolic_efficiency_validity <- 
    "This test cannot be reliably interpreted because the
    ramp increase in work was not accompanied by and appropriate
    increase on oxygen uptake."
  } # End Else
  
) # End List
