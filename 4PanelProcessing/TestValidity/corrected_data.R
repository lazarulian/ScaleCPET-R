# Corrected_Data.R

list(
  req(input$file1), # Requests Data from Input
  
  # Reads Excel File Input / Cleans Raw Data
  col_names <- array(read_excel(input$file1$datapath, sheet = 1, n_max = 1, col_names = FALSE)),
  rawdata <- data.frame(read_excel(input$file1$datapath, sheet = 1, skip = 3, col_names = FALSE)),
  colnames(rawdata) <- col_names,
  convert_data1 <- rawdata,
  corrected_data <- convert_data1 %>% select(10:36), # The Dataframe that includes all of the key variables required for data manipulation.
  corrected_data <- corrected_data[!corrected_data$Power < 10,], # Removes Warmup Data
  
  corrected_data$VO2 <- (corrected_data$VO2)/1000,  #CONVERT TO LITERS
  corrected_data$VO2 <- as.numeric(corrected_data$VO2), 
  corrected_data$VCO2 <- (corrected_data$VCO2)/1000,  #CONVERT TO LITERS
  corrected_data$VCO2 <- as.numeric(corrected_data$VCO2),
  corrected_data$t <- (corrected_data$t)*86400,
  
  
  ## Eliminating NA Values for Time
  wbb1$Power <- zoo::rollmean(wbb1$Power, k = 5, fill = NA),
  wbb1$VO2 <- zoo::rollmean(wbb1$VO2, k = 5, fill = NA),
  wbb1$VCO2 <- zoo::rollmean(wbb1$VCO2, k = 5, fill = NA),
  wbb1$VE <- zoo::rollmean(wbb1$VE, k = 5, fill = NA),
  wbb1$HR <- zoo::rollmean(wbb1$HR, k = 5, fill = NA),
  
  ## Calculating the Length for Row Elimination
  length_power <- length(wbb1$Power),
  length_power <- as.numeric(length_power),
  wbb1 <- wbb1[-c(1,2, length_power, length_power-1), ],
  
  
  
  ## Restructuring Time to Start at T=0
  # Subtracting all time values by the first data value in the set
  
  # validity_time_correction <- corrected_data$t[1],
  # corrected_data$t <- (corrected_data$t)-validity_time_correction,
  # corrected_data$t <- as.numeric(corrected_data$t),
  
  # Determining Slope/Intercept of the Linearly Regressed Data
  
  time.watts.lm <- lm(corrected_data$Power ~ corrected_data$t, data = corrected_data),
  watts_t_intercept <- summary(time.watts.lm)$coef[[1]],
  watts_t_slope <- summary(time.watts.lm)$coef[[2]],
  
  # Dr. Cooper's Actual Time of Commencement
  
  corrected_time_differential <- (0-watts_t_intercept)/watts_t_slope,
  
  corrected_data$t <- (corrected_data$t)-corrected_time_differential,
  corrected_data$t <- as.numeric(corrected_data$t),
  
  # Making Watts Linear
  
  corrected_data$Power <- ((corrected_data$t)*watts_t_slope)+watts_t_intercept,
  corrected_data$Power <- as.numeric(corrected_data$Power)
  
)