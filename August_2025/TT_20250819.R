
library(tidyverse)
library(ggplot2)
library(gganimate)
library(broom)
library(gt)
install.packages("ggsci")
library(ggsci)
library(hrbrthemes)
library(viridis)
library(forcats)

scottish_munros <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-08-19/scottish_munros.csv')

