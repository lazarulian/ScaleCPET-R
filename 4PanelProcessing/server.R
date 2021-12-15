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
library(flexdashboard) ## Creates nice dashboards and allows custom HTML tools
library(rmarkdown)
library(bs4Dash)


# Define server 
shinyServer(function(input, output) {
  #============================#
  # Data Inputs                #
  #============================#
    cleaned_data <- reactive({
      source("Global/data_cleaning.R", local = TRUE) # Reference data_cleaning.R
      wbb1
    }) # EndDataReactive
    
    corrected_data <- reactive({
      source("TestValidity/corrected_data.R", local = TRUE) # Reference data_cleaning.R
      corrected_data
    }) # EndDataReactive
    
    #============================#
    # Main Plot Output Files     #
    #============================#  
    
    # Plot Output (ServerSide)
    output$plot1 <- renderPlot({        
      source("Raw4PanelPlots/raw_plot.R", local = TRUE)
      plot_grid(p1, NULL, p2, p3, NULL, p4, align = 'hv', rel_widths = c(3, -.5, 3), nrow = 2, ncol = 3)
    }) #Plot1 Output
    
    #============================#
    # R^2 Value Distributions    #
    #============================#
    
    ## Watts vs. Time
    
    output$plot2 <- renderPlot({        
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      linearity_machine(cleaned_data()$t, cleaned_data()$Power, cleaned_data())
    }) #Plot1 Output
    
    
    output$workrate_variability_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      distribution_machine(cleaned_data()$t, cleaned_data()$Power, cleaned_data())
    })
    
    
    ## VO2
    output$VO2_variability_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      linearity_machine(cleaned_data()$Power, cleaned_data()$VO2, cleaned_data())
    })
    
    output$VO2_distribution_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      distribution_machine(cleaned_data()$Power, cleaned_data()$VO2, cleaned_data())
    })
    
    ## VCO2
    output$VCO2_variability_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      linearity_machine(cleaned_data()$Power, cleaned_data()$VCO2, cleaned_data())
    })
    
    output$VCO2_distribution_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      distribution_machine(cleaned_data()$Power, cleaned_data()$VCO2, cleaned_data())
    })
    
    ## VO2 vs. VCO2
    output$VO2VCO2_variability_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      linearity_machine(cleaned_data()$VO2, cleaned_data()$VCO2, cleaned_data())
    })
    
    output$VO2VCO2_distribution_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      distribution_machine(cleaned_data()$VO2, cleaned_data()$VCO2, cleaned_data())
    })
    
    ## VCO2 vs. VE
    output$VCO2VE_variability_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      linearity_machine(cleaned_data()$VCO2, cleaned_data()$VE, cleaned_data())
    })
    
    output$VCO2VE_distribution_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      distribution_machine(cleaned_data()$VCO2, cleaned_data()$VE, cleaned_data())
    })
    
    ## VO2 vs. HR
    output$VO2HR_variability_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      linearity_machine(cleaned_data()$VO2, cleaned_data()$HR, cleaned_data())
    })
    
    output$VO2HR_distribution_graph <- renderPlot({
      source("TestValidity/linearity_machine.R", local = TRUE)[1]
      distribution_machine(cleaned_data()$VO2, cleaned_data()$HR, cleaned_data())
    })
    
    #============================#
    # Text Outputs for Max Values#
    #============================#
    
    ## MaxVO2 Text Output
    
    #  output$output1 <- renderText({
    #    source("Global/max_test.R", local = TRUE)[1]
    #    max_test2(cleaned_data()$VO2)
    #  }) #EndRenderText
    # 
    #  ## Max Heart Rate Text Output
    #  output$output2 <- renderText({
    #    source("Global/max_test.R", local = TRUE)[1]
    #    max_test2(cleaned_data()$HR)
    #  }) #EndRenderText
    # 
    # ## Max Watts Text Output
    #  output$output3 <- renderText({
    #      source("Global/max_test.R", local = TRUE)[1]
    #      max_test2(cleaned_data()$Power)
    # }) #EndRenderText
    
  ## Max Values Based off of End Test Calculations

    output$output1 <- renderText({
      source("DataCalculation/endtest_data_max.R", local = TRUE)[1]
      end_VO2
    }) #EndRenderText

    ## Max Heart Rate Text Output
    output$output2 <- renderText({
      source("DataCalculation/endtest_data_max.R", local = TRUE)[1]
      end_HR
    }) #EndRenderText

    ## Max Watts Text Output
    output$output3 <- renderText({
      source("DataCalculation/endtest_data_max.R", local = TRUE)[1]
      end_power
    }) #EndRenderText

    
    #============================================#
    # Linear Regression Modeling / Test Validity #
    #============================================#
    
    output$output4 <- renderText({
      source("TestValidity/workcontroller_validity.R", local = TRUE)[1]
      rawtimewatts_intercept
    }) #EndRenderText
    
    output$output5 <- renderText({
      # Summary Slope
      source("TestValidity/workcontroller_validity.R", local = TRUE)[1]
      rawtimewatts_slope
      
    }) #EndRenderText
    
    output$effective_ramp <- renderText({
      # Summary Slope
      source("TestValidity/workcontroller_validity.R", local = TRUE)[1]
      effective_ramp
      
    }) #EndRenderText
    
    output$output6 <- renderText({
      source("TestValidity/workcontroller_validity.R", local = TRUE)[1]
      rawtimewatts_rsquared
    }) #EndRenderText
    
    output$raw_testcontroller_validity <- renderText({
      source("TestValidity/workcontroller_validity.R", local = TRUE)[1]
      raw_controller_validity
    }) #EndRenderText
    
    output$workrate_variability_validity <- renderText({
      source("TestValidity/workcontroller_validity.R", local = TRUE)[1]
      workrate_variability_validity
    }) #EndRenderText
    
    output$ramp_duration_validity <- renderText({
      source("TestValidity/ramp_duration_validity.R", local = TRUE)[1]
      ramp_duration_validity
    }) #EndRenderText
    
    output$metabolic_efficiency_validity <- renderText({
      source("TestValidity/metabolic_efficiency_validity.R", local = TRUE)[1]
      metabolic_efficiency_validity
    }) #EndRenderText
    
    output$erroneous_hr_validity <- renderText({
      source("TestValidity/erroneous_hr.R", local = TRUE)[1]
      erroneous_hr_validity
    }) #EndRenderText
    
    #======================#
    # Patient Demographics
    #======================#
    
    output$last_name <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      last_name
    }) #EndRenderText
    
    output$first_name <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      first_name
    }) #EndRenderText
    
    output$sex <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      sex
    }) #EndRenderText
    
    output$age <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      age
    }) #EndRenderText
    
    output$height <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      height
    }) #EndRenderText
    
    output$weight <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      weight
    }) #EndRenderText
    
    output$id <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      id
    }) #EndRenderText
    
    output$bmi <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      bmi
    }) #EndRenderText
    
    output$rbmi <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      rbmi
    }) #EndRenderText
    
    output$ibw <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      ibw
    }) #EndRenderText
    
})