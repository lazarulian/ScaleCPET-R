# Table Creation

list(
  source("cosmed/cosmed_table_data.R", local = TRUE)[1],
  source("Global/demographics_data.R", local = TRUE)[1],
  source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1],
  source("DataCalculation/regression_analysis.R", local = TRUE)[1],
  
  VE <- round((get_nhanes(age, sex, height)*20+20), 0),

  metabolic_efficiency_label <- expression("VO2", beta, " (L/min)"),
  
  new_string <- paste(vo2_theta, lln_vo2, sep=",  "),
  
  reference_gt_values <- c(refvo2_ml, refvo2_liters, refwork_max, "10.3",
                           "1.00", new_string, ref_fcmax, chronotopic_index,
                           VE,
                           ventilatory_efficiency),
  
  measured_gt_values <- c(vo2_max_ml, vo2_max_liters, power_max, measured_metabolicefficiency,
                          vco2_theta, "0", fc_max, measured_chronotropic, ve_max, lowersegment_venteff),
  
  a<-2,
  b<-2,
  c<-"max",
  e<- "E",
  f <- "C",
  
  ## THE GT TABLE
  
  gt_confirmed <- tibble('Variable' = c(glue("VO@{2}~ @{c}~ (ml/kg/min)"), glue("VO@{2}~ @{c}~ (L/min)"), 
                                 glue("Work Rate @{c}~ (watts)"), "Metabolic Efficiency (ml/min/watt)", 
                                 "Muscle RQ", glue("VO@{2}~\U03B8,  LLN (L/min)"), 
                                 glue("f@{f}~ @{c}~ (/min)"), "Chronotropic Index (/L)",
                                 glue("V@{e}~ @{c}~ (L/min)"), "Ventilatory Efficiency"),
                         
                         `Reference` = reference_gt_values, 
                         `Measured` = measured_gt_values) %>% 
    gt() %>%
    tab_source_note(
      md(
        "**Note:** All variable names and interpolations are recorded in the readme section of this software"
      )
    ) %>%
    cols_align(
      align = "center",
      columns = Measured)
      %>%
    cols_align(
      align = "center",
      columns = Reference) 
  %>%
    # tab_header(
    #   title = md("**Key Variables**"))%>%  
    text_transform(
      locations = cells_body(),
      fn = function(x) {
        str_replace_all(x,
                        pattern = "@",
                        replacement = "<sub>") %>% 
          str_replace_all("~",
                          "</sub>")}
    )
  
  
) # End List