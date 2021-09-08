# Initialization

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
library(shiny)       ## Shiny


# Define server 
shinyServer(function(input, output) {
    
    # Data Input (Uploaded File)
    data <- reactive({ 
        
        inFile <- input$file1
        if(!is.null(inFile)) {
            read_excel(inFile$datapath, header = input$header, stringsAsFactors = TRUE)
            
        } # EndIfStatement
        
    }) # EndDataReactive
    
    # Plot Output (ServerSide)
    
    output$plot1 <- renderPlot({
        # Calls Excel File Input
        req(input$file1) 
        inFile <- input$file1
        
        # Reads Excel File Input / Cleans Raw Data
        col_names <- array(read_excel(inFile$datapath, sheet = 1, n_max = 1, col_names = FALSE))
        rawdata <- data.frame(read_excel(inFile$datapath, sheet = 1, skip = 3, col_names = FALSE))
        colnames(rawdata) <- col_names
        
        convert_data1 <- rawdata
        
        wbb1 <- convert_data1 %>% select(10:25)
        
        
        # Graph Processing with Cleaned Data
        
        wbb1$VO2 <- (wbb1$VO2)/1000   #CONVERT TO LITERS
        wbb1$VO2 <- as.numeric(wbb1$VO2)  
        wbb1$VCO2 <- (wbb1$VCO2)/1000   #CONVERT TO LITERS
        wbb1$VCO2 <- as.numeric(wbb1$VCO2)
        
        # Convert Content to Rolling Averages
        
        VO2_5avg <- zoo::rollmean(wbb1$VO2, k = 5, fill = NA)
        VCO2_5avg <- zoo::rollmean(wbb1$VCO2, k = 5, fill = NA)
        VE_5avg <- zoo::rollmean(wbb1$VE, k = 5, fill = NA)
        HR_5avg <- zoo::rollmean(wbb1$HR, k = 5, fill = NA)
        
        
        # Graphing Color Palette
        
        red.bold.10.text <- element_text(face = "bold", color = "#E74C3C", size = 10)
        purple.bold.10.text <- element_text(face = "bold", color = "#7D3C98", size = 10)
        blue.bold.10.text <- element_text(face = "bold", color = "#3498DB", size = 10)
        green.bold.10.text <- element_text(face = "bold", color = "#239B56", size = 10)
        orange.bold.10.text <- element_text(face = "bold", color = "#D35400", size = 10)
        
        # Composition of Four Plots
        
        p1 <- ggplot(wbb1, aes(x = t))+
            geom_point( aes(y=VO2_5avg), color= "#D35400", size = 1) +
            geom_point( aes(y=VCO2_5avg), color= "#3498DB", size = 1) + # Divide by 10 to get the same range than the temperature
            scale_y_continuous("VO2 (L/min)",
                               breaks = seq(0, 5, 0.5),
                               limits=c(0, 5),
                               sec.axis = dup_axis(~ . , name="VCO2 (L/min)")) +
            theme_classic() + theme(axis.text.y.left = orange.bold.10.text, axis.text.y.right = blue.bold.10.text) +
            scale_x_datetime(name = "Time")
        
        
        
        p2 <- ggplot(wbb1, aes(x=VO2_5avg, y=VCO2_5avg)) + 
            geom_point(color = "#3498DB", size = 1) + #BLUE COLOR
            #geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = "VO2 (L/min)",
                               breaks = seq(0, 5, 0.5),
                               limits=c(0, 5)) +
            scale_y_continuous(name = "VCO2 (L/min)",
                               breaks = seq(0, 5, 0.5),
                               limits=c(0, 5)) +
            theme_classic() +
            theme(axis.text.x = orange.bold.10.text, axis.text.y = blue.bold.10.text)
        
        p3<-ggplot(wbb1, aes(x=VCO2_5avg, y=VE_5avg)) + 
            geom_point(color = "#239B56", size = 1) + #GREEN COLOR
            #geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = "VCO2 (L/min)",
                               breaks = seq(0, 5, 0.5),
                               limits=c(0, 5)) +
            scale_y_continuous(name = "VE (L/min)",
                               breaks = seq(0, 150, 10),
                               limits=c(0, 150)) +
            theme_classic() +
            theme(axis.text.x = blue.bold.10.text, axis.text.y = green.bold.10.text)
        
        ##PLOT 4: HR vs VO2
        p4<-ggplot(wbb1, aes(x=VO2_5avg, y=HR_5avg)) + 
            geom_point(color = "#7D3C98", size = 1) + #PURPLE COLOR
            geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = "VO2 (L/min)",
                               breaks = seq(0, 5, 0.5),
                               limits=c(0, 5)) +
            scale_y_continuous(name = "HR (bpm)",
                               breaks = seq(0, 220, 20),
                               limits=c(0, 220)) +
            theme_classic() +
            theme(axis.text.x = orange.bold.10.text, axis.text.y = purple.bold.10.text)
        
        plot.a<-plot_grid(p1, p3, ncol = 1, align = "v", nrow = 2)
        plot.b<-plot_grid(p2, p4, ncol = 1, align = "v", nrow = 2)
        
        plot_grid(plot.a, plot.b, align = "h", axis = "b", nrow = 2, ncol = 2)
        
    }) #Plot1 Output
    
    output$downloadPlot <- downloadHandler(
        filename = function() { paste(input$wbb1, '.png', sep='') },
        content = function(file) {
            ggsave(file, plot = plotOutput(), device = "png")
        })
    
    ## Max VO2 Text Output
    output$output1 <- renderText({
        
        req(input$file1) 
        inFile <- input$file1
        
        # Reads Excel File Input / Cleans Raw Data
        col_names <- array(read_excel(inFile$datapath, sheet = 1, n_max = 1, col_names = FALSE))
        rawdata <- data.frame(read_excel(inFile$datapath, sheet = 1, skip = 3, col_names = FALSE))
        colnames(rawdata) <- col_names
        
        convert_data1 <- rawdata
        
        wbb1 <- convert_data1 %>% select(10:25)
        
        wbb1$VO2 <- (wbb1$VO2)/1000   #CONVERT TO LITERS
        wbb1$VO2 <- as.numeric(wbb1$VO2)  
        wbb1$VCO2 <- (wbb1$VCO2)/1000   #CONVERT TO LITERS
        wbb1$VCO2 <- as.numeric(wbb1$VCO2)
        
        # Finds Max Value
        max(wbb1$VO2)
        
    }) #EndRenderText
    
    ## Max HeartRate Text Output
    output$output2 <- renderText({
        
        req(input$file1) 
        inFile <- input$file1
        
        # Reads Excel File Input / Cleans Raw Data
        col_names <- array(read_excel(inFile$datapath, sheet = 1, n_max = 1, col_names = FALSE))
        rawdata <- data.frame(read_excel(inFile$datapath, sheet = 1, skip = 3, col_names = FALSE))
        colnames(rawdata) <- col_names
        
        convert_data1 <- rawdata
        
        wbb1 <- convert_data1 %>% select(10:25)
        
        wbb1$VO2 <- (wbb1$VO2)/1000   #CONVERT TO LITERS
        wbb1$VO2 <- as.numeric(wbb1$VO2)  
        wbb1$VCO2 <- (wbb1$VCO2)/1000   #CONVERT TO LITERS
        wbb1$VCO2 <- as.numeric(wbb1$VCO2)
        
        # Finds Max Value
        max(wbb1$HR)
        
    }) #EndRenderText
    

})
