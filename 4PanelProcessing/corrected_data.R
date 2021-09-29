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
  
  time.watts.lm <- lm(corrected_data$t ~ corrected_data$Power, data = corrected_data),
  watts_t_intercept <- summary(time.watts.lm)$coef[[1]],
  watts_t_slope <- summary(time.watts.lm)$coef[[2]],
  
  corrected_time_differential <- (0-watts_t_intercept)/watts_t_slope,
  
  #corrected_data$t <- (corrected_data$t)-corrected_time_differential,
  #corrected_data$t <- as.numeric(corrected_data$t),
  corrected_data$Power <- ((corrected_data$t)*watts_t_slope)+watts_t_intercept,
  corrected_data$Power <- as.numeric(corrected_data$Power)
  
)