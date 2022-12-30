# Vyaire.R
list (
  req(input$file1), # Requests Data from Input
  
  last_name <- read_excel(input$file1$datapath, range = "B1", col_names = FALSE),
  last_name <- toString(last_name),
  
  first_name <- read_excel(input$file1$datapath, range = "D1", col_names = FALSE),
  first_name <- toString(first_name),
  
  sex <- read_excel(input$file1$datapath, range = "B2", col_names = FALSE),
  sex <- toString(sex),
  
  age <- read_excel(input$file1$datapath, range = "B4", col_names = FALSE),
  age <- gsub("[^0-9.]", "", age),
  age <- as.numeric(age),
  
  height <- read_excel(input$file1$datapath, range = "B3", col_names = FALSE),
  height <- gsub("[^0-9.]", "", height),
  height <- as.numeric(height),
  height <- as.numeric(height/100),
  
  weight <- read_excel(input$file1$datapath, range = "D3", col_names = FALSE),
  weight <- gsub("[^0-9.]", "", weight),
  weight <- as.numeric(weight),
  weight <- as.numeric(round(weight, 1)),
  
  id <- "N/A",
  
  date_of_study <- "N/A",
  
  
  col_names <- array(read_excel(input$file1$datapath, sheet = 1, skip = 21, n_max = 1, col_names = FALSE)),
  rawdata <- data.frame(read_excel(input$file1$datapath, sheet = 1, skip = 24, col_names = FALSE)),
  colnames(rawdata) <- col_names,
  convert_data1 <- rawdata,
  wbb1 <- convert_data1 %>% dplyr::select(1:10), # The Dataframe that includes all of the key variables required for data manipulation.
  
  ## Rename the ColNames
  colnames(wbb1) <- c('t',"Power","HR", "VE", "VTEX", "BRFEV", "VO2", "VCO2", "RQ", "VO2kg"),
  
  
  ## Clean Data for Blank Spaces / negative numbers
  wbb1 <- wbb1[rowSums(is.na(wbb1)) == 0,],
  wbb1 <- wbb1[!wbb1$VO2 < 0,],
  
  
  ## Convert Data to Standard
  # Restructuring as Numeric
  wbb1$t <- as.numeric(substr(wbb1$t, 1, 2))*60 + as.numeric(substr(wbb1$t, 4, 5)), #removes character notation
  wbb1$Power <- as.numeric(wbb1$Power),
  wbb1$VE <- as.numeric(wbb1$VE),
  wbb1$VTEX <- as.numeric(wbb1$VTEX),
  wbb1$BRFEV <- as.numeric(wbb1$BRFEV),
  wbb1$VO2 <- as.numeric(wbb1$VO2),
  wbb1$VCO2 <- as.numeric(wbb1$VCO2),
  wbb1$RQ <- as.numeric(wbb1$RQ),
  wbb1$VO2kg <- as.numeric(wbb1$VO2kg),
  wbb1$HR <- as.numeric(wbb1$HR),
  
  # VO2 / VCO2 to Liters
  if (wbb1$VO2[1] > 20) {
    wbb1$VO2 <- wbb1$VO2/1000
  },
  if (wbb1$VCO2[1] > 20) {
    wbb1$VCO2 <- wbb1$VCO2/1000
  },
  
  
  # Removing the Warmup
  wbb1<- wbb1[!wbb1$Power < 10,], # Removes Warmup Data
  
  ## Smooth the Data using 5-Breath Rolling Average
  
  wbb1$Power <- zoo::rollmean(wbb1$Power, k = 5, fill = NA),
  wbb1$VO2 <- zoo::rollmean(wbb1$VO2, k = 5, fill = NA),
  wbb1$VCO2 <- zoo::rollmean(wbb1$VCO2, k = 5, fill = NA),
  wbb1$VE <- zoo::rollmean(wbb1$VE, k = 5, fill = NA),
  wbb1$HR <- zoo::rollmean(wbb1$HR, k = 5, fill = NA),
  wbb1$RQ <- zoo::rollmean(wbb1$RQ, k = 5, fill = NA),
  
  
  wbb1 <- wbb1[rowSums(is.na(wbb1)) == 0,], # Remove na after rollmean
  
  source("TestValidity/linearity_machine.R", local = TRUE[1]),
  # linearity_machine(wbb1$t, wbb1$Power, wbb1)
  value <- distribution_machine_data(wbb1$t, wbb1$Power, wbb1),

  max_deviation <- which.max(value), # calculates the 3 points after the falling distribution
  if (max_deviation+3 < length(value))
  {
    new_val <- max_deviation+3
    wbb1 <- wbb1[-c(new_val:length(wbb1$VO2)), ]
  },

  
  ## Fixing Time
  time_analysis <- lm(wbb1$Power ~ wbb1$t, data = wbb1),
  watts_t_intercept <- summary(time_analysis)$coef[[1]],
  watts_t_slope <- summary(time_analysis)$coef[[2]],
  
  # Dr. Cooper's Actual Time of Commencement
  corrected_time_differential <- (0-watts_t_intercept)/watts_t_slope,
  wbb1$t <- (wbb1$t)-corrected_time_differential,
  wbb1$t <- as.numeric(wbb1$t),
  
  id <- "N/A",
  
  wbb1$last_name <- last_name,
  wbb1$first_name <- first_name,
  wbb1$sex <- sex,
  wbb1$age <- age,
  wbb1$height <- height,
  wbb1$weight <- weight,
  wbb1$id <- id,
  wbb1$date_of_study <- date_of_study,
  wbb1$end_test <- wbb1$t[max_deviation],
  
  wbb1
)

