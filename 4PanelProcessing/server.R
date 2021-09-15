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
        
        wbb1 <- convert_data1 %>% select(11:36) # The Dataframe that includes all of the key variables required for data manipulation.

        # Graph Processing with Cleaned Data
        
        wbb1$VO2 <- (wbb1$VO2)/1000   #CONVERT TO LITERS
        wbb1$VO2 <- as.numeric(wbb1$VO2)  
        wbb1$VCO2 <- (wbb1$VCO2)/1000   #CONVERT TO LITERS
        wbb1$VCO2 <- as.numeric(wbb1$VCO2)
        
        # Convert Content to Rolling Averages
        Watts_5avg <- zoo::rollmean(wbb1$Power, k = 5, fill = NA)
        VO2_5avg <- zoo::rollmean(wbb1$VO2, k = 5, fill = NA)
        VCO2_5avg <- zoo::rollmean(wbb1$VCO2, k = 5, fill = NA)
        VE_5avg <- zoo::rollmean(wbb1$VE, k = 5, fill = NA)
        HR_5avg <- zoo::rollmean(wbb1$HR, k = 5, fill = NA)

        # Initializing Variables
        watts_max <- 0

        # Test Function Declaration
        watts_max_test <- function(watts_max_input) {
          watts_distance_counter <- 0
          for(i in 1:length(wbb1$Power)){
            if (abs(wbb1$Power[i]-watts_max_input) < 10) {
              watts_distance_counter <- watts_distance_counter + 1
            } 
            else {
              next
            }
          } # End For Loop
          return(watts_distance_counter)
        } # End Function Declaration

        # Determining Watts Max (Conver to Function DNR)

        for(i in 1:length(wbb1$Power)){
          if (watts_max_test(wbb1$Power[i]) > 1) {
            if (wbb1$Power[i] > watts_max) {
              watts_max <- wbb1$Power[i]
            }
            else {
              next
            }
          } 
          else {
            next
          }  
        }






        ## All Scaling Options

        ## VO2/VCO2 Scaling Options
        
        if(watts_max>0 & 50>watts_max) {
            VO2_range_start <- 0
            VO2_range_end <- 1
            VO2_major_tick <- 0.2
            VO2_minor_tick <- 0.2
        }
        else if(watts_max>49 & 100>watts_max) {
          VO2_range_start <- 0
          VO2_range_end <- 2
          VO2_major_tick <- 1
          VO2_minor_tick <- 0.5
        }
        else if(watts_max>99 & 150>watts_max) {
          VO2_range_start <- 0
          VO2_range_end <- 3
          VO2_major_tick <- 1
          VO2_minor_tick <- 0.5
        }
        else if(watts_max>149 & 200>watts_max) {
          VO2_range_start <- 0
          VO2_range_end <- 4
          VO2_major_tick <- 1
          VO2_minor_tick <- 0.5
        }
        else if(watts_max>199 & 300>watts_max) {
          VO2_range_start <- 0
          VO2_range_end <- 6
          VO2_major_tick <- 2
          VO2_minor_tick <- 1
        }
        else if(watts_max>299 & 400>watts_max) {
          VO2_range_start <- 0
          VO2_range_end <- 8
          VO2_major_tick <- 4
          VO2_minor_tick <- 2
        }
        else {
          next
        }

      ## Watts Scaling Options
        
        if(watts_max>0 & 50>watts_max) {
            watts_range_start <- 0
            watts_range_end <- 50
            watts_major_tick <- 10
            watts_minor_tick <- 10
        }
        else if(watts_max>49 & 100>watts_max) {
          watts_range_start <- 0
          watts_range_end <- 100
          watts_major_tick <- 20
          watts_minor_tick <- 10
        }
        else if(watts_max>99 & 150>watts_max) {
          watts_range_start <- 0
          watts_range_end <- 150
          watts_major_tick <- 50
          watts_minor_tick <- 25
        }
        else if(watts_max>149 & 200>watts_max) {
          watts_range_start <- 0
          watts_range_end <- 200
          watts_major_tick <- 100
          watts_minor_tick <- 50
        }
        else if(watts_max>199 & 300>watts_max) {
          watts_range_start <- 0
          watts_range_end <- 300
          watts_major_tick <- 100
          watts_minor_tick <- 50
        }
        else if(watts_max>299 & 400>watts_max) {
          watts_range_start <- 0
          watts_range_end <- 400
          watts_major_tick <- 200
          watts_minor_tick <- 100
        }
        else {
          next
        }

        ## VE Scaling Options
        
        if(watts_max>0 & 50>watts_max) {
            VE_range_start <- 0
            VE_range_end <- 60
            VE_major_tick <- 10
            VE_minor_tick <- 10
        }
        else if(watts_max>49 & 100>watts_max) {
          VE_range_start <- 0
          VE_range_end <- 80
          VE_major_tick <- 20
          VE_minor_tick <- 10
        }
        else if(watts_max>99 & 150>watts_max) {
          VE_range_start <- 0
          VE_range_end <- 100
          VE_major_tick <- 20
          VE_minor_tick <- 10
        }
        else if(watts_max>149 & 200>watts_max) {
          VE_range_start <- 0
          VE_range_end <- 120
          VE_major_tick <- 20
          VE_minor_tick <- 10
        }
        else if(watts_max>199 & 300>watts_max) {
          VE_range_start <- 0
          VE_range_end <- 160
          VE_major_tick <- 20
          VE_minor_tick <- 10
        }
        else if(watts_max>299 & 400>watts_max) {
          VE_range_start <- 0
          VE_range_end <- 200
          VE_major_tick <- 30
          VE_minor_tick <- 15
        }
        else {
          next
        }

        ## fC Scaling Options

        fC_range_start <- 40
        fC_range_end <- 240
        fC_major_tick <- 40
        fC_minor_tick <- 20

        ## VT Scaling Options

        VT_range_start <- 0
        VT_range_end <- 4
        VT_major_tick <- 1
        VT_minor_tick <- 0.5



        # Scaling Requires more variables, input when needed.


        # Graphing Color Palette
        
        red.bold.10.text <- element_text(face = "bold", color = "#E74C3C", size = 10)
        purple.bold.10.text <- element_text(face = "bold", color = "#7D3C98", size = 10)
        blue.bold.10.text <- element_text(face = "bold", color = "#3498DB", size = 10)
        green.bold.10.text <- element_text(face = "bold", color = "#239B56", size = 10)
        orange.bold.10.text <- element_text(face = "bold", color = "#D35400", size = 10)
        
        # Composition of Four Plots
        
        p1 <- ggplot(wbb1, aes(x = Watts_5avg))+
            geom_point( aes(y=VO2_5avg), color= "#D35400", size = 1) +
            geom_point( aes(y=VCO2_5avg), color= "#3498DB", size = 1) + # Divide by 10 to get the same range than the temperature
            scale_y_continuous("VO2 (L/min)",
                                # minor_breaks = seq(VO2_range_start, VO2_range_end, VO2_minor_tick),
                                breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                                limits=c(VO2_range_start, VO2_range_end),
                                sec.axis = dup_axis(~ . , name="VCO2 (L/min)")) +
            # theme_bw() + 
            theme_classic() + # Classic Does not allow for minor_gridlines to work.
            theme(axis.text.y.left = orange.bold.10.text, axis.text.y.right = blue.bold.10.text) +
            scale_x_continuous(name = "Power (Watts)",
                                breaks = seq(watts_range_start, watts_range_end, watts_minor_tick),
                                limits=c(watts_range_start, watts_range_end))

        p2 <- ggplot(wbb1, aes(x=VO2_5avg, y=VCO2_5avg)) + 
            geom_point(color = "#3498DB", size = 1) + #BLUE COLOR
            #geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = "VO2 (L/min)",
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            scale_y_continuous(name = "VCO2 (L/min)",
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            theme_classic() +
            theme(axis.text.x = orange.bold.10.text, axis.text.y = blue.bold.10.text)
        
        p3<-ggplot(wbb1, aes(x=VCO2_5avg, y=VE_5avg)) + 
            geom_point(color = "#239B56", size = 1) + #GREEN COLOR
            #geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = "VCO2 (L/min)",
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            scale_y_continuous(name = "VE (L/min)",
                               breaks = seq(VE_range_start, VE_range_end, VE_minor_tick),
                               limits=c(VE_range_start, VE_range_end)) +
            theme_classic() +
            theme(axis.text.x = blue.bold.10.text, axis.text.y = green.bold.10.text)
        
        ##PLOT 4: HR vs VO2
        p4<-ggplot(wbb1, aes(x=VO2_5avg, y=HR_5avg)) + 
            geom_point(color = "#7D3C98", size = 1) + #PURPLE COLOR
            geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = "VO2 (L/min)",
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
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

    ## Max Watts Text Output
    output$output3 <- renderText({
        
        req(input$file1) 
        inFile <- input$file1
        
        # Reads Excel File Input / Cleans Raw Data
        col_names <- array(read_excel(inFile$datapath, sheet = 1, n_max = 1, col_names = FALSE))
        rawdata <- data.frame(read_excel(inFile$datapath, sheet = 1, skip = 3, col_names = FALSE))
        colnames(rawdata) <- col_names
        
        convert_data1 <- rawdata
        
        wbb1 <- convert_data1 %>% select(11:36) # The Dataframe that includes all of the key variables required for data manipulation.

        # Initializing Variables
        watts_max <- 0

        # Test-Case Declaration
        watts_max_test <- function(watts_max_input) {
          watts_distance_counter <- 0
          for(i in 1:length(wbb1$Power)){
            if (abs(wbb1$Power[i]-watts_max_input) < 10) {
              watts_distance_counter <- watts_distance_counter + 1
            } 
            else {
              next
            }
          } # End For Loop
          return(watts_distance_counter)
        } # End Function Declaration

        # Watts Max Determination

        for(i in 1:length(wbb1$Power)){
          if (watts_max_test(wbb1$Power[i]) > 1) {
            if (wbb1$Power[i] > watts_max) {
              watts_max <- wbb1$Power[i]
            }
            else {
              next
            }
          } 
          else {
            next
          }  
        }

        watts_max
        
    }) #EndRenderText
    

})