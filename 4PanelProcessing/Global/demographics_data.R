# demographics_data

list(
  req(input$file1), # Requests Data from Input
  last_name <- read_excel(input$file1$datapath, range = "B2", col_names = FALSE),
  last_name <- toString(last_name),
  
  first_name <- read_excel(input$file1$datapath, range = "B3", col_names = FALSE),
  first_name <- toString(first_name),
  
  sex <- read_excel(input$file1$datapath, range = "B4", col_names = FALSE),
  sex <- toString(sex),
  
  age <- read_excel(input$file1$datapath, range = "B5", col_names = FALSE),
  age <- as.numeric(age),

  height <- read_excel(input$file1$datapath, range = "B6", col_names = FALSE),
  height <- as.numeric(height),

  weight <- read_excel(input$file1$datapath, range = "B7", col_names = FALSE),
  weight <- as.numeric(weight),
  
  id <- read_excel(input$file1$datapath, range = "B1", col_names = FALSE),
  id <- as.numeric(id),
  
  bmi <- weight/(height/100)^2,
  bmi <- as.numeric(bmi),
  
  # Ideal Body Weight Calculation
  if (sex == "Male") {
    ibw <- 71.6*(height/100)-51.8
  }
  else {
    ibw <- 62.6*(height/100)-45.5
  },
  
  # Reference BMI Calculation
  rbmi <- ibw/(height/100)^2,
  rbmi <- as.numeric(rbmi)

)