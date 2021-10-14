list(
  
  linearity_machine <- function(range_x, range_y, dataset) {
  source("Raw4PanelPlots/axes_scaling.R", local = TRUE)[1]
  data_summary <- lm(range_y ~ range_x, data = dataset)
  data_intercept <- summary(data_summary)$coef[[1]]
  data_slope <- summary(data_summary)$coef[[2]]
  
  corrected_data <- ((range_x)*data_slope)+data_intercept
  corrected_data <- as.numeric(corrected_data)
  
  p1 <- ggplot(dataset, aes(x = range_x))+
    geom_point( aes(y=range_y), size = 1) +
    theme_classic()
  
  p2 <- ggplot(dataset, aes(x = range_x))+
    geom_point( aes(y=corrected_data), color= "red", size = 1) +
    theme_classic()
  
  grid_output <- plot_grid(p1, p2, ncol = 2, align = "h", nrow = 1)
  
  return(grid_output)
},

distribution_machine <- function(range_x, range_y, dataset) {
  
  data_summary <- lm(range_y ~ range_x, data = dataset)
  data_intercept <- summary(data_summary)$coef[[1]]
  data_slope <- summary(data_summary)$coef[[2]]
  
  corrected_data <- ((range_x)*data_slope)+data_intercept
  corrected_data <- as.numeric(corrected_data)
  
  variability <- corrected_data-range_y
  
  variability_graph <- ggplot(dataset, aes(x = range_x))+
    geom_point( aes(y=variability), color = "blue", size = 1) +
    theme_classic()
  
  return(variability_graph)
}

)