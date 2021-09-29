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
library(lubridate)

col_names <- array(read_excel("/Users/apurvashah/Downloads/David-Gomez.xlsx", sheet = 1, n_max = 1, col_names = FALSE))
rawdata <- data.frame(read_excel("/Users/apurvashah/Downloads/David-Gomez.xlsx", sheet = 1, skip = 3, col_names = FALSE))
colnames(rawdata) <- col_names
convert_data1 <- rawdata
wbb1 <- convert_data1 %>% select(10:36) # The Dataframe that includes all of the key variables required for data manipulation.

name <- read_excel("/Users/apurvashah/Downloads/David-Gomez.xlsx", range = "B2", col_names = FALSE)
name <- toString(name)

time.watts.lm <- lm(wbb1$t ~ wbb1$Power, data = wbb1)
intercept <- summary(time.watts.lm)$coef[[1]]
slope <- summary(time.watts.lm)$coef[[2]]

corrected_time_differential <- (0-intercept)/slope

warmup_index <- c()
for(i in 1:length(wbb1$Power)) {
  warmup_index <- c(warmup_index, i)
}

