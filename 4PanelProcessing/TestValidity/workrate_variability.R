# workrate_variability.R
# Graphing corrected workrate vs. raw workrate

list(
  workrate_variability <- corrected_data()$Power-cleaned_data()$Power,
  
  ## Workrate Variability SD for Test Validity
  workrate_variability_sd <- sd(workrate_variability),
  
  ## Workrate Variability Graph
  workrate_variability_graph <- ggplot(corrected_data(), aes(x = t))+
    geom_point( aes(y=workrate_variability), size = 1) +
    ylab("Power Variability (Watts)") +
    xlab("Time (s)") +
    ggtitle("Corrected Work vs. Raw Work Distribution") +
    # scale_y_continuous("Power (Watts)",
    #                    breaks = seq(watts_range_start, watts_range_end, watts_minor_tick),
    #                    limits=c(watts_range_start, watts_range_end)) +
    theme_classic()
  
)