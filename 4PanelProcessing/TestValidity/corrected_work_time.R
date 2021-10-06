list(
  source("Raw4PanelPlots/raw_plot.R", local = TRUE),

  watts_time_graph <- ggplot(cleaned_data(), aes(x = t))+
    geom_point( aes(y=Power), size = 1) +
    scale_y_continuous("Power (Watts)",
                       breaks = seq(watts_range_start, watts_range_end, watts_minor_tick),
                       limits=c(watts_range_start, watts_range_end)) +
    theme_classic(), 
    # + scale_x_datetime(date_labels = "%H:%M"),
  
  # Graph that compares corrected time and corrected work with each other.
  
  corrected_time_graph <- ggplot(corrected_data(), aes(x = t))+
    geom_point( aes(y=Power), color= "#D35400", size = 1) +
    scale_y_continuous("Power (Watts)",
                       breaks = seq(watts_range_start, watts_range_end, watts_minor_tick),
                       limits = c(watts_range_start, watts_range_end)) +
    theme_classic(), 
    # + scale_x_datetime(date_labels = "%H:%M"),
  
  plot_test_validity <- plot_grid(watts_time_graph, corrected_time_graph, ncol = 2, align = "h", nrow = 1)
)