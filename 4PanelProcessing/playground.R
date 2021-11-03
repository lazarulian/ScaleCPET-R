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

col_names <- array(read_excel("/Users/apurvashah/OneDrive/Extracurriculars/UC-FitLab/PlotsProject/VO2 Max Testing Data/Watts/Trent-Yamamoto 9-16-21.xlsx", sheet = 1, n_max = 1, col_names = FALSE))
rawdata <- data.frame(read_excel("/Users/apurvashah/OneDrive/Extracurriculars/UC-FitLab/PlotsProject/VO2 Max Testing Data/Watts/Trent-Yamamoto 9-16-21.xlsx", sheet = 1, skip = 3, col_names = FALSE))
colnames(rawdata) <- col_names
convert_data1 <- rawdata
wbb1 <- convert_data1 %>% select(10:36) # The Dataframe that includes all of the key variables required for data manipulation.
wbb1 <- wbb1[!wbb1$Power < 10,]

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

