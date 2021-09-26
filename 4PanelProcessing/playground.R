col_names <- array(read_excel("/Users/apurvashah/OneDrive/Extracurriculars/UC-FitLab/PlotsProject/VO2 Max Testing Data/Watts/David-Gomez 9-15-21.xlsx", sheet = 1, n_max = 1, col_names = FALSE))
rawdata <- data.frame(read_excel("/Users/apurvashah/OneDrive/Extracurriculars/UC-FitLab/PlotsProject/VO2 Max Testing Data/Watts/David-Gomez 9-15-21.xlsx", sheet = 1, skip = 3, col_names = FALSE))
colnames(rawdata) <- col_names
convert_data1 <- rawdata
wbb1 <- convert_data1 %>% select(11:36) # The Dataframe that includes all of the key variables required for data manipulation.

warmup_index <- c()
for(i in 1:length(wbb1$Power)) {
  if (wbb1$Power[i] < 10) {
    warmup_index <- c(warmup_index, i)
  }
  else {
    next
  }
}

for(i in 1:length(warmup_index)) {
  wbb1[-c(warmup_index[i]),]
}