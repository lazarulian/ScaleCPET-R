#corrected_4panel
list(
  source("Global/data_cleaning.R", local = TRUE)[1],
  source("Raw4PanelPlots/axes_scaling.R", local = TRUE)[1],
  source("Raw4PanelPlots/raw_plot.R", local = TRUE),
  
  powervo2_regression <- lm(wbb1$Power ~ wbb1$VO2, data = wbb1),
  powervo2_intercept <- summary(powervo2_regression)$coef[[1]],
  powervo2_slope <- summary(powervo2_regression)$coef[[2]],
  
  corrected_VO2 <- ((wbb1$Power)*powervo2_slope)+powervo2_intercept,
  corrected_VO2 <- as.numeric(corrected_VO2),
  
  powervco2_regression <- lm(wbb1$Power ~ wbb1$VCO2, data = wbb1),
  powervco2_intercept <- summary(powervco2_regression)$coef[[1]],
  powervco2_slope <- summary(powervco2_regression)$coef[[2]],
  
  corrected_VCO2 <- ((wbb1$Power)*powervco2_slope)+powervco2_intercept,
  corrected_VCO2 <- as.numeric(corrected_VCO2),
  
  
  plot_test <- ggplot(wbb1, aes(x = Power))+
    geom_point( aes(y=corrected_VO2), color= "#D35400", size = 1) +
    geom_point( aes(y=corrected_VCO2), color= "#3498DB", size = 1) + # Divide by 10 to get the same range than the temperature
    scale_y_continuous("VO2 (L/min)",
                       minor_breaks = seq(VO2_range_start, VO2_range_end, VO2_minor_tick),
                       breaks = seq(VO2_range_start, VO2_range_end, by=VO2_minor_tick),
                       limits=c(VO2_range_start, VO2_range_end),
                       sec.axis = dup_axis(~ . , name="VCO2 (L/min)")) +
    # theme_bw() + 
    theme_classic() + # Classic Does not allow for minor_gridlines to work.
    theme(axis.text.y.left = orange.bold.10.text, axis.text.y.right = blue.bold.10.text) +
    theme(aspect.ratio=1) +
    scale_x_continuous(name = "Power (Watts)",
                       breaks = seq(watts_range_start, watts_range_end, watts_minor_tick),
                       limits=c(watts_range_start, watts_range_end))
)