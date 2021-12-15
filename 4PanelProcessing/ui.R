library(shiny)
library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title = "UCLA CPET Analytics"),
  
  ## Sidebar
  dashboardSidebar(
    fileInput("file1", "Choose xlsx File", 
              multiple = FALSE, 
              accept = c(".xlsx"),) #EndFileInput
  ),
  
  dashboardBody(
    
    source("user_interface/demographic_csstags.R", local = TRUE)[1],
    
    # ------------------------------------------------------------
    #   Below is the code that can narrow the boxes potentially
    # ------------------------------------------------------------
    # tags$head(tags$style(HTML("div.col-sm-6 {padding:1px}"))),
    # tags$head(tags$style(HTML(' .box {margin: 5px;}' )))
    # ------------------------------------------------------------
    fluidRow(
      box(title = "Patient Information", status = "primary", width = 3, 
          strong("ID: ", style="display:inline"), textOutput("id"),
          br(),
          strong("Last Name: ", style="display:inline"), textOutput("last_name"),
          br(),
          strong("First Name: "),textOutput("first_name")
          ), # End Box
      
      box(title = "Demographics", status = "primary", width = 3,
          strong("Age: ", style="display:inline"), textOutput("age"),
          br(),
          strong("Race: ", style="display:inline"),
          br(),
          strong("Sex: ", style="display:inline"), textOutput("sex"),
          ), # End Box
      
      box(title = "Patient Data", status = "primary", width = 3, 
          strong("Weight: ", style="display:inline"), textOutput("weight"),
          br(),
          strong("IBW: ", style="display:inline"), textOutput("ibw"),
          br(),
          strong("Height: ", style="display:inline"), textOutput("height"),
          ), # End Box
      
      box(title = "Calculated Patient Data", status = "primary", width = 3,
          strong("BMI: ", style="display:inline"), textOutput("bmi"),
          br(),
          strong("RBMI: ", style="display:inline"), textOutput("rbmi"),
          br(),
          strong("Ref FEV1 Nhanes II (L): ", style="display:inline"),
          ), # End Box
      
      #============================#
      # Box for the Table Values   #
      #============================# 
      
      box(title = "Reference Value Table", status = "primary", solidHeader = TRUE, width = 6,
          strong("VO2 Max(L/min): "),
          textOutput("output1"),
          strong("HR Max (BPM): "), textOutput("output2"),
          strong("Power Max (Watts): "), textOutput("output3")
      ), # End Box
      
      #============================#
      # Four Plot Box              #
      #============================# 
      box(title = "Cooper's Four Plot Render", status = "primary", solidHeader = TRUE, width = 6,
          plotOutput("plot1", 
                     # width = 530, height = 530
                     # Facing issues when scaling boxes to the right size and
                     # keeping the plots looking good at all devices
                     ), 
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
          textOutput("erroneous_hr_validity")
          ),
      
      box(title = "Physician Comments", status = "warning", solidHeader = TRUE, width = 6,
          textInput("Input Comments", label = "Text Input", value = ""))
      
      ) # FluidRow
  ) # End Dashboard Body
)) # End Dashboard Page
