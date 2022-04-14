# init.R
#
# Example R code to install packages if not already installed
#

my_packages = c("shiny", "shinydashboard", "tidyverse", "ggpubr", "car",
                "ggplot2", "readxl", "zoo", "rmarkdown", "remotes", "gt", "glue", "stringr", "patchwork", "segmented", "DT", "shinyjs", "sodium")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

invisible(sapply(my_packages, install_if_missing))