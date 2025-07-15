#load packages
library(tidyverse)
library(ggplot2)
library(gganimate)
library(broom)
library(gt)
library(gifski)
library(hrbrthemes)
library(viridis)

#pull tidytuesday data from github
bl_funding <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-07-15/bl_funding.csv')

#Drop all columns except for ones related to funding in year 2000 GBP
# rename columns for ease, 
# transform table into long format so each observation has a funding source 
bl_short<- bl_funding %>%
    select(year,total_y2000_gbp_millions, gia_y2000_gbp_millions, voluntary_y2000_gbp_millions, investment_y2000_gbp_millions, services_y2000_gbp_millions) %>%
    rename(total_funding= total_y2000_gbp_millions,gia_funding = gia_y2000_gbp_millions, volun_funding = voluntary_y2000_gbp_millions, invest_funding = investment_y2000_gbp_millions, services_funding = services_y2000_gbp_millions) %>%
    pivot_longer(c(total_funding,gia_funding, volun_funding, invest_funding, services_funding))
    #filter(name != "total_funding")
bl_short

# Rearrange funding sources for figure
bl_short_rearranged <- bl_short
bl_short_rearranged$name <- factor(bl_short_rearranged$name,levels = c("total_funding", "gia_funding","services_funding","volun_funding","invest_funding"))

#Create and render animation 

brit_lit_fund_y2000 <- ggplot(bl_short_rearranged, aes(x = year, y = value, group = name, color = name)) +
  geom_line() +
  scale_color_viridis(discrete = TRUE, labels = c("Cumulative",'Grant-in-Aid',"Services","Voluntary","Investments and Returns")) +
  ggtitle("British Library Funding Breakdown From 1999 to 2023") +
  theme_ipsum() + 
  theme(axis.title.y = element_text(size =12),
        axis.title.x = element_text(size =12)) +
  ylab("Reported funding in Year 2000 GBP") +
  labs(colour = "Funding Sources") +
  transition_reveal(year)

#Save gif!
anim_save("british_library_funding_1998_to_2023_in_y2000_GBP.gif",version_3,height = 480, width = 640)
