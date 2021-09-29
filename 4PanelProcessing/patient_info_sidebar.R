#corrected_4panel_sidebar
list(
  h2("Patient Demographics: "),
  strong("Last Name: "), textOutput("last_name"),
  strong("First Name: "), textOutput("first_name"),
  strong("Sex: "), textOutput("sex"),
  strong("Age: "), textOutput("age"),
  strong("Weight: "), textOutput("weight"),
  strong("Height: "), textOutput("height")
)