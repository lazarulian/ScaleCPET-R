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
# library(capture)
library(gt)
# library(shinyscreenshot) # handles the download for the tabularized report
library(glue)
library(stringr)
library(patchwork)
library(segmented)
library(DT)
library(shinyjs)
library(sodium)
source("authentication.R", local = TRUE)[1]
# Define server 
shinyServer(function(input, output) {
  login = FALSE
  USER <- reactiveValues(login = login)
  
  observe({ 
    credentials = data.frame(
      username_id = c("myuser", "myuser1"),
      passod   = sapply(c("mypass", "mypass1"),password_store),
      permission  = c("basic", "advanced"), 
      stringsAsFactors = F
    )
    if (USER$login == FALSE) {
      if (!is.null(input$login)) {
        if (input$login > 0) {
          Username <- isolate(input$userName)
          Password <- isolate(input$passwd)
          if(length(which(credentials$username_id==Username))==1) { 
            pasmatch  <- credentials["passod"][which(credentials$username_id==Username),]
            pasverify <- password_verify(pasmatch, Password)
            if(pasverify) {
              USER$login <- TRUE
            } else {
              shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
              shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
            }
          } else {
            shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
            shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
          }
        } 
      }
    }    
  })
  
  output$logoutbtn <- renderUI({
    req(USER$login)
    tags$li(a(icon("fa fa-sign-out"), "Logout", 
              href="javascript:window.location.reload(true)"),
            class = "dropdown", 
            style = "background-color: #eee !important; border: 0;
                    font-weight: bold; margin:5px; padding: 10px;")
  })
  
  output$sidebarpanel <- renderUI({
    if (USER$login == TRUE ){ 
      fileInput("file1", "Choose xlsx File",
                multiple = FALSE,
                accept = c(".xlsx"),)#EndFileInput
    }
  })
  
  output$body <- renderUI({
    source("user_interface/demographic_csstags.R", local = TRUE)[1]
    if (USER$login == TRUE ) {
      # tags$head (tags$style(HTML('
      #   .box-header h3 {
      #     font-family: "Georgia", Times, "Times New Roman", serif;
      #     font-size: 12px;
      #   }
      # '))),
      tags$head (tags$style(HTML('
      .box-header h3.box-title {
        font-size: 20px;
      }
    ')))
      # source("user_interface/demographic_csstags.R", local = TRUE)[1]
      # tags$head(tags$style("
      #             #first_name{
      #             display:inline
      #             }"))
      # ------------------------------------------------------------
      #   Below is the code that can narrow the boxes potentially
      # ------------------------------------------------------------
      # tags$head(tags$style(HTML("div.col-sm-6 {padding:1px}"))),
      # tags$head(tags$style(HTML(' .box {margin: 5px;}' )))
      # ------------------------------------------------------------
      fluidRow(
        box(title = "Patient Information", status = "primary",solidHeader = TRUE, width = 3, 
            textOutput("last_name"),
            textOutput("first_name"),
            textOutput("id"),
            textOutput("date_of_study"),
        ), # End Box
        
        box(title = "Demographics", status = "primary",solidHeader = TRUE, width = 3,
            textOutput("age"),
            "Race: Reference",
            textOutput("sex"),
        ), # End Box
        
        # box(width = 3, title = "File Input & Output", status = "primary",
        #     fileInput("file1", "Choose xlsx File", # File Input Mechanism Runs Natively on RStudio
        #         multiple = FALSE, 
        #         accept = c(".xlsx"),),
        #     
        #     
        #     # PDF Capturing Mechanism, Relies on JavaScript to work so requires
        #     # web browswer or other javascript engine.
        #     
        #     capture_pdf(
        #       selector = "body",
        #       filename = "results",
        #       scale = 3,
        #       icon("camera"), "Take screenshot of results (bigger scale)"
        #       ),
        #     ), # End Box
        
        box(title = "Patient Data", status = "primary",solidHeader = TRUE, width = 3, 
            strong("Weight (kg):    ", style="display:inline"), textOutput("weight"),
            br(),
            strong(HTML(paste0("BMI (kg/m", tags$sup("2"), "):   ")), style = "display:inline"), textOutput("bmi"),
            br(),
            strong("Height (cm):    ", style="display:inline"), textOutput("height"),
            br(),
            br()
        ), # End Box
        
        box(title = "Calculated Patient Data", status = "primary",solidHeader = TRUE, width = 3,
            strong("IBW (kg):               ", style="display:inline"), textOutput("ibw"),
            br(),
            strong(HTML(paste0("ref BMI (kg/m", tags$sup("2"), "):        ")), style = "display:inline"), textOutput("rbmi"),
            br(),
            strong(HTML(paste0("ref FEV",tags$sub("1"), " NHANES III (L): ")), style = "display:inline"), textOutput("nhanes"),
            br(),
            br()
            # ,
            # strong(HTML(paste0("VE",tags$sub("cap"), " / MVV (L/min): ")), style = "display:inline"), textOutput("vecap"),
            # br()
            
        ), # End Box
        
        #============================#
        # Box for the Table Values   #
        #============================# 
        
        # box(title = "Tabular Data (Cooper Key Variables)", status = "primary", solidHeader = TRUE, width = 6,
        #     # gt_output(outputId = "table1"),
        #     
        #     # strong("VO2 Max(L/min): "),
        #     # textOutput("output1"),
        #     # strong("HR Max (BPM): "), textOutput("output2"),
        #     # strong("Power Max (Watts): "), textOutput("output3"),
        #     ), # end Box
        tabBox(
          title = "Tabular Data (Cooper Key Variables)", side = "right", width = 6,
          selected = "Tabular Data",
          # The id lets us use input$tabset1 on the server to find the current tab
          id = "tabset1",
          tabPanel("Codebook", status = "primary",
                   gt_output(outputId = "codebook"),),
          tabPanel("Tabular Data", status = "primary", solidHeader = TRUE,
                   br(),
                   br(),
                   gt_output(outputId = "table1"),)
        ),
        
        #============================#
        # Four Plot Box              #
        #============================# 
        tabBox(title = "Graphical Data (Cooper 4-Panel)", side = "right", width = 6,
               id = "tabset2", selected = "Primary Four Plot",
               tabPanel("Secondary Four Plot", status = "primary", solidHeader = TRUE,
                        br(),
               ), tabPanel("Primary Four Plot", status = "primary", solidHeader = TRUE,
                           br(),
                           plotOutput("plot1", 
                                      width = 700, height = 700
                                      # Facing issues when scaling boxes to the right size and
                                      # keeping the plots looking good at all devices
                           ),
                           br(),)
        ), # End Box
        
        box(title = "Technical Comments", status = "warning", solidHeader = TRUE, width = 6,
            textOutput("raw_testcontroller_validity"),
            br(),
            textOutput("workrate_variability_validity"),
            br(),
            textOutput("ramp_duration_validity"),
            br(),
            textOutput("metabolic_efficiency_validity"),
            br(),
            textOutput("erroneous_hr_validity"),
            br(),
            textOutput("vco2theta_validity")
        ), # End Box
        
        box(title = "Physician Interpretation", status = "warning", solidHeader = TRUE, width = 6,
            textAreaInput("caption", "Input Comments: ", "", width = "1200", height = "200")),
        valueBoxOutput("approvalBox", width = 3),
        valueBoxOutput("failureBox", width = 3)
      ) # FluidRow
    }
    else {
      loginpage
    }
  })
  
  
  #============================#
  # Data Inputs                #
  #============================#
    cleaned_data <- reactive({
      source("cosmed/cosmed_data_cleaning.R", local = TRUE) # Reference data_cleaning.R
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
      name <- paste("Last Name:", last_name, sep = " ")
      name
    }) #EndRenderText
    
    output$first_name <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      name <- paste("First Name:", first_name, sep = " ")
      name
    }) #EndRenderText
    
    output$sex <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      sex <- paste("Sex:", sex, sep = " ")
      sex
    }) #EndRenderText
    
    output$age <- renderText({
      source("Global/demographics_data.R", local = TRUE)[1]
      age_d <- paste("Age:", toString(age), sep = " ")
      age_d
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
      id <- paste("ID:", toString(id), sep = " ")
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
      date_of_study <- paste("Date of Study:", toString(date_of_study), sep = " ")
      date_of_study
    }) #EndRenderText
    
})