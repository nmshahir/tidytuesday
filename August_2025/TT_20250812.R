#load packages
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

#import dataset
attribution_studies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-08-12/attribution_studies.csv')

event_type_climate <- attribution_studies %>%
    select(event_type, classification) %>%
    mutate(classification = fct_relevel(classification, "More severe or more likely to occur", "Decrease, less severe or less likely to occur", "No discernible human influence","Insufficient data/inconclusive" )) %>%
    count(event_type,classification) %>%
    ggplot(aes(x = n, y = event_type, fill = classification)) +
      geom_bar(position = "fill", stat = "identity") +
      scale_x_percent() +
      scale_fill_viridis(discrete = T) +
      theme_ipsum() +
      theme(legend.position = "bottom") +
      guides(fill = guide_legend(title.position = "top", title.hjust = 0.5,ncol = 2)) +
      labs(fill = "Climate Change Impact on Weather Event", 
          y = "",
          x = "", 
          caption = "Data from CarbonBrief (https://www.carbonbrief.org/) and tidytuesday") + 
      ggtitle("The Impact of Climate Change on Extreme Weather Events is Rarely Neutral",subtitle = "Less river flow isn't necessarily a good thing.")
ggsave("climate_change_event_types.jpg", event_type_climate, width = 11, height =8, units = "in")

