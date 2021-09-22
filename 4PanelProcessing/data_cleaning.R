list(
  req(input$file1), # Requests Data from Input
  
  # Reads Excel File Input / Cleans Raw Data
  col_names <- array(read_excel(input$file1$datapath, sheet = 1, n_max = 1, col_names = FALSE)),
  rawdata <- data.frame(read_excel(input$file1$datapath, sheet = 1, skip = 3, col_names = FALSE)),
  colnames(rawdata) <- col_names,
  convert_data1 <- rawdata,
  wbb1 <- convert_data1 %>% select(11:36), # The Dataframe that includes all of the key variables required for data manipulation.
  
  # Graph Processing with Cleaned Data
  
  wbb1$VO2 <- (wbb1$VO2)/1000,  #CONVERT TO LITERS
  wbb1$VO2 <- as.numeric(wbb1$VO2), 
  wbb1$VCO2 <- (wbb1$VCO2)/1000,  #CONVERT TO LITERS
  wbb1$VCO2 <- as.numeric(wbb1$VCO2)
)