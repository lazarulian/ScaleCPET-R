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
  
  source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1]
  
)