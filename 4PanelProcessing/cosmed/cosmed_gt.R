# Table Creation

list(
  source("cosmed/cosmed_table_data.R", local = TRUE)[1],
  
  gt_variable_names <- c("ref VO2max (ml/kg/min)", "ref VO,max (L/ min)", 
                         "ref Wmax (watts)", "Metabolic Efficiency (ml/min/watt)", 
                         "Muscle RQ", "VO2q (L/min)", "LLN VO2q (L/min)", 
                         "ref fCmax (/min)", "Chronotropic Index (/L)",
                         "ref VEmax (L/min)", "Ventilatory Efficiency"),
  
  
  
  x <- data.frame("Variable" = gt_variable_names, 
                  "Reference Value" = c(refvo2_ml, refvo2_liters, refwork_max, "0", 
                                        "0", vo2_theta, lln_vo2, ref_fcmax, chronotopic_index, 
                                        "0", ventilatory_efficiency), 
                  
                  "Measured Value" = c(0, end_VO2, end_power, 0, 0, 0, 0, 0, 0, 0, 
                                       0)),
  
  table <- gt(x) %>% tab_header(
    title = md("**Key Variables**"),
  )
  
)