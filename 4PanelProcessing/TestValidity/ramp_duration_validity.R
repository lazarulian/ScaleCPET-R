# Test Duration Validity
# Finds the test duration in minutes and compares to reference values.
list(
  end_test <- cleaned_data()$t[length(cleaned_data()$t)],
  test_duration <- end_test/60,
  
  if (test_duration < 5) {
    ramp_duration_validity <- "The ramp phase of this test was less than 5 
    minutes and therefore the test cannot be reliably interpreted."
  }
  
  else if (test_duration > 5 & test_duration <15) { ramp_duration_validity <- 
  "The ramp phase of this test was optimal and can be reliably interpreted."
  }
  
  else {
    ramp_duration_validity <-"The ramp phase of this test was greater than 15
    minutes and therefore the test must be interpreted with caution."
  }
)