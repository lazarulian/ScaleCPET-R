## Piecewise Regression Analysis

list(
  ## Converting Data to Compatible Format
  # source("TestValidity/linearity_machine.R", local = TRUE),

  find_value_series <- function(data_range, data_value) {
    for (i in 1:length(data_range)) {
      if (data_range[i] == data_value) {
        the_index <- i
      }
    }
  }, ## End Function
  
  find_value_positive <- function(data_range) {
    counter <- 0
    for (i in 1:length(data_range)) {
      if (data_range[i] > 0) {
        counter <- counter + 1
        if (counter > 5) {
          the_index <- i
          break
        }
      }
      else {
        counter <- 0
      }
    }
    return(the_index)
  }, ## End Function
  
  distribution_machine_data <- function(range_x, range_y, dataset) {
    
    data_summary <- lm(range_y ~ range_x, data = dataset)
    data_intercept <- summary(data_summary)$coef[[1]]
    data_slope <- summary(data_summary)$coef[[2]]
    
    corrected_data <- ((range_x)*data_slope)+data_intercept
    corrected_data <- as.numeric(corrected_data)
    
    variability <- corrected_data-range_y
    
    return(variability)
  },

  ## Segmented Regression Graph 4
  VE_data <- cleaned_data()$VE,
  VCO2_data <- cleaned_data()$VCO2,

  panel_3 <- lm(VE_data~VCO2_data, data = cleaned_data()),
  seg<- segmented(panel_3, seg.Z=~VCO2_data),
  vco2_theta <- seg$psi,
  vco2_theta <- vco2_theta[2],
  vco2_theta_index <- find_value_series(cleaned_data()$VCO2, vco2_theta),
  slopes_vco2ve <- slope(seg),
  lowersegment_venteff <- round(slopes_vco2ve$VCO2_data[1], 0),
  fitted_vco2ve <- fitted(seg),
  vco2ve_segmented <- data.frame(VCO2 = VCO2_data, VE = fitted_vco2ve),

## Segmented Regression for Graph 2
  
  wbb1 <- cleaned_data(),
  wbb1<- wbb1[!wbb1$VCO2 > vco2_theta,], # Removes Warmup Data
  
  ## Removing the Lower End of the Data
  dist_data_values <- distribution_machine_data(wbb1$t, wbb1$RQ, wbb1),
  index_removal <- find_value_positive(dist_data_values),
  vco2_2 <- wbb1$VCO2,
  vo2_2 <- wbb1$VO2,
  
  vo2_2 <- vo2_2[-c(1:index_removal)],
  vco2_2 <- vco2_2[-c(1:index_removal)],
  dummy_df <- data.frame(vo2 = vo2_2, vco2 = vco2_2),
  # plot(wbb1$VO2, wbb1$VCO2)
  
  panel_2 <- lm(formula = vco2~vo2, data = dummy_df),
  
  my.seg <- segmented(panel_2, seg.Z = ~ vo2_2),
  # my.seg$psi,
  vo2theta <- round(my.seg$psi[2], 2),
  vo2_slopes <- slope(my.seg),
  lowersegment_meteff <- round(slopes_vco2ve$VCO2_data[2], 0),
  fitted_vo2 <- fitted(my.seg),
  vo2_segmented <- data.frame(VO2 = vo2_2, VCO2 = fitted_vo2),
  metabolic_efficiency <- lm(vo2_segmented)$coefficients[2],
  metabolic_efficiency <- round(metabolic_efficiency, 2),
  new_var_rounded <- toString(metabolic_efficiency)

)