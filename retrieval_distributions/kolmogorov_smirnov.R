library(tidyverse)
library(ggplot2)
library(httpgd)
library(ggpubr)
library(rstudioapi)

dir = dirname(getSourceEditorContext()$path)
data <- read.csv(paste0(dir, "/shapesim_distributions_combined.csv"))
# data head and column names
head(data)
colnames(data)
unique(data$distribution)

names_mapping <- c(
  "chembl_34" = "ChEMBL 34",
  "drugbank_5" = "DrugBank 5",
  "enamine_diverse_2024" = "Enamine Diverse 2024",
  "freedom_diverse_2024" = "Freedom Diverse 2024",
  "eXplore_diverse_2024" = "eXplore Diverse 2024",
  "chemriya" = "CHEMRIYA 1.2",
  "GDB17" = "GDB17",
  "pubchem_2024" = "PubChem 2024",
  "SureChEMBL_2024" = "SureChEMBL 2024",
  "zinc22" = "ZINC22",
  "chebi" = "ChEBI",
  "coconut" = "COCONUT",
  "foodb_2024" = "FooDB"
)

metric_mapping <- c(
  "cheese" = "CHEESE Shapesim",
  "random" = "Random",
  "fingerprints" = "Morgan Fingerprints"
)

data$distribution <- factor(data$distribution, 
                         levels = names(names_mapping),
                         labels = names_mapping)

data$metric <- factor(data$metric, 
                         levels = names(metric_mapping),
                         labels = metric_mapping)


# sort data_long by class counts
data_long <- data %>%
  group_by(distribution) %>%
  mutate(Count = n()) %>%
  ungroup() %>%
  mutate(distribution = fct_reorder(distribution, Count, .desc = TRUE))


# Function to perform KS test and format results
perform_ks_test <- function(data, database) {
  # Filter data for the specific database
  db_data <- data %>% filter(distribution == database)
  
  # CHEESE vs Random
  cheese_data <- db_data %>% filter(metric == "CHEESE Shapesim") %>% pull(value)
  random_data <- db_data %>% filter(metric == "Random") %>% pull(value)
  morgan_data <- db_data %>% filter(metric == "Morgan Fingerprints") %>% pull(value)
  
  # Perform KS tests
  ks_cheese_random <- ks.test(cheese_data, random_data)
  ks_cheese_morgan <- ks.test(cheese_data, morgan_data)
  
  # Return results in a data frame
  data.frame(
    database = database,
    cheese_vs_random_D = ks_cheese_random$statistic,
    cheese_vs_random_p = ks_cheese_random$p.value,
    cheese_vs_morgan_D = ks_cheese_morgan$statistic,
    cheese_vs_morgan_p = ks_cheese_morgan$p.value
  )
}

# Perform KS tests for all databases
ks_results <- map_df(unique(data_long$distribution), ~perform_ks_test(data_long, .x))

# Format results for presentation
ks_results_formatted <- ks_results %>%
  mutate(
    across(ends_with("_p"), ~sprintf("%.3e", .)),
    across(ends_with("_D"), ~round(., 3))
  ) %>%
  arrange(desc(cheese_vs_random_D))

# Print results
print(ks_results_formatted)

# Calculate effect size summary statistics
effect_size_summary <- ks_results %>%
  summarise(
    mean_effect_vs_random = mean(cheese_vs_random_D),
    sd_effect_vs_random = sd(cheese_vs_random_D),
    mean_effect_vs_morgan = mean(cheese_vs_morgan_D),
    sd_effect_vs_morgan = sd(cheese_vs_morgan_D)
  ) %>%
  mutate(across(everything(), ~round(., 3)))

print("Effect Size Summary:")
print(effect_size_summary)

# Optionally, save results to a CSV
write.csv(ks_results_formatted, "ks_shapesim_results.csv", row.names = FALSE)
