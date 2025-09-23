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

billboard <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-08-26/billboard.csv')
topics <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-08-26/topics.csv')

#This week lets try sentiment analysis over the years. That means we need to assign sentiment to each topic
# the lyrical_topic column in billboard gives the topic of the song