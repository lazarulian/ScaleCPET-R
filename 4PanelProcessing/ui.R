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
library(rsconnect)   ## ServerPublication

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    titlePanel("UC-Fitness Lab Data Processing Application"),
    
    # Sidebar Panel
    
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
