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
# library(shinyscreenshot) # handles the download for the tabularized report
library(glue)
library(stringr)
library(patchwork)
library(segmented)
library(DT)
library(shinyjs)
library(sodium)

source("authentication.R", local = TRUE)[1]

header <- dashboardHeader( title = "UCLA CPET Analytics", uiOutput("logoutbtn"))
sidebar <- dashboardSidebar(uiOutput("sidebarpanel")) 
body <- dashboardBody(shinyjs::useShinyjs(), uiOutput("body"))

shinyUI(dashboardPage(header, sidebar, body, skin = "blue"))