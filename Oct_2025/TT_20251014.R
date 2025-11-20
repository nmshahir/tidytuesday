# Upload libraries that I may or may not use
library(tidyverse)
library(ggplot2)
library(broom)
library(gt)
library(ggsci)
library(ggsci)
library(hrbrthemes)
library(viridis)
library(forcats)

food_security <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-10-14/food_security.csv')
area_list <- unique(food_security$Area)

regional_terms <- area_list[206:length(area_list)]

food_security_missingness <- food_security |>
  filter(!(Area %in% regional_terms)) 