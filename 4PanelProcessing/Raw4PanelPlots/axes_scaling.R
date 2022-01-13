# Scaling Options for Graphs
list(
  source("Global/max_test.R", local = TRUE)[1],
  watts_max <- max_test2(cleaned_data()$Power),
  ## All Scaling Options
  
  ## VO2/VCO2 Scaling Options
  
  if(watts_max>0 & 50>watts_max) {
    VO2_range_start <- 0
    VO2_range_end <- 1
    VO2_major_tick <- 0.2
    VO2_minor_tick <- 0.2
  }
  else if(watts_max>49 & 100>watts_max) {
    VO2_range_start <- 0
    VO2_range_end <- 2
    VO2_major_tick <- 1
    VO2_minor_tick <- 0.5
  }
  else if(watts_max>99 & 150>watts_max) {
    VO2_range_start <- 0
    VO2_range_end <- 3
    VO2_major_tick <- 1
    VO2_minor_tick <- 0.5
  }
  else if(watts_max>149 & 200>watts_max) {
    VO2_range_start <- 0
    VO2_range_end <- 4
    VO2_major_tick <- 1
    VO2_minor_tick <- 0.5
  }
  else if(watts_max>199 & 300>watts_max) {
    VO2_range_start <- 0
    VO2_range_end <- 5
    VO2_major_tick <- 2
    VO2_minor_tick <- 1
  }
  else if(watts_max>299 & 400>watts_max) {
    VO2_range_start <- 0
    VO2_range_end <- 6
    VO2_major_tick <- 4
    VO2_minor_tick <- 2
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
    VE_range_start <- 0
    VE_range_end <- 60
    VE_major_tick <- 10
    VE_minor_tick <- 10
  }
  else if(watts_max>49 & 100>watts_max) {
    VE_range_start <- 0
    VE_range_end <- 80
    VE_major_tick <- 20
    VE_minor_tick <- 10
  }
  else if(watts_max>99 & 150>watts_max) {
    VE_range_start <- 0
    VE_range_end <- 100
    VE_major_tick <- 20
    VE_minor_tick <- 10
  }
  else if(watts_max>149 & 200>watts_max) {
    VE_range_start <- 0
    VE_range_end <- 120
    VE_major_tick <- 20
    VE_minor_tick <- 10
  }
  else if(watts_max>199 & 300>watts_max) {
    VE_range_start <- 0
    VE_range_end <- 160
    VE_major_tick <- 20
    VE_minor_tick <- 10
  }
  else if(watts_max>299 & 400>watts_max) {
    VE_range_start <- 0
    VE_range_end <- 200
    VE_major_tick <- 30
    VE_minor_tick <- 15
  }
  else {
    next
  },
  
  ## fC Scaling Options
  
  fC_range_start <- 40,
  fC_range_end <- 240,
  fC_major_tick <- 40,
  fC_minor_tick <- 20,
  
  ## VT Scaling Options
  
  VT_range_start <- 0,
  VT_range_end <- 4,
  VT_major_tick <- 1,
  VT_minor_tick <- 0.5
  
) # End List