library(tidyverse)
library(ggplot2)
library(httpgd)
library(ggpubr)
library(ggridges)
library(rstudioapi)
hgd(port = 8067)
hgd_browse()

dir = dirname(getSourceEditorContext()$path)
data <- read.csv(paste0(dir, "/espsim_distributions_combined.csv"))
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
  "cheese" = "CHEESE Espsim",
  "random" = "Random",
  "fingerprints" = "Morgan Fingerprints"
)

data$distribution <- factor(data$distribution, 
                         levels = names(names_mapping),
                         labels = names_mapping)

data$metric <- factor(data$metric, 
                         levels = names(metric_mapping),
                         labels = metric_mapping)


# Calculate the number of targets in each class
class_counts <- data %>%
  group_by(distribution) %>%
  summarise(count = n())

# sort data_long by class counts
data_long <- data %>%
  group_by(distribution) %>%
  mutate(Count = n()) %>%
  ungroup() %>%
  mutate(distribution = fct_reorder(distribution, Count, .desc = TRUE))

# Calculate significance
data_wide <- data_long %>%
  pivot_wider(names_from = distribution, values_from = value)

# First, modify the factor levels to change the order
data_long$metric <- factor(data_long$metric, 
                          levels = rev(c("Random", "Morgan Fingerprints", "CHEESE Espsim")))

# Calculate medians
medians_df <- data_long %>%
  group_by(distribution, metric) %>%
  summarise(median = median(value), .groups = 'drop')

ggplot(data_long, aes(x = value, y = metric, fill = metric, color = metric)) +
  geom_density_ridges(alpha = 0.5, scale = 2) +
  facet_wrap(~ distribution, scales = "free_x", nrow = 3, 
             labeller = labeller(distribution = function(x) {
               counts <- class_counts$count[match(x, class_counts$distribution)]
               paste0(x, "\n(N=", counts, ")")
             })) +
  theme_minimal(base_size = 14) +
  theme(
    strip.text = element_text(size = 12),
    legend.position = "bottom",
    legend.justification = "center",
    legend.box.just = "center",
    legend.margin = margin(t = 10, b = 10),
    legend.direction = "horizontal",
    legend.title = element_blank(),
    axis.text.y = element_blank(),  # Remove y-axis labels
    axis.ticks.y = element_blank()  # Remove y-axis ticks
  ) +
  labs(title = "Retrieval Distributions Across Chemical Databases",
       subtitle = "Ground Truth Espsim over 100 queries",
       y = "", x = "Espsim")
