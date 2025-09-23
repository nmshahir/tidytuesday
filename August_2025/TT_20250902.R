library(tidyverse)
library(ggplot2)
library(broom)
library(gt)
library(ggsci)
library(ggsci)
library(hrbrthemes)
library(viridis)
library(forcats)

#Geocomp packages
library(sf)
library(terra)
library(dplyr)
library(spData)
library(spDataLarge)
library(tmap)
library(leaflet)
frogID_data <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-09-02/frogID_data.csv')
frog_names <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-09-02/frog_names.csv')

#Let's join these two data frames on "scientificName"

frogID_data_count <- frogID_data %>%
  left_join(frog_names, by = "scientificName", relationship = "many-to-many") %>%
  group_by(stateProvince, eventDate) %>%
  summarize(num_of_sightings = n())

#Maybe a time heatmap of frog observations for each province by day? 

# #Update slight problem, there are some OVERLAPS so this needs some cleaning
# space_test <- frogID_names %>%
#     filter(str_detect(scientificName," "))