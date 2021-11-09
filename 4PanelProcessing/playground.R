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

col_names <- array(read_excel("/Users/apurvashah/Downloads/CPET-TEST.xlsx", sheet = 1, n_max = 1, col_names = FALSE))
rawdata <- data.frame(read_excel("/Users/apurvashah/Downloads/CPET-TEST.xlsx", sheet = 1, skip = 3, col_names = FALSE))
colnames(rawdata) <- col_names
convert_data1 <- rawdata
wbb1 <- convert_data1 %>% select(10:37) # The Dataframe that includes all of the key variables required for data manipulation.
wbb1 <- wbb1[!wbb1$Power < 10,]

diamonds <- c()

end_test_machine_brett <- function(data_input) {
  for (i in 1:length(data_input)){
    if (data_input[i] < 50) {
      end_test_position <- i
    } # End If Statement
    else {
      next
    }
  } # End For Loop
  return(end_test_position)
}

distribution_machine_data <- function(range_x, range_y, dataset) {
  
  data_summary <- lm(range_y ~ range_x, data = dataset)
  data_intercept <- summary(data_summary)$coef[[1]]
  data_slope <- summary(data_summary)$coef[[2]]
  
  corrected_data <- ((range_x)*data_slope)+data_intercept
  corrected_data <- as.numeric(corrected_data)
  
  variability <- range_y-corrected_data
  
  return(variability)
}

wbb1$Power <- zoo::rollmean(wbb1$Power, k = 5, fill = NA)
wbb1$VO2 <- zoo::rollmean(wbb1$VO2, k = 5, fill = NA)
wbb1$VCO2 <- zoo::rollmean(wbb1$VCO2, k = 5, fill = NA)
wbb1$VE <- zoo::rollmean(wbb1$VE, k = 5, fill = NA)
wbb1$HR <- zoo::rollmean(wbb1$HR, k = 5, fill = NA)

length_power <- length(wbb1$Power)
length_power <- as.numeric(length_power)

wbb1 <- wbb1[-c(1,2, length_power, length_power-1), ]



wbb1$t <- (wbb1$t)*86400
validity_time_correction <- wbb1$t[1]
wbb1$t <- (wbb1$t)-validity_time_correction
wbb1$t <- as.numeric(wbb1$t)
wbb1$t[1]

time.watts.lm <- lm(wbb1$t ~ wbb1$Power, data = wbb1)
intercept <- summary(time.watts.lm)$coef[[1]]
slope <- summary(time.watts.lm)$coef[[2]]
summary(time.watts.lm)$coef[[1]]

test_end_data <- distribution_machine_data(wbb1$Power, wbb1$VO2, wbb1)
end_test_position <- end_test_machine_brett(wbb1$Revolution)

# wbb1 <- wbb1[-c(end_test_position:length_power), ]

