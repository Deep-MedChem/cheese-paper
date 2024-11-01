library(tidyverse)
library(ggplot2)
library(httpgd)
library(ggpubr)
library(rstudioapi)
hgd(port = 8067)
hgd_browse()

dir = dirname(getSourceEditorContext()$path)

# Function to calculate medians and sort methods
sort_by_median <- function(data) {
  medians <- data %>%
    group_by(Pooling_Method) %>%
    summarise(median_val = median(EF1)) %>%
    arrange(median_val)
  
  data %>%
    mutate(Pooling_Method = factor(Pooling_Method, levels = medians$Pooling_Method))
}

# Process and create plot for ESPSim
data_esp <- read.csv(paste0(dir, "/pooling_espsim.csv")) %>%
  sort_by_median()

# discard median similarity, Quantile, Attention, Soft Chamfer from Pooling_Method
data_esp <- data_esp %>%
  filter(Pooling_Method != "Median Similarity",
         Pooling_Method != "Quantile",
         Pooling_Method != "Attention",
         Pooling_Method != "Soft Chamfer Similarity")

p_esp <- ggplot(data_esp, aes(x = EF1, y = Pooling_Method)) +
  geom_boxplot(outlier.shape = NA) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.y = element_text(size = 12),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    strip.text = element_text(size = 14, face = "bold")
  ) +
  labs(title = "Batch Espsim",
       x = "EF1",
       y = "") +
  coord_cartesian(xlim = c(0, 10))

# Process and create plot for ShapeSim
data_shape <- read.csv(paste0(dir, "/pooling_shapesim.csv")) %>%
  sort_by_median()

data_shape <- data_shape %>%
  filter(Pooling_Method != "Median Similarity",
         Pooling_Method != "Quantile",
         Pooling_Method != "Attention",
         Pooling_Method != "Soft Chamfer Similarity")


p_shape <- ggplot(data_shape, aes(x = EF1, y = Pooling_Method)) +
  geom_boxplot(outlier.shape = NA) +
  theme_minimal(base_size = 14) +
  theme(
    axis.text.y = element_text(size = 12),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.x = element_blank(),
    strip.text = element_text(size = 14, face = "bold")
  ) +
  labs(title = "Batch Shapesim",
       x = "EF1",
       y = "") +
  coord_cartesian(xlim = c(0, 10))

# Arrange plots vertically
ggarrange(p_esp, p_shape, 
          ncol = 1, 
          heights = c(1, 1))

# get EF1 medians in data_shape for all Pooling_Methods
medians_shape <- data_shape %>%
  group_by(Pooling_Method) %>%
  summarise(median_val = median(EF1)) %>%
  arrange(median_val)

medians_esp <- data_esp %>%
  group_by(Pooling_Method) %>%
  summarise(median_val = median(EF1)) %>%
  arrange(median_val)

write.csv(medians_shape, paste0(dir, "/batch_pooling_median_esp.csv"), row.names = FALSE)
write.csv(medians_esp, paste0(dir, "/batch_pooling_median_shape.csv"), row.names = FALSE)

