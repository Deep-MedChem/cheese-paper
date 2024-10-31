library(tidyverse)
library(ggplot2)
library(httpgd)
library(ggpubr)
library(ggtext)
library(ggsignif)
library(rstudioapi)

hgd(port = 8067)
hgd_browse()

dir = dirname(getSourceEditorContext()$path)
data <- read.csv(paste0(dir, "/bedroc80_cheese_chaput2016.csv"))

# Reshape the data from wide to long format
numeric_cols <- sapply(data, is.numeric)
method_cols <- names(data)[numeric_cols]

data_long <- data %>%
  pivot_longer(cols = all_of(method_cols), 
               names_to = "Method", 
               values_to = "BEDROC")

# Calculate the number of targets in each class
class_counts <- data %>%
  group_by(Family) %>%
  summarise(count = n())



# sort data_long by class counts
data_long <- data_long %>%
  group_by(Family) %>%
  mutate(Count = n()) %>%
  ungroup() %>%
  mutate(Family = fct_reorder(Family, Count, .desc = TRUE))


# Sort data_long Method cols by median value
data_long <- data_long %>%
  group_by(Method) %>%
  mutate(Median = median(BEDROC)) %>%
  ungroup() %>%
  mutate(Method = fct_reorder(Method, Median, .desc = TRUE))


# Calculate significance
data_wide <- data_long %>%
  pivot_wider(names_from = Method, values_from = BEDROC)

format_method <- function(x) {
  gsub("\\.", " ", x)
}
data_long$Method = format_method(data_long$Method)

alpha <- 80.5
random_bedroc <- (1 - exp(-alpha)) / alpha

# Create the improved boxplot
ggplot(data_long, aes(x = Method, y = BEDROC, fill = Method)) +
  geom_boxplot() +
  #geom_jitter(width = 0.05, alpha = 0.5) +
  facet_wrap(~ Family, scales = "free_x", nrow = 2, 
             labeller = labeller(Family = function(x) {
               counts <- class_counts$count[match(x, class_counts$Family)]
               paste0(x, "\n(N=", counts, ")")
             })) +
  theme_minimal(base_size = 14) +  # Increase base font size
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    strip.text = element_text(size = 12),
    legend.position = "bottom",  # Move legend to bottom
    legend.justification = "center",  # Center the legend
    legend.box.just = "center",
    legend.margin = margin(t = 10, b = 10),  # Add some vertical margin
    legend.direction = "horizontal",  # Ensure legend is horizontal
    legend.title = element_blank()
  ) +
  labs(title = "DUD-E by Target Family",
       subtitle = paste0("BEDROC α=", alpha, " (n=", nrow(data), ")"),
       y = "BEDROC", x="")

