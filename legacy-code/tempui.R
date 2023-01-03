# UI.R
shinyUI(navbarPage("UC-Fitness Lab Data Processing Application",
                   
    tabPanel("4-Panel Plot",
        sidebarLayout(
            sidebarPanel(
                source("sidebar1.R", local = TRUE)[1] # Reference Sidebar1.R
            ), #EndSidebarPanel
            
            # Main Panel with Graph Output
            mainPanel(
                h1("Graph Output"),
                plotOutput("plot1", width = "800", height = "800") # Outputs from server-side
                
            )#EndMainPanel
            
        ) #EndSidebarLayout
    ), # End Tab Panel
    
    
    tabPanel("Test Validity",
        sidebarLayout(
            sidebarPanel(
                source("TestValidity/sidebar2.R", local = TRUE)[1] # Reference Sidebar1.R
            ),
            mainPanel(
                h3("Watts vs. Time"),
                plotOutput("plot2", width = "800", height = "400"),
                plotOutput("workrate_variability_graph", width = "800", height = "400"),
                h4("VO2 vs. Watts"),
                plotOutput("VO2_variability_graph", width = "800", height = "400"),
                plotOutput("VO2_distribution_graph", width = "800", height = "400"),
                h4("VCO2 vs. Watts"),
                plotOutput("VCO2_variability_graph", width = "800", height = "400"),
                plotOutput("VCO2_distribution_graph", width = "800", height = "400"),
                h4("VCO2 vs. VO2"),
                plotOutput("VO2VCO2_variability_graph", width = "800", height = "400"),
                plotOutput("VO2VCO2_distribution_graph", width = "800", height = "400"),
                h4("VE vs. VCO2"),
                plotOutput("VCO2VE_variability_graph", width = "800", height = "400"),
                plotOutput("VCO2VE_distribution_graph", width = "800", height = "400"),
                h4("HR vs. VO2"),
                plotOutput("VO2HR_variability_graph", width = "800", height = "400"),
                plotOutput("VO2HR_distribution_graph", width = "800", height = "400"),
                
                
                
            )
        )
    ),
    
    tabPanel("Corrected 4Panel",
             sidebarLayout(
                 sidebarPanel(
                     source("patient_info_sidebar.R", local = TRUE)[1] # Reference Sidebar1.R
                 ),
                 mainPanel(
                     h1("Graph Output"),
                     plotOutput("plot3", width = "400", height = "400")
                     
                 )
             )
    )
    
    
    
)) #End NavBarPage (Shiny UI Template)
