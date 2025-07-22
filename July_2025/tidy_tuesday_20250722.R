library(tidyverse)
library(hrbrthemes)
library(viridis)
mta_art <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-07-22/mta_art.csv')
station_lines <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-07-22/station_lines.csv')

# Little simpler this week but it's something!
mta_art %>%
  group_by(agency,art_date) %>%
  arrange(desc(art_date)) %>%
  count() %>%
  rename("num_of_pieces" = n) %>%
  ungroup() %>% #otherwise complete....will not work
  complete(
    agency,
    art_date = full_seq(as.integer(art_date), period = 1),
    fill = list(num_of_pieces = 0L)
  ) %>%
  ggplot(aes(x = art_date, y = num_of_pieces, color = agency)) +
    geom_line() +
    scale_color_viridis(discrete = TRUE) +
    ggtitle("Growth of Art Pieces Seen\n in MTA from 1980 to 2023") +
      theme_ipsum(axis_title_just = "ct",
                  grid = FALSE) + 
      theme(axis.title.y = element_text(size =12),
            axis.title.x = element_text(size =12)) +
      labs(x = "Year of Installation",
          y = "Number of New Art Pieces Installed",
          colour = "Agency")