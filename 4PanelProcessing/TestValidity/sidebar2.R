list(
    h2("Raw Data Analysis (Linear Regression)"),
    em("The information below refers to data populated from the raw cosmed output of Watts vs. Time. 
       None of the information is from the result of data correction."),
    br(),
    strong("Intercept: "), textOutput("output4"),
    strong("Slope: "), textOutput("output5"),
    strong("Effective Ramp: "), textOutput("effective_ramp"),
    strong("R^2: "), textOutput("output6"),
    br(),
    
    h2("Results of Test Validity: "),
    strong("Work Controller Test Validity: "), textOutput("raw_testcontroller_validity"),
    br(),
    strong("Work Controller Ramp Test Validity: "), textOutput("workrate_variability_validity"),
    br(),
    strong("Test Duration Test Validity: "), textOutput("ramp_duration_validity"),
    br()
    
)