library(tidyverse)
library(ggplot2)
library(broom)
library(gt)
library(ggsci)
library(ggsci)
library(hrbrthemes)
library(viridis)
library(forcats)

euroleague_basketball <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-10-07/euroleague_basketball.csv')
euroleague_basketball_ave_arena <- euroleague_basketball |>
  separate_rows(Capacity, sep=", ") |>
  select(c(Country, Capacity, FinalFour_Appearances)) |>
  mutate(Capacity = parse_number(Capacity)) |>
  group_by(Country) |>
  summarise(ave_arena_capacity = mean(Capacity))

euro_city_arena <- euroleague_basketball_ave_arena

EL_arena_final_four <- euroleague_basketball |>
  left_join(euro_city_arena, by = "Country") |>
  ggplot(aes(x = FinalFour_Appearances, y = ave_arena_capacity, col = Country, size = (Titles_Won + 1))) +
    geom_point() +
    scale_color_viridis(discrete = TRUE) + 
    theme_bw() +
    guides(size = "none") +
    labs(title = "Does Arena Capacity Contribute to Euroleague Success?",
         subtitle = "(point size corresponds to number of Titles won)",
         caption = "Data courtesy of tidytuesday and EuroleagueBasketball R package",
         x = "# of Final Four Appearances", 
         y = "Average Capacity of Home Country Arenas",
         tag = "Tidy Tuesday - Week of 2025/10/07") +
    theme(plot.caption.position = "plot",
          plot.tag = element_text(face = "bold")
)
