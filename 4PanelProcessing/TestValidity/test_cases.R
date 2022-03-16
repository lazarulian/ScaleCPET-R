## Test_Cases

list(
source("TestValidity/erroneous_hr.R", local = TRUE)[1],
source("TestValidity/metabolic_efficiency_validity.R", local = TRUE)[1],
source("TestValidity/ramp_duration_validity.R", local = TRUE)[1],
source("TestValidity/workcontroller_validity.R", local = TRUE)[1],
source("TestValidity/vco2theta_validity.R", local = TRUE)[1],

passed <- vco2_pass + erroneous_pass + rampdur_pass + workvar_pass + 
  workcontroller_pass + meteff_pass,
failed <- vco2_fail + erroneous_fail + rampdur_fail + workvar_fail + 
  workcontroller_fail + meteff_fail

)