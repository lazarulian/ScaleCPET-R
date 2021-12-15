list(
        source("Raw4PanelPlots/axes_scaling.R", local = TRUE)[1],

        # Graphing Color Palette
        
        red.bold.10.text <- element_text(face = "bold", color = "#E74C3C", size = 10),
        purple.bold.10.text <- element_text(face = "bold", color = "#7D3C98", size = 10),
        blue.bold.10.text <- element_text(face = "bold", color = "#3498DB", size = 10),
        green.bold.10.text <- element_text(face = "bold", color = "#239B56", size = 10),
        orange.bold.10.text <- element_text(face = "bold", color = "#D35400", size = 10),
        
        # Composition of Four Plots
        p1 <- ggplot(cleaned_data(), aes(x = Power))+
            geom_point( aes(y=VO2), color= "#D35400", size = 1) +
            geom_point( aes(y=VCO2), color= "#3498DB", size = 1) + # Divide by 10 to get the same range than the temperature
            scale_y_continuous("VO2 (L/min)", 
                               # expand = c(0, 0), This will restore the axes ticks to strictly 0,0
                                # minor_breaks = seq(VO2_range_start, VO2_range_end, VO2_minor_tick),
                                breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                                limits=c(VO2_range_start, VO2_range_end),
                                sec.axis = dup_axis(~ . , name="VCO2 (L/min)")) +
            # theme_bw() + 
            theme_classic() + # Classic Does not allow for minor_gridlines to work.
            theme(axis.text.y.left = orange.bold.10.text, axis.text.y.right = blue.bold.10.text) +
            theme(aspect.ratio=1) +
            scale_x_continuous(name = "Power (Watts)", 
                               # expand = c(0, 0), This will restore the axes ticks to strictly 0,0
                                breaks = seq(watts_range_start, watts_range_end, watts_minor_tick),
                                limits=c(watts_range_start, watts_range_end)),

        p2 <- ggplot(cleaned_data(), aes(x=VO2, y=VCO2)) + 
            geom_point(color = "#3498DB", size = 1) + #BLUE COLOR
            geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            # stat_poly_eq(formula = my.formula, 
            #            aes(label = paste(..eq.label.., ..rr.label.., sep = "~~~")), 
            #            parse = TRUE) +
            scale_x_continuous(name = "VO2 (L/min)",
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            scale_y_continuous(name = "VCO2 (L/min)",
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            theme_classic() +
            theme(aspect.ratio=1) +
            theme(axis.text.x = orange.bold.10.text, axis.text.y = blue.bold.10.text),
        
        p3<-ggplot(cleaned_data(), aes(x=VCO2, y=VE)) + 
            geom_point(color = "#239B56", size = 1) + #GREEN COLOR
            #geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = "VCO2 (L/min)",
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            scale_y_continuous(name = "VE (L/min)",
                               breaks = seq(VE_range_start, VE_range_end, VE_minor_tick),
                               limits=c(VE_range_start, VE_range_end)) +
            theme_classic() +
            theme(aspect.ratio=1) +
            theme(axis.text.x = blue.bold.10.text, axis.text.y = green.bold.10.text),
        
        ##PLOT 4: HR vs VO2
        p4<-ggplot(cleaned_data(), aes(x=VO2, y=HR)) + 
            geom_point(color = "#7D3C98", size = 1) + #PURPLE COLOR
            geom_smooth(method=lm, se=FALSE, color = "#E74C3C") + #RED COLOR
            scale_x_continuous(name = "VO2 (L/min)",
                               breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                               limits=c(VO2_range_start, VO2_range_end)) +
            scale_y_continuous(name = "HR (bpm)",
                               breaks = seq(0, 220, 20),
                               limits=c(0, 220)) +
            theme_classic() +
            theme(aspect.ratio=1) +
            theme(axis.text.x = orange.bold.10.text, axis.text.y = purple.bold.10.text),
        
        plot.a<-plot_grid(p1, p3, ncol = 1, align = "v", nrow = 2),
        plot.b<-plot_grid(p2, p4, ncol = 1, align = "v", nrow = 2)
)