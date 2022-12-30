# demographics_data which is not changed from machine to machine
list(
  
  ## BMI Calculation
  getBmi <- function(height, weight) {
    # Returns the BMI with weight in KG
    # takes height in cm and converts it to meters
    bmi <- weight/(height)^2
    bmi <- round(bmi, 1)
    return (bmi)
  },
  
  
  ## Ideal Body Weight Calculation
  getIbw <- function(height, sex) {
    # returns the ideal body weight based on sex and height
    # takes height in cm and converts it to meters
    if (sex == "Male" | sex == "male" | sex == "M") {
      ibw <- 71.6*(height)-51.8
      ibw <- round(ibw, 1)
      return(ibw)
    }
    else {
      ibw <- 62.6*(height)-45.5
      ibw <- round(ibw, 1)
      return(ibw)
    }
  },
  
  
  ## Reference BMI Calculation
  getRbmi <- function(height, sex) {
    # Returns the reference BMI given ideal body weight and height
    # takes height in cm and converts it to meters
    rbmi <- getIbw(height, sex)/(height)^2
    rbmi <- round(rbmi, 1)
    return(rbmi)
  },
  
  get_nhanes <- function (age, sex, height) {
    ## Returns the reference nhanes III value from the age, sex, and height
    ## Defaults as caucasian 
    
    if (age >= 17 && sex == "female" | sex == "Female" | sex == "F" | sex == "f") {
      nhanes <- 0.43333-0.00361*age-0.000194*age^2+1.1496*(height)^2
    }
    
    else if (sex == "Female" | sex == "female") {
      nhanes <- -0.871+0.06537*age+1.1496*(height)^2
    }
    
    else if (sex == "Male" | sex == "male" | sex == "m" && age >= 20) {
      nhanes <- 0.5536-0.01303*age-0.000172*age^2+1.4098*(height)^2
    }
    
    else {
      nhanes <- -0.7453-0.04106*age+0.004477*(age)^2+1.4098*(height)^2
    }
    
    return(nhanes)
  },
  
  source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1]
  
)