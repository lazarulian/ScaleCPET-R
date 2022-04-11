# Cosmed File Intake

# list(

library(haven)       ## Allows for reading other file formats.
library(tidyverse)   ## Contains multiple packages that are essential to R. (GGplot2, ForCats, Purrr, Tibble, dplyr, stringr, readr, tidyr)
library(ggpubr)      ## Publication ready R designs
library(rstatix)     ## Conducts basic statistical testing 
library(arsenal)     ## Large scale statistical summaries.
library(car)         ## Regression Grammar
library(ggplot2)     ## Grammar of Graphics
library(readxl)      ## Reads Excel Files
library(cowplot)     ## Aligns Plot
library(zoo)         ## Rolling Averages
library(shiny)       ## Shiny
library(broom)       ## Linear Regression?
library(lubridate)   ## Tidyr
library(glue)
library(gt)
library(stringr)
library(plotly)
library(patchwork)
library(segmented) ## Segmented Regression Package
  
  # req(input$file1), # Requests Data from Input
  # 
  # # Reads Excel File Input / Cleans Raw Data
  # col_names <- array(read_excel(input$file1$datapath, sheet = 1, n_max = 1, col_names = FALSE)),
  # rawdata <- data.frame(read_excel(input$file1$datapath, sheet = 1, skip = 3, col_names = FALSE)),
  
### File Intake ###

  col_names <- array(read_excel("/Users/apurvashah/Downloads/CosmedTests/UCLA-FL-001.xlsx",
                                sheet = 1, n_max = 1, col_names = FALSE))
  rawdata <- data.frame(read_excel("/Users/apurvashah/Downloads/CosmedTests/UCLA-FL-001.xlsx",
                                   sheet = 1, skip = 3, col_names = FALSE))

  
  ### Select Data / Rename ###
  colnames(rawdata) <- col_names
  convert_data1 <- rawdata
  
  wbb1 <- convert_data1 %>% dplyr::select(10:37) # The Dataframe that includes all of the key variables required for data manipulation.
  
  
  ### Creating our Universal Template Dataframe ###
  
  
  
  wbb1$VO2 <- (wbb1$VO2)
  if (wbb1$VO2[1] > 20) {
    wbb1$VO2 <- wbb1$VO2/1000
  }
  # /1000,  #CONVERT TO LITERS
  wbb1$VO2 <- as.numeric(wbb1$VO2)
  wbb1$VCO2 <- (wbb1$VCO2)/1000 #CONVERT TO LITERS
  wbb1$VCO2 <- as.numeric(wbb1$VCO2)
  wbb1$t <- (wbb1$t)*86400 # Converts from time format to seconds
  wbb1<- wbb1[!wbb1$Power < 10,] # Removes Warmup Data
  
  #========================#
  # Converting to Rollmean #
  #========================#
  # Uses the library zoo to calculate roll means for all of the key variables
  
  wbb1$Power <- zoo::rollmean(wbb1$Power, k = 5, fill = NA)
  wbb1$VO2 <- zoo::rollmean(wbb1$VO2, k = 5, fill = NA)
  wbb1$VCO2 <- zoo::rollmean(wbb1$VCO2, k = 5, fill = NA)
  wbb1$VE <- zoo::rollmean(wbb1$VE, k = 5, fill = NA)
  wbb1$HR <- zoo::rollmean(wbb1$HR, k = 5, fill = NA)
  wbb1$RQ <- zoo::rollmean(wbb1$RQ, k = 5, fill = NA)
  
  ## Calculating the Length for Row Elimination
  length_power <- length(wbb1$Power)
  length_power <- as.numeric(length_power)
  wbb1 <- wbb1[-c(1,2, length_power, length_power-1), ]
  length_power <- length(wbb1$Power)
  
  ## Calculating for More NA Values
  for (i in 1:length(wbb1$Power)) {
    if (is.na(wbb1$Power[i]) == T) {
      wbb1 <- wbb1[-c(i), ]
    }
    else {
      next
    }
  }
  
  
  ## Fixing Time
  time_analysis <- lm(wbb1$Power ~ wbb1$t, data = wbb1)
  watts_t_intercept <- summary(time_analysis)$coef[[1]]
  watts_t_slope <- summary(time_analysis)$coef[[2]]
  
  # Dr. Cooper's Actual Time of Commencement
  corrected_time_differential <- (0-watts_t_intercept)/watts_t_slope
  wbb1$t <- (wbb1$t)-corrected_time_differential
  wbb1$t <- as.numeric(wbb1$t)
  
  
  #=======================#
  # End Test Data Removal #
  #=======================#
  # Using Dr. Coopers Method: Basically it will take 5 consecutive values of
  # -.05 in distribution analysis and end the test at the first position of it.
  source("cosmed/endtest_cosmed.R", local = TRUE)[1]
  end_test_position <- endtest_cosmed(wbb1$VO2)
  wbb1 <- wbb1[-c(end_test_position:length(wbb1$VO2)), ]
  
  
  # ), #end test