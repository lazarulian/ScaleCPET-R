list(
            h2("File Input:"), #TitleSidebar
            em("Currently only accepting raw xlsx output from Cosmed software."),
            br(), 
            br(),
            
            # File Input UI
            fileInput("file1", "Choose xlsx File",
                      multiple = FALSE,
                      accept = c(".xlsx"), #Accept
            ), #EndFileInput
            
            # Download Button for Graphs
            downloadButton('downloadPlot', 'Download Plot'),
            
            # Maximum Value Output
            h2("Data Values:"),
            strong("VO2 Max(L/min): "),
            textOutput("output1"),
            strong("HR Max (BPM): "), textOutput("output2"),
            strong("Power Max (Watts): "), textOutput("output3")
            # strong("R^2 Watts/VO2: "), textOutput("output4"),
            
        ) #EndSidebarPanel