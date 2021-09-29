# Server.R
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

# Define server 
shinyServer(function(input, output) {
    # Data Input (Uploaded File)
    cleaned_data <- reactive({
      source("data_cleaning.R", local = TRUE) # Reference data_cleaning.R
      wbb1
    }) # EndDataReactive
    
    corrected_data <- reactive({
      source("corrected_data.R", local = TRUE) # Reference data_cleaning.R
      corrected_data
    }) # EndDataReactive
    
    # Plot Output (ServerSide)
    output$plot1 <- renderPlot({        
      source("raw_plot.R", local = TRUE)
      plot_grid(plot.a, NULL, plot.b, rel_widths = c(2, -1.2, 2), align = "h", axis = "b", nrow = 2, ncol = 3) # Combines Plots
    }) #Plot1 Output
    
    # Plot Output (ServerSide)
    output$plot2 <- renderPlot({        
      source("corrected_work_time.R", local = TRUE)
      plot_test_validity
    }) #Plot1 Output
    
    ## MaxVO2 Text Output
    output$output1 <- renderText({
      source("max_test.R", local = TRUE)[1]
      max_test2(cleaned_data()$VO2)
    }) #EndRenderText
    
    ## Max Heart Rate Text Output
    output$output2 <- renderText({ 
      source("max_test.R", local = TRUE)[1]
      max_test2(cleaned_data()$HR)
    }) #EndRenderText

    ## Max Watts Text Output
    output$output3 <- renderText({
        source("max_test.R", local = TRUE)[1]
        max_test2(cleaned_data()$Power)
    }) #EndRenderText

    ## Linear Regression Modeling
    
    output$output4 <- renderText({
      source("workcontroller_validity.R", local = TRUE)[1]
      rawtimewatts_intercept
    }) #EndRenderText
    
    output$output5 <- renderText({
      # Summary Slope
      source("workcontroller_validity.R", local = TRUE)[1]
      rawtimewatts_slope
      
    }) #EndRenderText
    
    output$output6 <- renderText({
      source("workcontroller_validity.R", local = TRUE)[1]
      rawtimewatts_rsquared
    }) #EndRenderText
    
    output$raw_testcontroller_validity <- renderText({
      source("workcontroller_validity.R", local = TRUE)[1]
      raw_controller_validity
    }) #EndRenderText
    
    # Patient Demographics
    output$last_name <- renderText({
      source("demographics_data.R", local = TRUE)[1]
      last_name
    }) #EndRenderText
    
    output$first_name <- renderText({
      source("demographics_data.R", local = TRUE)[1]
      first_name
    }) #EndRenderText
    
    output$sex <- renderText({
      source("demographics_data.R", local = TRUE)[1]
      sex
    }) #EndRenderText
    
    output$age <- renderText({
      source("demographics_data.R", local = TRUE)[1]
      age
    }) #EndRenderText
    
    output$height <- renderText({
      source("demographics_data.R", local = TRUE)[1]
      height
    }) #EndRenderText
    
    output$weight <- renderText({
      source("demographics_data.R", local = TRUE)[1]
      weight
    }) #EndRenderText
    
})