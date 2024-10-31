library(tidyverse)
library(ggplot2)
library(httpgd)
library(ggpubr)
library(ggtext)
library(ggsignif)

hgd(port = 8067)
hgd_browse()

dir = dirname(getSourceEditorContext()$path)
data <- read.csv(paste0(dir, "/bedroc80_cheese_chaput2016.csv"))

numeric_cols <- sapply(data, is.numeric)
method_cols <- names(data)[numeric_cols]

data_long <- data %>%
  pivot_longer(cols = all_of(method_cols), 
               names_to = "Method", 
               values_to = "BEDROC")

alpha <- 80.5
random_bedroc <- (1 - exp(-alpha)) / alpha

# Sort data_long Method cols by median value
data_long_ordered <- data_long %>%
  group_by(Method) %>%
  mutate(Median = median(BEDROC)) %>%
  ungroup() %>%
  mutate(Method = fct_reorder(Method, Median, .desc = TRUE))

# Function to format method names
format_method <- function(x) {
  gsub("\\.", "<br>", x)
}

# Calculate pairwise significance
methods <- levels(data_long_ordered$Method)
pairwise_tests <- list()

for (i in 1:(length(methods)-1)) {
  pairwise_tests[[i]] <- c(methods[i], methods[i+1])
}

ggplot(data_long_ordered, aes(x = Method, y = BEDROC, fill = Method)) +
  geom_boxplot(outlier.shape = NA) +
  #geom_jitter(width = 0.05, alpha = 0.5) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.x = element_markdown(size = 12, angle = 0, hjust = 0.5),
    panel.grid.minor = element_blank(),
    legend.position = "none"
  ) +
  labs(title = "DUD-E Benchmark Performance",
       subtitle = paste0("BEDROC  α=80.5 (n=", nrow(data), ")"),
       y = "BEDROC", x = "") +
  scale_x_discrete(labels = format_method)