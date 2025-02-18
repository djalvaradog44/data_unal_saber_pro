library(tidyverse)
library(janitor)
library(here)
library(readr)

library(skimr)

raw_data <- read_csv(here("data", "raw", "Microdatos_Resultados_Prueba_Saber_Pro_UNAL_20250218.csv"))

glimpse(raw_data)

skim(raw_data) ##works similar to summary but helps by giving more information for each variable

clean_data <- raw_data %>%
  mutate(across(where(is.character), as.factor)) %>%
  
  #In case there were any empty rows or cols, will remove them
  remove_empty(c("rows", "cols")) %>%
  
  #in case of any duplicate rows, remove them
  distinct()


colSums(is.na(clean_data)) # no missing values per column

#convert PBM, Edad and Year to factor

clean_data <- clean_data %>%
  mutate(across(c("PBM", "EDAD", "YEAR"), as.factor))

clean_data <- clean_data %>%
  filter(if_all(c(PUNT_RAZO_CUANT, PUNT_LECT_CRIT, PUNT_INGLES, 
                  PUNT_COMU_ESCR, PUNT_COMP_CIUD),
                ~ .x > 0))

skim(clean_data)

levels(clean_data$PBM)

write_csv(clean_data, here("data", "processed", "cleaned_data.csv"))
