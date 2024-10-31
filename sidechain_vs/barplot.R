# Load required libraries
library(ggplot2)
library(reshape2)
library(viridis)
library(httpgd)
library(rstudioapi)
library(dplyr)
library(ggtext)
library(ggsignif)

dir = dirname(getSourceEditorContext()$path)


hgd()
hgd_browse()

# Read the CSV data
data <- read.csv(paste0(dir,"/roc_mean.csv"))

plot_data <- data %>%
  tidyr::pivot_wider(names_from = kind, values_from = value) %>%
  arrange(desc(mean)) %>%
  mutate(variable = factor(variable, levels = unique(variable)))
plot_data

format_method <- function(x) {
  gsub(" ", "\n", x)
}

# Create the plot
ggplot(plot_data, aes(x = variable, y = mean, fill = variable)) +
  geom_bar(stat = "identity", position = position_dodge()) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), 
                width = 0.2, position = position_dodge(0.9)) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.y = element_text(),
    panel.grid.minor = element_blank(),
    axis.title = element_text(),
    axis.title.x = element_blank(),
    legend.position = "none"
  ) +
  labs(title = "Performance in Sidechain Virtual Screening",
       subtitle = "Mean ROC AUC with Standard Deviation (n=402)",
       y = "ROC AUC") +
  scale_x_discrete(labels = format_method)+
  coord_cartesian(ylim = c(0, max(plot_data$mean + plot_data$sd) * 1.1)) +
  scale_fill_brewer(palette = "Set2")
