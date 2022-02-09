# Scaling Options for Graphs
list(
  source("Global/max_test.R", local = TRUE)[1],
  watts_max <- max_test2(cleaned_data()$Power),
  ## All Scaling Options
  
  ## VO2/VCO2 Scaling Options
  
  if(watts_max>0 & 50>watts_max) {
    VO2_range_start <- 0
    VO2_range_end <- 1
    VO2_major_tick <- round(0.2, 2)
    VO2_minor_tick <- round(0.2, 2)
  }
  else if(watts_max>49 & 100>watts_max) {
    VO2_range_start <- round(0, 2)
    VO2_range_end <- round(2, 2)
    VO2_major_tick <- round(1, 2)
    VO2_minor_tick <- round(0.5, 2)
  }
  else if(watts_max>99 & 150>watts_max) {
    VO2_range_start <- round(0, 2)
    VO2_range_end <- round(3, 2)
    VO2_major_tick <- round(1, 2)
    VO2_minor_tick <- round(0.5, 2)
  }
  else if(watts_max>149 & 200>watts_max) {
    VO2_range_start <- round(0, 2)
    VO2_range_end <- round(4, 2)
    VO2_major_tick <- round(1, 2)
    VO2_minor_tick <- round(0.5, 2)
  }
  else if(watts_max>199 & 300>watts_max) {
    VO2_range_start <- round(0, 2)
    VO2_range_end <- round(5, 2)
    VO2_major_tick <- round(2, 2)
    VO2_minor_tick <- round(1, 2)
  }
  else if(watts_max>299 & 400>watts_max) {
    VO2_range_start <- round(0, 2)
    VO2_range_end <- round(6, 2)
    VO2_major_tick <- round(4, 2)
    VO2_minor_tick <- round(2, 2)
  }
  else {
    next
  },
  
  ## Watts Scaling Options
  
  if(watts_max>0 & 50>watts_max) {
    watts_range_start <- 0
    watts_range_end <- 50
    watts_major_tick <- 10
    watts_minor_tick <- 10
  }
  else if(watts_max>49 & 100>watts_max) {
    watts_range_start <- 0
    watts_range_end <- 100
    watts_major_tick <- 20
    watts_minor_tick <- 10
  }
  else if(watts_max>99 & 150>watts_max) {
    watts_range_start <- 0
    watts_range_end <- 150
    watts_major_tick <- 50
    watts_minor_tick <- 25
  }
  else if(watts_max>149 & 200>watts_max) {
    watts_range_start <- 0
    watts_range_end <- 200
    watts_major_tick <- 100
    watts_minor_tick <- 50
  }
  else if(watts_max>199 & 300>watts_max) {
    watts_range_start <- 0
    watts_range_end <- 300
    watts_major_tick <- 100
    watts_minor_tick <- 50
  }
  else if(watts_max>299 & 400>watts_max) {
    watts_range_start <- 0
    watts_range_end <- 400
    watts_major_tick <- 200
    watts_minor_tick <- 100
  }
  
  else {
    next
  },
  
  ## VE Scaling Options
  
  if(watts_max>0 & 50>watts_max) {
    VE_range_start <- round(0, 2)
    VE_range_end <- round(60, 2)
    VE_major_tick <- round(10, 2)
    # VE_minor_tick <- round(10, 2)
  }
  else if(watts_max>49 & 100>watts_max) {
    VE_range_start <- round(0, 2)
    VE_range_end <- round(80, 2)
    VE_major_tick <- round(20, 2)
    VE_minor_tick <- round(10, 2)
  }
  else if(watts_max>99 & 150>watts_max) {
    VE_range_start <- round(0, 2)
    VE_range_end <- round(100, 2)
    VE_major_tick <- round(20, 2)
    VE_minor_tick <- round(10, 2)
  }
  else if(watts_max>149 & 200>watts_max) {
    VE_range_start <- round(0, 2)
    VE_range_end <- round(120, 2)
    VE_major_tick <- round(20, 2)
    VE_minor_tick <- round(10, 2)
  }
  else if(watts_max>199 & 300>watts_max) {
    VE_range_start <- round(0, 2)
    VE_range_end <- round(160, 2)
    VE_major_tick <- round(20, 2)
    VE_minor_tick <- round(10, 2)
  }
  else if(watts_max>299 & 400>watts_max) {
    VE_range_start <- round(0, 2)
    VE_range_end <- round(200, 2)
    VE_major_tick <- round(30, 2)
    VE_minor_tick <- round(15, 2)
  }
  else {
    next
  },
  
  ## fC Scaling Options
  
  fC_range_start <- round(40, 2),
  fC_range_end <- round(200, 2),
  fC_major_tick <- round(40, 2),
  # fC_minor_tick <- round(20, 2),
  
  ## VT Scaling Options
  
  VT_range_start <- round(0, 2),
  VT_range_end <- round(4, 2),
  VT_major_tick <- round(1, 2),
  VT_minor_tick <- round(0.5, 2)
  
) # End List