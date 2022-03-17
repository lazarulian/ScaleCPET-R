list(
        source("Raw4PanelPlots/axes_scaling.R", local = TRUE)[1],
        source("DataCalculation/regression_analysis.R", local = TRUE)[1],

        # Graphing Color Palette
        scaleFUN <- function(x) sprintf("%.2f", x), ## Scaling with Decimal Points
        
        red.bold.10.text <- element_text(face = "bold", color = "#E74C3C", size = 10),
        purple.bold.10.text <- element_text(face = "bold", color = "#7D3C98", size = 10),
        blue.bold.10.text <- element_text(face = "bold", color = "#3498DB", size = 10),
        green.bold.10.text <- element_text(face = "bold", color = "#239B56", size = 10),
        orange.bold.10.text <- element_text(face = "bold", color = "#D35400", size = 10),
        
        # Composition of Four Plots
        p1 <- ggplot(cleaned_data(), aes(x = Power, y = VO2))+
            geom_point( aes(y=VO2), color= "#D35400", size = 1) +
          stat_smooth(method="lm", se=FALSE, color = "black", size = 1) +
            geom_point( aes(y=VCO2), color= "#3498DB", size = 1) + # Divide by 10 to get the same range than the temperature
            scale_y_continuous(expression('VO'[2]*' (L/min)'), 
                               # expand = c(0, 0), This will restore the axes ticks to strictly 0,0
                                # minor_breaks = seq(VO2_range_start, VO2_range_end, VO2_minor_tick),
                                breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                                limits=c(VO2_range_start, VO2_range_end), labels = scaleFUN,
                                sec.axis = dup_axis(~ . , name=expression('VCO'[2]*' (L/min)'))) +
            # theme_bw() + 
            annotate("text", x = 0.1, y = (min(cleaned_data()$VCO2)-0.1), label = "S1", color = "black", fontface = "bold") +
            # annotate("text", x = max(cleaned_data()$Power) + -35, y = 0.1, label = expression('Work Rate'['max']*'')) +
            annotate("text", x = 20, y = max(cleaned_data()$VO2)+0.3, label = expression('VO'[2][' max']* '')) +
            theme_classic() + # Classic Does not allow for minor_gridlines to work.
            # theme(axis.text.y.left = orange.bold.10.text, axis.text.y.right = blue.bold.10.text) +
            theme(aspect.ratio=1) +
            scale_x_continuous(name = "Work Rate (watts)", 
                               # expand = c(0, 0), This will restore the axes ticks to strictly 0,0
                                breaks = seq(watts_range_start, watts_range_end, watts_minor_tick),
                                limits=c(watts_range_start, watts_range_end)),
        
        p1 <- p1 +  geom_vline(xintercept = max(cleaned_data()$Power), color = "grey", size=.75) +
          geom_hline(yintercept = max(cleaned_data()$VO2), color = "grey", size = 0.75) +
          annotate("text", x = max(cleaned_data()$Power) + -35, y = 0.1, label = expression('Work Rate'['max']*'')),

        p2 <- ggplot(cleaned_data(), aes(x=VO2, y=VCO2)) + 
            geom_point(color = "#3498DB", size = 1) + #BLUE COLOR
            scale_x_continuous(name = expression('VO'[2]*' (L/min)'),
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end), labels = scaleFUN) +
            scale_y_continuous(name = expression('VCO'[2]*' (L/min)'), labels = scaleFUN,
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            theme_classic() +
            theme(aspect.ratio=1),
            # + theme(axis.text.x = orange.bold.10.text, axis.text.y = blue.bold.10.text)
        
        p2 <- p2 + geom_line(data = vo2_segmented, color = "black", size=1) + 
          geom_vline(xintercept = vo2theta, color = "grey", size=.75, show.legend = TRUE) +
          # annotate("segment", x = vo2theta, xend = vo2theta, y = 0, yend = max(cleaned_data()$VCO2), 
          # color = "black") + ## Would not go to the bottom of the axes
          annotate("text", x = (min(cleaned_data()$VO2)+0.3), y = (min(cleaned_data()$VCO2)-0.2), label = "S2", color = "black", fontface = "bold") +
          annotate("text", x = vo2theta+0.5, y = 0.1, label = expression('VO'[2]*' \U03B8')),
        
        
        pVE<-ggplot(cleaned_data(), aes(x=VCO2, y=VE)) +
            geom_point(color = "#239B56", size = 1) + #GREEN COLOR
            #geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = expression('VCO'[2]*' (L/min)'), labels = scaleFUN,
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            scale_y_continuous(name = "VE (L/min)",
                               breaks = seq(0, 200, 40),
                               limits=c(0, 220)) +
                               # breaks = seq(VE_range_start, VE_range_end, VE_minor_tick),
                               # limits=c(VE_range_start, VE_range_end)) +
            theme_classic() +
            geom_vline(xintercept = vco2_theta, color = "grey", size=.75) +
            annotate("text", x = vco2_theta+0.5, y = 0.1, label = expression('VCO'[2]*' \U03B8')) +
          annotate("text", x = 0.3, y = (max(cleaned_data()$VE)+10), label = expression('V'['E max']* ' ')) +
          annotate("text", x = (min(cleaned_data()$VCO2)+0.3), y = (min(cleaned_data()$VE)-10), label = "S4", color = "red", fontface = "bold") +
            geom_hline(yintercept = max(cleaned_data()$VE), color = "grey", size =.75) +
            theme(aspect.ratio=1)
            # + theme(axis.text.x = blue.bold.10.text, axis.text.y = green.bold.10.text)
        ,
        
        p3 <- pVE + geom_line(data = vco2ve_segmented, color = "red", size=1),
        p3 <- p3 + geom_vline(xintercept = vco2_theta, color = "grey", size=.75),
        
        ##PLOT 4: HR vs VO2
        p4<-ggplot(cleaned_data(), aes(x=VO2, y=HR)) + 
            geom_point(color = "#7D3C98", size = 1) + #PURPLE COLOR
            geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = expression('VO'[2]*' (L/min)'), labels = scaleFUN,
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            scale_y_continuous(name = "fC (bpm)",
                               breaks = seq(0, 200, 40),
                               limits=c(0, 220)) +
            theme_classic() +
            theme(aspect.ratio=1), 
        
        p4 <- p4 + geom_vline(xintercept = max(cleaned_data()$VO2), color = "grey", size = 0.75) +
          annotate("text", x = max(cleaned_data()$VO2)+0.3, y = 10, label = expression('VO'[2][' max']* '')) +
          geom_hline(yintercept = max(cleaned_data()$HR), color = "grey", size = 0.75) +
          annotate("text", x = 0.3, y = max(cleaned_data()$HR)+10, label = expression('f'['c'][' max']* '')) +
          annotate("text", x = (min(cleaned_data()$VO2)-0.2), y = (min(cleaned_data()$HR)-0.10), label = "S3", color = "red", fontface = "bold")
          
            # + theme(axis.text.x = orange.bold.10.text, axis.text.y = purple.bold.10.text)
        
)