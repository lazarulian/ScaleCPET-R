# UI.R
shinyUI(navbarPage("UC-Fitness Lab Data Processing Application",
                   tabPanel("Corrected 4Panel",
                            sidebarLayout(
                                sidebarPanel(
                                    source("patient_info_sidebar.R", local = TRUE)[1] # Reference Sidebar1.R
                                ),
                                mainPanel(
                                    h1("Graph Output"),
                                    
                                )
                            )
                   ),
                   
    tabPanel("4-Panel Plot",
        sidebarLayout(
            sidebarPanel(
                source("sidebar1.R", local = TRUE)[1] # Reference Sidebar1.R
            ), #EndSidebarPanel
            
            # Main Panel with Graph Output
            mainPanel(
                h1("Graph Output"),
                plotOutput("plot1", width = "1300", height = "1300") # Outputs from server-side
                
            )#EndMainPanel
            
        ) #EndSidebarLayout
    ), # End Tab Panel
    tabPanel("Test Validity",
        sidebarLayout(
            sidebarPanel(
                source("sidebar2.R", local = TRUE)[1] # Reference Sidebar1.R
            ),
            mainPanel(
                h1("Graph Output"),
                plotOutput("plot2", width = "800", height = "400"),
            )
        )
    )
    
    
    
)) #End NavBarPage (Shiny UI Template)
