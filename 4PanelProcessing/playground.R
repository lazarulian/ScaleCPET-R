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
library(patchwork)
library(segmented) ## Segmented Regression Package

distribution_machine_data <- function(range_x, range_y, dataset) {
  
  data_summary <- lm(range_y ~ range_x, data = dataset)
  data_intercept <- summary(data_summary)$coef[[1]]
  data_slope <- summary(data_summary)$coef[[2]]
  
  corrected_data <- ((range_x)*data_slope)+data_intercept
  corrected_data <- as.numeric(corrected_data)
  
  variability <- corrected_data-range_y
  
  return(variability)
}

endtest_cosmed <- function(vo2data) {
  ## Finds the position of the end of the cosmed test
  vo2max <- max(vo2data)
  for (i in 1:length(vo2data)) {
    if (vo2data[i] == vo2max) {
      position_vo2max <- i
    }
  }
  return(position_vo2max+2)
}

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
wbb1$RQ <- zoo::rollmean(wbb1$RQ, k = 5, fill = NA)


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

end_test_position <- endtest_cosmed(wbb1$VO2)
wbb1 <- wbb1[-c(end_test_position:length(wbb1$VO2)), ]



p2 <- ggplot(wbb1, aes(x=VO2, y=VCO2)) +
  geom_point(color = "#3498DB", size = 1) + #BLUE COLOR + #RED COLOR
  # stat_poly_eq(formula = my.formula,
  #            aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
  #            parse = TRUE) +
  scale_x_continuous(name = expression('VO2')) +
  scale_y_continuous(name = expression('VCO2')) +
  theme_classic() +
  theme(aspect.ratio=1)

p3 <- ggplot(wbb1, aes(x=VO2, y=VCO2)) +
  geom_point(color = "#3498DB", size = 1) + #BLUE COLOR + #RED COLOR
  # stat_poly_eq(formula = my.formula,
  #            aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
  #            parse = TRUE) +
  scale_x_continuous(name = expression('VO2')) +
  scale_y_continuous(name = expression('VCO2')) +
  theme_classic() +
  theme(aspect.ratio=1)

p4 <- ggplot(wbb1, aes(x=VO2, y=VCO2)) +
  geom_point(color = "#3498DB", size = 1) + #BLUE COLOR + #RED COLOR
  # stat_poly_eq(formula = my.formula,
  #            aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
  #            parse = TRUE) +
  scale_x_continuous(name = expression('VO2')) +
  scale_y_continuous(name = expression('VCO2')) +
  theme_classic() +
  theme(aspect.ratio=1)

p1 <- ggplot(wbb1, aes(x=VO2, y=VCO2)) +
  geom_point(color = "#3498DB", size = 1) + #BLUE COLOR + #RED COLOR
  # stat_poly_eq(formula = my.formula,
  #            aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")),
  #            parse = TRUE) +
  scale_x_continuous(name = expression('VO2')) +
  scale_y_continuous(name = expression('VCO2')) +
  theme_classic() +
  theme(aspect.ratio=1)


find_value_series <- function(data_range, data_value) {
  for (i in 1:length(data_range)) {
    if (data_range[i] == data_value) {
      the_index <- i
    }
  }
} ## End Function

find_value_positive <- function(data_range) {
  counter <- 0
  for (i in 1:length(data_range)) {
    if (data_range[i] > 0) {
      counter <- counter + 1
      if (counter > 5) {
        the_index <- i
        break
      }
    }
    else {
      counter <- 0
    }
  }
  return(the_index)
} ## End Function

## Segmented Regression Graph 4
VE_data <- wbb1$VE
VCO2_data <- wbb1$VCO2

panel_3 <- lm(VE_data~VCO2_data, data = wbb1)
seg<- segmented(panel_3, seg.Z=~VCO2_data)
vco2_theta <- seg$psi
# vco2_theta
vco2_theta <- vco2_theta[2]
slopes_vco2ve <- slope(seg)
lowersegment_venteff <- round(slopes_vco2ve$VCO2_data[1], 0)
fitted_vco2ve <- fitted(seg)
vco2ve_segmented <- data.frame(VCO2 = VCO2_data, VE = fitted_vco2ve)

## Segmented Regression Panel 2
wbb1<- wbb1[!wbb1$VCO2 > vco2_theta,] # Removes Warmup Data

## Removing the Lower End of the Data
dist_data_values <- distribution_machine_data(wbb1$t, wbb1$RQ, wbb1)
index_removal <- find_value_positive(dist_data_values)
vco2_2 <- wbb1$VCO2
vo2_2 <- wbb1$VO2

vo2_2 <- vo2_2[-c(1:index_removal)]
vco2_2 <- vco2_2[-c(1:index_removal)]
dummy_df <- data.frame(vo2 = vo2_2, vco2 = vco2_2)
# plot(wbb1$VO2, wbb1$VCO2)

panel_2 <- lm(formula = vco2~vo2, data = dummy_df)

my.seg <- segmented(panel_2, seg.Z = ~ vo2_2)
# my.seg$psi
vo2theta <- round(my.seg$psi[2], 2)
vo2_slopes <- slope(my.seg)
lowersegment_meteff <- round(slopes_vco2ve$VCO2_data[1], 0)
fitted_vo2 <- fitted(my.seg)
vo2_segmented <- data.frame(VO2 = vo2_2, VCO2 = fitted_vo2)


# plot(vo2_segmented)
captain <- paste("VO2 Theta = ", vo2theta)
p2 <- p2 + geom_line(data = vo2_segmented, color = "red", size=1) + labs(caption=captain)

p1 + p2 + p3 + p4

