library(tidyverse)
library(ggplot2)
library(broom)
library(gt)
library(viridis)
library(forcats)
library(hrbrthemes)
library(GGally)

fide_ratings_august <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-09-23/fide_ratings_august.csv')
fide_ratings_september <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-09-23/fide_ratings_september.csv')

#Factors of interest: age, sex ratio (F/M), ave rating in federation; number of games played that month, K factor
fide_ratings_august_reduced <- fide_ratings_august |>
  mutate(current_age = 2025 - bday) |>
  select(c(fed, current_age, sex, rating, games, k))

fide_ratings_august_reduced_M <- fide_ratings_august_reduced |>
  filter(sex == "M") |>
  group_by(fed) |>
  summarize(num_of_M = n(), mean_age = mean(current_age, na.rm= TRUE), mean_rating = mean(rating, na.rm = TRUE), total_games = sum(games), mean_k = mean(k, na.rm = TRUE))


fide_ratings_august_reduced_F <- fide_ratings_august_reduced |>
  filter(sex == "F") |>
  group_by(fed) |>
  summarize(num_of_F = n(), mean_age = mean(current_age, na.rm= TRUE), mean_rating = mean(rating, na.rm = TRUE), total_games = sum(games), mean_k = mean(k, na.rm = TRUE))

data <- iris
ggparcoord(data,
  columns = 1:4, groupColumn = 5, order = "anyClass",
  scale="center",
  showPoints = TRUE, 
  title = "Standardize and center variables",
  alphaLines = 0.3
  ) + 
scale_color_viridis(discrete=TRUE) +
theme_ipsum()+
theme(
  legend.position="none",
  plot.title = element_text(size=13)
) +
xlab("")

# This doesn't work T_T
#fide_aug_F_plt <- fide_ratings_august_reduced_F |>
#  drop_na(2:5) |>
#  ggparcoord(columns = 2:5, groupColumn = 1, order = "anyClass",
#    scale = "center",
#    showPoints = TRUE,
#    title = "Federation - Woman",
#    alphaLines = 0.3) +
#    scale_color_viridis(discrete = TRUE)

# Used positron assistant to assist
###################################################################################
# The error occurs because ggparcoord() expects each group (federation) to have data,
# but after using drop_na(2:5), some federations may have been completely removed, 
# creating a mismatch between the grouping variable and the data.
# Let me check the structure of your data first to understand the issue better:
# 
# Using "Inspect Variables"
# The issue is that when you use drop_na(2:5) on the grouped data, 
# some federations might lose all their rows, but the federation factor levels 
# remain. Here's the fix:

fide_aug_F_plt <- fide_ratings_august_reduced_F |>
  drop_na(2:5) |>
  # Remove any federations that have no remaining data after drop_na
  filter(if_any(2:5, ~ !is.na(.))) |>
  #Get top 5 and bottom 5 for both men and women
  # Convert fed to factor and drop unused levels
  mutate(fed = fct_drop(as.factor(fed))) |>
  ggparcoord(columns = 2:5, groupColumn = 1, order = "anyClass",
    scale = "center",
    showPoints = TRUE,
    title = "Federation - Woman",
    alphaLines = 0.3) +
    scale_color_viridis(discrete = TRUE)