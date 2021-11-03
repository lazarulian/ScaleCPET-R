list(
  ## Workrate Variability SD for Test Validity
  workrate_variability <- corrected_data()$Power-cleaned_data()$Power,
  workrate_variability_sd <- sd(workrate_variability),
  
  rawtimewatts_regression <- lm(cleaned_data()$Power ~ cleaned_data()$t, data = cleaned_data()),
  rawtimewatts_rsquared <- summary(rawtimewatts_regression)$r.squared,
  rawtimewatts_slope <- summary(rawtimewatts_regression)$coef[[2]],
  rawtimewatts_intercept <- summary(rawtimewatts_regression)$coef[[1]],
  
  if(rawtimewatts_rsquared > 0.9) {
    raw_controller_validity <- "This study can be interpreted confidently because a constant rate of work increase was 
    maintained during the ramp phase of the test."
  }
  else if (rawtimewatts_rsquared < 0.9 & rawtimewatts_rsquared > 0.8) {
    raw_controller_validity <- "This study must be interpreted with caution because a constant rate of work increase was not
    maintained during the ramp phase of the test."
  }
  else {
    raw_controller_validity <- "This study cannot be reliably interpreted because a constant rate of work increase was not maintained
  during the ramp phase of the test."
  },
  
  if(workrate_variability_sd < 10 & workrate_variability_sd > 5) {
    workrate_variability_validity <- "This test must be interpreted with caution because there was significant variability in work control
      during the ramp."
  }
  
  else if (workrate_variability_sd > 10) {
    workrate_variability_validity <- "This test cannot be reliably interpreted because there was excessive variability in work control during
    the ramp."
  }
  
  else {
    workrate_variability_validity <- "This test can be reliably interpreted because there was normal variability in work control during
    the ramp."
  }
  
)