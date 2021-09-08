# Initialization
library(shiny)
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


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    titlePanel("UC-Fitness Lab Data Processing Application"),
    
    # Sidebar Panel
    
    sidebarLayout(
        sidebarPanel(
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
            
        ), #EndSidebarPanel
        
        # Main Panel with Graph Output
        mainPanel(
            h1("Graph Output"),
            plotOutput("plot1", width = "1000", height = "1000") # Outputs from server-side
            
            
        ),#EndMainPanel
        
    ) #EndSidebarLayout
    
    
)) #EndFluidpage (Shiny UI Template)
