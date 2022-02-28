# Table Creation

list(
  source("cosmed/cosmed_table_data.R", local = TRUE)[1],
  source("Global/demographics_data.R", local = TRUE)[1],
  source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1],
  source("DataCalculation/regression_analysis.R", local = TRUE)[1],
  
  VECAP <- round(get_nhanes(age, sex, height)*40, 0),
  
  
  VE <- round((get_nhanes(age, sex, height)*20+20), 0),
  rounded_vco2 <- round(vco2_theta, 2),
  metabolic_efficiency_label <- expression("VO2", beta, " (L/min)"),
  
  new_string <- paste(vo2_theta, lln_vo2, sep=",  "),
  ve_vars <- paste(VE, VECAP, sep=",  "),
  
  ## Percent Value Calculations
  percent_work <- paste(round((power_max / refwork_max)*100, 0),"%"),
  percent_vo2_l <- paste(round((vo2_max_liters / refvo2_liters)*100, 0),"%"),
  percent_vo2_ml <- paste(round((vo2_max_ml / refvo2_ml)*100, 0),"%"),
  percent_fc <- paste(round((fc_max / ref_fcmax)*100, 0),"%"),
  percent_ve <- paste(round((ve_max / VECAP)*100, 0),"%"),
  
  
  reference_gt_values <- c(refwork_max, "10.3", refvo2_ml, refvo2_liters,
                            new_string, "1.00", ref_fcmax, chronotopic_index,
                           ve_vars, "--",
                           ventilatory_efficiency),
  
  percent_gt_values <- c(percent_work, "--", percent_vo2_ml, percent_vo2_l,
                         "--", "--", percent_fc, "--",
                         percent_ve, "--",
                         "--"),
  
  measured_gt_values <- c(power_max, measured_metabolicefficiency, vo2_max_ml, vo2_max_liters,
                          vo2theta, "1.00", fc_max, measured_chronotropic, ve_max, rounded_vco2, lowersegment_venteff),
  
  a<-2,
  b<-2,
  c<-"max",
  e<- "E",
  f <- "C",
  g <- "cap",
  
  ## THE GT TABLE
  
  gt_confirmed <- tibble('Variable' = c(glue("Work Rate @{c}~ (watts)"), "Metabolic Efficiency (ml/min/watt)", 
                         glue("VO@{2}~ @{c}~ (ml/kg/min)"), glue("VO@{2}~ @{c}~ (L/min)"), 
                                  glue("VO@{2}~\U03B8,  LLN (L/min)"), "Muscle RQ",
                                 glue("f@{f}~ @{c}~ (/min)"), "Chronotropic Index (/L)",
                                 glue("V@{e}~ @{c}~, V@{e}~ @{g}~ (L/min)"), glue("VCO@{2}~\U03B8 (L/min)"), "Ventilatory Efficiency"),
                         
                         `Reference` = reference_gt_values, 
                         `Measured` = measured_gt_values, `Percent` = percent_gt_values) %>% 
    gt() %>%
    tab_row_group(
      label = md("**Ventilatory Response**"),
      rows = 9:11
    ) %>%
    tab_row_group(
      label = md("**Cardiovascular Performance**"),
      rows = 7:8
    ) %>%
    tab_row_group(
      label = md("**Aerobic Performance**"),
      rows = 3:6
    ) %>%
    tab_row_group(
      label = md("**Energetics**"),
      rows = 1:2
    ) %>%
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
    cols_align(
      align = "center",
      columns = Percent) 
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