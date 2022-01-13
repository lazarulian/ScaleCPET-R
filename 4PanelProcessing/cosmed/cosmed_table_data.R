# Data Variable Storage

list(
  source("Global/demographics_data.R", local = TRUE)[1],
  source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1],
  source("DataCalculation/table_data_functions.R", local = TRUE)[1],
  source("DataCalculation/endtest_data_max.R", local = TRUE)[1],
  
  ibw <- getIbw(height, sex),
  
  refvo2_ml <- get_refvo2_ml(sex, age),
  
  refvo2_liters <- get_refvo2_liters(refvo2_ml, ibw),
  
  suggested_workrate <- get_suggested_workrate(refvo2_ml, ibw),
  
  refwork_max <- get_refwork_max(ibw, refvo2_liters, suggested_workrate),
  
  vo2_theta <- get_VO2theta(age, sex, height),
  
  lln_vo2 <- get_lln_vo2(vo2_theta, sex),
  
  ref_fcmax <- get_ref_fcmax(age),
  
  chronotropic_male <- get_chronotropic_male(age, height, weight),
  
  chronotopic_index <- get_chronotopic_index(sex, chronotropic_male),
  
  ventilatory_efficiency <- get_ventilatory_efficiency(age)
  
)