list(
  req(input$file1), # Requests Data from Input
  
  # Reads Excel File Input / Cleans Raw Data
  col_names <- array(read_excel(input$file1$datapath, sheet = 1, n_max = 1, col_names = FALSE)),
  rawdata <- data.frame(read_excel(input$file1$datapath, sheet = 1, skip = 3, col_names = FALSE)),
  colnames(rawdata) <- col_names,
  convert_data1 <- rawdata,
  wbb1 <- convert_data1 %>% select(10:36), # The Dataframe that includes all of the key variables required for data manipulation.

  wbb1$VO2 <- (wbb1$VO2)/1000,  #CONVERT TO LITERS
  wbb1$VO2 <- as.numeric(wbb1$VO2), 
  wbb1$VCO2 <- (wbb1$VCO2)/1000,  #CONVERT TO LITERS
  wbb1$VCO2 <- as.numeric(wbb1$VCO2),
  wbb1$t <- (wbb1$t)*86400, # Converts from time format to seconds
  wbb1<- wbb1[!wbb1$Power < 10,], # Removes Warmup Data
  
  ## Convert all to Data Values
  wbb1$Power <- zoo::rollmean(wbb1$Power, k = 5, fill = NA),
  wbb1$VO2 <- zoo::rollmean(wbb1$VO2, k = 5, fill = NA),
  wbb1$VCO2 <- zoo::rollmean(wbb1$VCO2, k = 5, fill = NA),
  wbb1$VE <- zoo::rollmean(wbb1$VE, k = 5, fill = NA),
  wbb1$HR <- zoo::rollmean(wbb1$HR, k = 5, fill = NA),

  ## Calculating the Length for Row Elimination
  length_power <- length(wbb1$Power),
  length_power <- as.numeric(length_power),
  wbb1 <- wbb1[-c(1,2, length_power, length_power-1), ],
  
  # Corrects Time back to 0 after ramp removal
  time_correction <- wbb1$t[1],
  wbb1$t <- (wbb1$t)-time_correction,
  wbb1$t <- as.numeric(wbb1$t)

  
)