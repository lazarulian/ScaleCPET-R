list(
  rawtimewatts_regression <- lm(cleaned_data()$t ~ cleaned_data()$Power, data = cleaned_data()),
  rawtimewatts_rsquared <- summary(rawtimewatts_regression)$r.squared,
  rawtimewatts_slope <- summary(rawtimewatts_regression)$coef[[2]],
  rawtimewatts_intercept <- summary(time.watts.lm)$coef[[1]],
  
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
  }
  
)