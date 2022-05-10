# Server.R
library(shiny)
library(shinydashboard)
library(tidyverse)   ## Contains multiple packages that are essential to R. (GGplot2, ForCats, Purrr, Tibble, dplyr, stringr, readr, tidyr)
library(ggpubr)      ## Publication ready R designs
library(car)         ## Regression Grammar
library(ggplot2)     ## Grammar of Graphics
library(readxl)      ## Reads Excel Files
library(zoo)         ## Rolling Averages
library(rmarkdown)
library(remotes)
library(cowplot) # used in lin machine
library(capture)
library(gt)
library(shinyscreenshot) # handles the download for the tabularized report
library(glue)
library(stringr)
library(patchwork)
library(segmented)

# Define server 
shinyServer(function(input, output) {
  #============================#
  # Data Inputs                #
  #============================#
    cleaned_data <- reactive({
      source("cosmed/cosmed_data_cleaning.R", local = TRUE) # Reference data_cleaning.R
      # source("data_cleaning/vyaire_cleaning.R", local = TRUE)
      wbb1
    }) # EndDataReactive
    
    #============================#
    # Main Plot Output Files     #
    #============================#  
    
    # Plot Output (ServerSide)
    output$plot1 <- renderPlot({        
      source("Raw4PanelPlots/raw_plot.R", local = TRUE)
      p1 + p2 + p3 + p4 + plot_layout(tag_level = 'new') +
      plot_annotation(tag_levels = list(c('I', 'II', "IV", "III")))
    }) #Plot1 Output
    
    #============================#
    # Main Table Output          #
    #============================#
    
    output$table1 <- render_gt({
      source("cosmed/cosmed_gt.R", local = TRUE)[1]
      gt_confirmed
    })
    
    output$codebook <- render_gt({
      source("global/axt_codebook.R", local = TRUE)[1]
      gt_axtcodebook
    })
    
    #============================#
    #    Test Case Validity      #
    #============================#
    
    output$failureBox <- renderValueBox({
      source("TestValidity/test_cases.R", local = TRUE)[1]
      valueBox(
        failed, "Quality-Criteria Failed", icon = icon("thumbs-down", lib = "glyphicon"),
        color = "red"
      )
    })
    
    output$approvalBox <- renderValueBox({
      source("TestValidity/test_cases.R", local = TRUE)[1]
      valueBox(
        passed, "Quality-Criteria Passed", icon = icon("thumbs-up", lib = "glyphicon"),
        color = "green"
      )
    })
    
    # output$table2 <- render_gt({
    #   source("cosmed/cosmed_gt.R", local = TRUE[1])
    #   gt_reference
    # })
    
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
    
    output$vco2theta_validity <- renderText({
      source("TestValidity/vco2theta_validity.R", local = TRUE)[1]
      vco2theta_validity
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
    
    output$nhanes <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1]
      round(get_nhanes(age, sex, height), 2)
    })
    
    output$vecap <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1]
      round(get_nhanes(age, sex, height)*40, 0)
    })
    
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
      height*100 # In Centimeters
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
      getBmi(height, weight)
    }) #EndRenderText
    
    output$rbmi <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      getRbmi(height, sex)
    }) #EndRenderText
    
    output$ibw <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      getIbw(height, sex)
    }) #EndRenderText
    
    output$date_of_study <- renderText({
      source("cosmed/cosmed_patient_demographics.R", local = TRUE)[1]
      date_of_study
    }) #EndRenderText
    
})