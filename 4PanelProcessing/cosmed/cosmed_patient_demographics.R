# Cosmed Patient Demographics

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
  height <- as.numeric(height/100),
  
  weight <- read_excel(input$file1$datapath, range = "B7", col_names = FALSE),
  weight <- as.numeric(round(weight, 1)),
  
  id <- read_excel(input$file1$datapath, range = "B1", col_names = FALSE),
  id <- as.numeric(id),
  
  date_of_study <- read_excel(input$file1$datapath, range = "E1", col_names = FALSE),
  date_of_study <- toString(date_of_study)
  
)