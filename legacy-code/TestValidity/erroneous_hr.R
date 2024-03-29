# Erroneous heart rate

# The rate of heart rate increase will be calculated by regression analysis of the
# relationship between heart rate and time for the baseline and ramp phase of the
# test. The relationship should be linear with an r2 value of >0.8. If these
# criteria are not met the ECG should be examined for evidence of dysrhythmia such
# as atrial fibrillation and the following technical comment will be made:

list(
  rawHRTime_regression <- lm(cleaned_data()$t ~ cleaned_data()$HR, data = cleaned_data()),
  rawHRTime_rsquared <- summary(rawHRTime_regression)$r.squared,
  
  if (rawHRTime_rsquared > 0.8) {
    erroneous_hr_validity <- "Variability of heart rate is normal."
    erroneous_fail <- 0
    erroneous_pass <- 1
  }
  
  else {
    erroneous_hr_validity <- "Excessive variability of heart rate has been detected. 
    Please examine the ECG for evidence of cardiac dysrhythmia."
    erroneous_fail <- 1
    erroneous_pass <- 0
  }
  
)