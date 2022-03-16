## AXT Codebook Global
## Outputs the codebook for the variables in the AXT report that is generated.
list(
# Variable Declarations That Help with TextTransformation
a<-2,
b<-2,
c<-"max",
e<- "E",
f <- "C",
g <- "cap",

## Explanations to be Passed into GT
axt_explanations <- c("Maximum work rate achieved (Panel 1)",
                      glue("Slope of the relationship between VO@{2}~ and work rate (Panel 1)"), 
                      "Maximum oxygen uptake measured (Panels 1 and 3)",
                      "Maximum oxygen uptake measured divided by actual body weight (Panels 1 and 3)", 
                      glue("Inflection in the relationship between VCO@{2}~ and VO@{2}~ (Panel 2)"), 
                      glue("Lower slope of the relationship between VCO@{2}~ and VO@{2}~ (Panel 2)"), 
                      "Maximum heart rate achieved (Panel 3)",
                      glue("Slope of the relationship between f@{f}~ and VO@{2}~ (Panel 3)"), 
                      "Maximum ventilation achieved (Panel 4)",
                      glue("Inflection in the relationship between V@{e}~ and VCO@{2}~ (Panel 4)"), 
                      glue("Lower slope of the relationship between VCO@{2}~ and VO@{2}~ (Panel 4)")),

## THE GT TABLE

gt_axtcodebook <- tibble('Variable' = c(glue("Work Rate @{c}~ (watts)"), "Metabolic Efficiency (ml/min/watt)", 
                                      glue("VO@{2}~ @{c}~ (ml/kg/min)"), glue("VO@{2}~ @{c}~ (L/min)"), 
                                      glue("VO@{2}~\U03B8,  LLN (L/min)"), "Muscle RQ",
                                      glue("f@{f}~ @{c}~ (/min)"), "Chronotropic Index (/L)",
                                      glue("V@{e}~ @{c}~, V@{e}~ @{g}~ (L/min)"), glue("VCO@{2}~\U03B8 (L/min)"), "Ventilatory Efficiency"),
                       
                       `Explanation` = axt_explanations) %>% 
  gt() %>%
  # Style header font
  gt::tab_style(
    style = list(
      cell_text(weight = "bold")
    ),
    locations = list(
      cells_column_labels(gt::everything())
    )
  )%>%
  gt::tab_style(
    style = list(
      cell_borders(
        side = c("left"), 
        color = "grey",
        weight = px(2)
      )
    ),
    locations = cells_body(
      columns = c(Explanation)
    )
  ) %>%
  cols_align(
    align = "right",
    columns = Explanation) %>%
  tab_row_group(
    label = md("**Ventilatory Response**"),
    rows = 9:11
  ) %>%
  tab_row_group(
    label = md("**Cardiovascular Performance**"),
    rows = 7:8
  ) %>%
  tab_row_group(
    label = md("**Aerobic Performance**"),
    rows = 3:6
  ) %>%
  tab_row_group(
    label = md("**Energetics**"),
    rows = 1:2
  ) %>%
  tab_header(
    title = md("**CodeBook for AXT**"))%>%
  text_transform(
    locations = cells_body(),
    fn = function(x) {
      str_replace_all(x,
                      pattern = "@",
                      replacement = "<sub>") %>% 
        str_replace_all("~",
                        "</sub>")}
  )
)