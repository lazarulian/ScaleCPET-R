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
library(segmented) ## Segmented Regression Package

end_test_machine_coop <- function(vo2data) {
  vo2max <- max(vo2data)
  for (i in 1:length(vo2data)) {
    if (vo2data[i] == vo2max) {
      position_vo2max = i
    }
  }
  vo2data <- vo2data[-c(1:position_vo2max), ]
  
  for (i in 1:length(vo2data)) {
    if (vo2data[i] <= vo2max - .05) {
      new_pos == i
    }
  }}

col_names <- array(read_excel("/Users/apurvashah/Downloads/Ricardo.xlsx",
                              sheet = 1, n_max = 1, col_names = FALSE))
rawdata <- data.frame(read_excel("/Users/apurvashah/Downloads/Ricardo.xlsx",
                                 sheet = 1, skip = 3, col_names = FALSE))

colnames(rawdata) <- col_names
convert_data1 <- rawdata
wbb1 <- convert_data1 %>% dplyr::select(10:37) # The Dataframe that includes all of the key variables required for data manipulation.

wbb1$VO2 <- (wbb1$VO2)
# /1000,  #CONVERT TO LITERS
wbb1$VO2 <- as.numeric(wbb1$VO2)
wbb1$VCO2 <- (wbb1$VCO2)/1000  #CONVERT TO LITERS
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

## Calculating the Length for Row Elimination
length_power <- length(wbb1$Power)
length_power <- as.numeric(length_power)
wbb1 <- wbb1[-c(1,2, length_power, length_power-1), ]
length_power <- length(wbb1$Power)


## Fixing Time
time_analysis <- lm(wbb1$Power ~ wbb1$t, data = wbb1)
watts_t_intercept <- summary(time_analysis)$coef[[1]]
watts_t_slope <- summary(time_analysis)$coef[[2]]

# Dr. Cooper's Actual Time of Commencement
corrected_time_differential <- (0-watts_t_intercept)/watts_t_slope
wbb1$t <- (wbb1$t)-corrected_time_differential
wbb1$t <- as.numeric(wbb1$t)

VE_data <- wbb1$VE
VCO2_data <- wbb1$VCO2

panel_3 <- lm(VE_data~VCO2_data, data = wbb1)
seg<- segmented(panel_3, seg.Z=~VCO2_data)
vco2_theta <- seg$psi
vco2_theta[2]
slopes <- slope(seg)
my.fitted <- fitted(seg)
my.model <- data.frame(VCO2 = wbb1$VCO2, VE = my.fitted)


p3<-ggplot(wbb1, aes(x=VCO2, y=VE)) + 
  geom_point(color = "#239B56", size = 1) + #GREEN COLOR
  #geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
  scale_x_continuous(name = expression('VCO'[2]*' (L/min)'),
                     breaks = seq(0, 6, by=2),
                     limits=c(0, 6)) +
  scale_y_continuous(name = "vE (L/min)", 
                     breaks = seq(0, 200, 40),
                     limits=c(0, 220)) +
  # breaks = seq(VE_range_start, VE_range_end, VE_minor_tick),
  # limits=c(VE_range_start, VE_range_end)) +
  theme_classic() +
  theme(aspect.ratio=1) 


p4 <- p3 + geom_line(data = my.model, color = "red")

p4


