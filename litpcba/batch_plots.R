# Load required libraries
library(ggplot2)
library(reshape2)
library(viridis)
library(httpgd)
library(rstudioapi)
library(dplyr)
library(ggtext)
library(ggsignif)
library(forcats)

dir = dirname(getSourceEditorContext()$path)


hgd()
hgd_browse()

# Read the CSV data
data <- read.csv(paste0(dir,"/batch_ef1_litpcba.csv"))
# reverse column order
data <- data[,ncol(data):1]

# Melt the data for ggplot2
melted_data <- melt(data, id.vars = "Target")

# Function to categorize values
categorize_value <- function(x) {
  case_when(
    x > 10 ~ ">10",
    x > 5 ~ "5-10",
    x > 2 ~ "2-5",
    x > 1 ~ "1-2",
    TRUE ~ "0-1"
  )
}

# Apply categorization
melted_data$category <- factor(categorize_value(melted_data$value),
                               levels = c("0-1", "1-2", "2-5", "5-10", ">10"))


format_method <- function(x) {
  gsub("\\.", "\n", x)
}

format_targets <- function(x) {
  gsub("_", "\n", x)
}

# HEATMAP
ggplot(melted_data, aes(y = variable, x = format_targets(Target), fill = category)) +
  geom_tile(color = "white") +
  scale_fill_manual(name = "EF1%",
                    values = c("0-1" = "#E8F4F8",
                               "1-2" = "#B7E0F1",
                               "2-5" = "#98D1A9",
                               "5-10" = "#F2D06B",
                               ">10" = "#8B4513")) +
  theme_minimal() +
  theme(
    axis.text.y = element_text(),
    axis.title = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.position = "right"
  ) +
  scale_y_discrete(labels = format_method) +
  coord_fixed()

#BOXPLOT
melted_data_continuous <- melt(data, id.vars = "Target")
# now discard the Target column
melted_data_continuous <- melted_data_continuous[,c(2,3)]
# sort by mean
melted_data_continuous <- melted_data_continuous %>%
  group_by(variable) %>%
  mutate(Mean = median(value)) %>%
  ungroup() %>%
  mutate(variable = fct_reorder(variable, Mean, .desc = TRUE))


ggplot(melted_data_continuous, aes(y = value, x = variable, fill = variable)) +
  geom_boxplot(outlier.shape = NA, outliers = FALSE) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.y = element_text(),
    panel.grid.minor = element_blank(),
    axis.title = element_text(),
    axis.title.x = element_blank(),
    legend.position = "none"
  ) +
  labs(title = "Lit-PCBA Benchmark Performance",
       subtitle = paste0("EF1% (n = ", nrow(data), ")"),
       y = "EF1%", x = "") +
  scale_x_discrete(labels = format_method) +
  scale_y_continuous(
    labels = function(x) paste0(x/10, "0"),
    breaks = seq(0, max(melted_data_continuous$value), by = 10),
    expand = expansion(mult = c(0, 0.05))
  ) +
  coord_cartesian(clip = "off")

