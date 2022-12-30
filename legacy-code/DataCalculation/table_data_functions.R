## Table Data Calculation Functions
list(
get_suggested_workrate <- function(vo2_ml, ibw) {
  return((vo2_ml-7)*ibw/103)
},

get_refvo2_ml <- function(sex, age) {
  if (sex == "Male") {
    return(50.02-(0.394*age))
  }
  else {
    return(42.83-(0.371*age))
  }
},

get_refvo2_liters <- function(refvo2_ml, ibw) {
  return((refvo2_ml*ibw)/1000)
},

# get_refwork_max <- function(ibw, vo2_liters, suggested_workrate) {
#   return((ibw*0.7)+((vo2_liters*1000)/10.3)+((suggested_workrate*30)/60))
# },

## Updated Work Max Calculation
get_refwork_max <- function(ibw, vo2_liters) {
  return(((vo2_liters*1000)-(ibw*7))/10.3)
},

get_VO2theta <- function(age, sex, height) {
  if (sex == "Male") {
    return((0.93*height)-(0.0136*age)+0.4121)
  }
  else {
    return((0.64*height)-(0.0053*age)+0.1092)
  }
},

get_lln_vo2 <- function(vo2theta, sex) {
  if (sex == "Male") {
    return(vo2_theta-0.378)
  }
  else {
    return(vo2_theta-0.217)
  }
},

get_ref_fcmax <- function(age) {
  return(208-age*0.7)
},

get_chronotropic_male <- function(age, height, weight) {
  return(107.37+(0.15*age)-(0.31*height*100)-(0.24*weight))
},

get_chronotopic_index <-function(sex, chronotropic_male) {
  if (sex == "Male") {
    return(chronotropic_male)
  }
  else {
    return(chronotropic_male+14.4)
  }
},

get_metabolicefficiency <- function(workrate_data, vo2_data, data_source) {
  
  data_summary <- lm(vo2_data~workrate_data, data = data_source)
  cf <- coef(data_summary)
  slope <- cf[2]
  slope <- as.numeric(slope)
  
  return (slope)
  
},

get_ventilatory_efficiency <- function(age) {
  if (age < 50) {
    return("25-30")
  }
  else {
    return("30-35")
  }
},

get_measured_chronotropic <- function(vo2, hr, data_source) {
  data_summary <- lm(hr~vo2, data = data_source)
  cf <- coef(data_summary)
  slope <- cf[2]
  slope <- as.numeric(slope)
  
  return(slope)
}

)