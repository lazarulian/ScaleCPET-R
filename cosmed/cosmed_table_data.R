# Data Variable Storage

list(
  source("Global/demographics_data.R", local = TRUE)[1],
  source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1],
  source("DataCalculation/table_data_functions.R", local = TRUE)[1],
  source("DataCalculation/endtest_data_max.R", local = TRUE)[1],
  source("TestValidity/linearity_machine.R", local = TRUE)[1],
  
  
  ## Calculated Data
  ibw <- getIbw(height, sex),
  
  refvo2_ml <- round(get_refvo2_ml(sex, age), 0),
  
  refvo2_liters <- round(get_refvo2_liters(refvo2_ml, ibw), 2),
  
  suggested_workrate <- round(get_suggested_workrate(refvo2_ml, ibw), 0),
  
  # refwork_max <- round(get_refwork_max(ibw, refvo2_liters, suggested_workrate), 0),
  refwork_max <- round(get_refwork_max(ibw, refvo2_liters), 0),
  
  
  vo2_theta <- round(get_VO2theta(age, sex, height), 2),
  
  lln_vo2 <- round(get_lln_vo2(vo2_theta, sex), 2),
  
  ref_fcmax <- round(get_ref_fcmax(age), 0),
  
  chronotropic_male <- get_chronotropic_male(age, height, weight),
  
  chronotopic_index <- round(get_chronotopic_index(sex, chronotropic_male), 0),
  
  ventilatory_efficiency <- get_ventilatory_efficiency(age),
  
  measured_metabolicefficiency <- round(get_metabolicefficiency(cleaned_data()$Power, cleaned_data()$VO2, cleaned_data())*1000, 1), 
  
  measured_chronotropic <- round(get_measured_chronotropic(cleaned_data()$VO2, cleaned_data()$HR, cleaned_data()), 0),
  
  
  ## Measured Data
  why_power <- cleaned_data()$Power,
  why_end <- cleaned_data()$end_test,
  why_vo2 <- cleaned_data()$VO2,
  why_vco2 <- cleaned_data()$VCO2,
  why_HR <- cleaned_data()$HR,
  why_VE <- cleaned_data()$VE,
  why_t <- cleaned_data()$t,
    
  wbb1 <- data.frame("t" = why_t, "Power" = why_power, "end_test" = why_end, "VO2" = why_vo2, "VE" = why_VE, "HR" = why_HR, "VCO2" = why_vco2),
  power_max <- regression_max(wbb1$t, wbb1$Power, wbb1, wbb1$end_test[1]),
  power_max <- round(power_max, 0),
  vo2_max_liters <- regression_max(wbb1$Power, wbb1$VO2,  wbb1, power_max),
  vo2_max_liters <- round(vo2_max_liters, 2),
  vo2_max_liters <- as.numeric(vo2_max_liters),
  vo2_max_ml <- round((vo2_max_liters*1000) / weight, 0),
  vco2_max_liters <- regression_max(wbb1$Power, wbb1$VCO2,  wbb1, power_max),
  ve_max <- round(max(wbb1$VE), 0),
  fc_max <- round(regression_max(wbb1$VO2, wbb1$HR, wbb1,  vo2_max_liters), 0)

)