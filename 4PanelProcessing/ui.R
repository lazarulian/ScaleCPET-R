shinyUI(fluidPage(
    titlePanel("UC-Fitness Lab Data Processing Application"),
    
    # Sidebar Layout
    sidebarLayout( 
        sidebarPanel(
            source("sidebar.R", local = TRUE)[1] # Reference Sidebar.R
        ), #EndSidebarPanel
        
        # Main Panel with Graph Output
        mainPanel(
            h1("Graph Output"),
            plotOutput("plot1", width = "1300", height = "1300") # Outputs from server-side
            
        ),#EndMainPanel
        
    ) #EndSidebarLayout
    
    
)) #EndFluidpage (Shiny UI Template)
