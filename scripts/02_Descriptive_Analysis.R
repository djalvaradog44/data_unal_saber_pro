library(tidyverse)
library(here)
library(janitor)

library(readr)

clean_data <- read.csv(here("data", "processed", "cleaned_data.csv"))

#check the structure of the data
str(clean_data)

#store the quantitative variables to study
quant_vars <- c("PUNTAJE_GLOBAL", "PUNT_COMP_CIUD", "PUNT_COMU_ESCR", "PUNT_INGLES", "PUNT_LECT_CRIT", "PUNT_RAZO_CUANT")

numeric_summary <- clean_data %>%
  select(all_of(quant_vars)) %>%
  pivot_longer(everything(), names_to = "variable") %>%
  group_by(variable) %>%
  reframe(
    mean = mean(value, na.rm = TRUE),
    median = median(value, na.rm = TRUE),
    sd = sd(value, na.rm = TRUE),
    variance = var(value, na.rm = TRUE),
    min = min(value, na.rm = TRUE),
    max = max(value, na.rm = TRUE),
    q1 = quantile(value, 0.25, na.rm = TRUE),  # 25th percentile
    q3 = quantile(value, 0.75, na.rm = TRUE),  # 75th percentile
    n = n()
  )
print(numeric_summary)

write_csv(numeric_summary, here("data", "processed", "summary_puntaje.csv"))
