library(shiny)
library(shinydashboard)
library(tidyverse)   ## Contains multiple packages that are essential to R.
library(ggpubr)      ## Publication ready R designs
library(car)         ## Regression Grammar
library(ggplot2)     ## Grammar of Graphics
library(readxl)      ## Reads Excel Files
library(zoo)         ## Rolling Averages
library(rmarkdown)
library(remotes)
# library(capture)
library(gt)
library(shinyscreenshot) # handles the download for the tabularized report
library(glue)
library(stringr)
library(patchwork)
library(segmented)

shinyUI(dashboardPage(skin = "blue",
  dashboardHeader(title = "UCLA CPET Analytics"),
  
  ## Sidebar
  dashboardSidebar(
    fileInput("file1", "Choose xlsx File",
              multiple = FALSE,
              accept = c(".xlsx"),),#EndFileInput
    strong(".     .")
    # capture_pdf(
    #         selector = "body",
    #         filename = "tabularized_report",
    #         scale = 3,
    #         icon("camera"), "Download"
    #         )
  ),
  
  dashboardBody(
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
    '))),
    
    source("user_interface/demographic_csstags.R", local = TRUE)[1],
    tags$style("#last_name { white-space:pre; }"),
    # ------------------------------------------------------------
    #   Below is the code that can narrow the boxes potentially
    # ------------------------------------------------------------
    # tags$head(tags$style(HTML("div.col-sm-6 {padding:1px}"))),
    # tags$head(tags$style(HTML(' .box {margin: 5px;}' )))
    # ------------------------------------------------------------
    fluidRow(
      box(title = "Patient Information", status = "primary",solidHeader = TRUE, width = 3, 
          strong("Last Name:     ", style="display:inline"), textOutput("last_name"),
          br(),
          strong("First Name:    "),textOutput("first_name"),
          br(),
          strong("ID:            ", style="display:inline"), textOutput("id"),
          br(),
          strong("Date of Study: ", style ="display:inline"),textOutput("date_of_study"),
          ), # End Box
      
      box(title = "Demographics", status = "primary",solidHeader = TRUE, width = 3,
          strong("Age:           ", style="display:inline"), textOutput("age"),
          br(),
          strong("Race:          ", style="display:inline"), "Reference",
          br(),
          strong("Sex:           ", style="display:inline"), textOutput("sex"),
          br(),
          br()
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
  ) # End Dashboard Body
)) # End Dashboard Page
