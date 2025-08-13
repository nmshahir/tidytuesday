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

# scrapped idea
# publication_year_breakdown_plot <- attribution_studies %>%
#     drop_na(publication_year) %>%
#     mutate(classification = as.factor(classification), publication_year = as.factor(publication_year)) %>%
#     mutate(climate_impact = case_when(
#       classification == "More severe or more likely to occur" ~ "Extreme weather event or trend more severe or more likely to occur",
#       classification == ""
#     ))
#     mutate(classification = fct_relevel(classification, "More severe or more likely to occur", "Decrease, less severe or less likely to occur", "No discernible human influence","Insufficient data/inconclusive" )) %>%
#     #group_by(publication_year) %>%
#     #group_by(event_year,classification) %>%
#     count(publication_year, classification) %>%
#     ggplot(aes(x = n, y= fct_reorder(publication_year, as.numeric(publication_year), .desc = TRUE), fill = classification)) +
#       geom_bar(position = "stack",stat = "identity") +
#       scale_fill_viridis(discrete = T) +
#       theme_ipsum() + 
#       theme(legend.position = "bottom") +
#       labs(fill = "", x = "Number of Publications", y = "Publication Year of Study") +
#       ggtitle("The Role of Climate Change as Defined by Extreme Weather Attribution Studies")


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

