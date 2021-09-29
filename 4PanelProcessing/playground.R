col_names <- array(read_excel("/Users/apurvashah/Downloads/David-Gomez.xlsx", sheet = 1, n_max = 1, col_names = FALSE))
rawdata <- data.frame(read_excel("/Users/apurvashah/Downloads/David-Gomez.xlsx", sheet = 1, skip = 3, col_names = FALSE))
colnames(rawdata) <- col_names
convert_data1 <- rawdata
wbb1 <- convert_data1 %>% select(10:36) # The Dataframe that includes all of the key variables required for data manipulation.

time.watts.lm <- lm(wbb1$t ~ wbb1$Power, data = wbb1)
intercept <- summary(time.watts.lm)$coef[[1]]
slope <- summary(time.watts.lm)$coef[[2]]

corrected_time_differential <- (0-intercept)/slope

warmup_index <- c()
for(i in 1:length(wbb1$Power)) {
  warmup_index <- c(warmup_index, i)
}

