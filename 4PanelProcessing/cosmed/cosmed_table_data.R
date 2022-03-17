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
  
  refwork_max <- round(get_refwork_max(ibw, refvo2_liters, suggested_workrate), 0),
  
  vo2_theta <- round(get_VO2theta(age, sex, height), 2),
  
  lln_vo2 <- round(get_lln_vo2(vo2_theta, sex), 2),
  
  ref_fcmax <- round(get_ref_fcmax(age), 0),
  
  chronotropic_male <- get_chronotropic_male(age, height, weight),
  
  chronotopic_index <- round(get_chronotopic_index(sex, chronotropic_male), 0),
  
  ventilatory_efficiency <- get_ventilatory_efficiency(age),
  
  measured_metabolicefficiency <- round(get_metabolicefficiency(cleaned_data()$Power, cleaned_data()$VO2, cleaned_data())*1000, 1), 
  
  measured_chronotropic <- round(get_measured_chronotropic(cleaned_data()$VO2, cleaned_data()$HR, cleaned_data()), 0),
  
  
  
  ## Measured Data
  vo2_data <- cleaned_data()$VO2,
  p_data <- cleaned_data()$Power,
  dummy_dataframe <- data.frame(power = p_data, vo2 = vo2_data),
  vo2_max_data <- linreg_machine_data(dummy_dataframe$power, dummy_dataframe$vo2, dummy_dataframe),
  vo2_max_liters <- max(vo2_max_data),
  vo2_max_liters <- round(vo2_max_liters, 2),
  vo2_max_liters <- as.numeric(vo2_max_liters),
  
  vo2_max_ml <- round((vo2_max_liters*1000) / weight, 0),
  power_max <- round(max(cleaned_data()$Power), 0),
  ve_max <- round(max(cleaned_data()$VE), 0),
  fc_max <- round(max(cleaned_data()$HR), 0)
  
)