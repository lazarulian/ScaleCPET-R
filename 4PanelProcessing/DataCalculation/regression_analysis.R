## Piecewise Regression Analysis

list(
  ## Converting Data to Compatible Format
  VE_data <- cleaned_data()$VE,
  VCO2_data <- cleaned_data()$VCO2,

  panel_3 <- lm(VE_data~VCO2_data, data = cleaned_data()),
  seg<- segmented(panel_3, seg.Z=~VCO2_data),
  vco2_theta <- seg$psi,
  vco2_theta <- vco2_theta[2],
  slopes_vco2ve <- slope(seg),
  lowersegment_venteff <- round(slopes_vco2ve$VCO2_data[1], 0),
  fitted_vco2ve <- fitted(seg),
  vco2ve_segmented <- data.frame(VCO2 = VCO2_data, VE = fitted_vco2ve)
  
)