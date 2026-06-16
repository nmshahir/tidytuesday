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
library(tidytext)
library(textdata)

#Loading the Tidy Tuesday dataset for 2025.11.20
holmes <- readr::read_csv(
  'https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2025/2025-11-18/holmes.csv'
)

#how many unique titles are in this dataset
unique(holmes$book) #Answer: 48

#Making holmes dataset into "tidy" tokenized dataset
tidy_holmes <- holmes |>
  unnest_tokens(word, text) |>
  drop_na()

#importing list of stop words to strip from holmes
data(stop_words)

tidy_holmes_no_stop <- tidy_holmes |>
  anti_join(stop_words)


tidy_holmes_no_stop

tidy_holmes_stop <- tidy_holmes |>
  semi_join(stop_words)

tidy_holmes_stop

# Book --- total_num_words  -- total_num_stop_words
tidy_holmes_count <- tidy_holmes |>
  group_by(book) |>
  summarise(total_num_of_words = n())

tidy_holmes_count

tidy_holmes_stop_count <- tidy_holmes_stop |>
  group_by(book) |>
  summarise(total_num_of_stop_words = n())

tidy_holmes_stop_count

tidy_holmes_all_words <- tidy_holmes_count |>
  inner_join(tidy_holmes_stop_count, by = "book")


tidy_holmes_scatter <- tidy_holmes_count |>
  inner_join(tidy_holmes_stop_count, by = "book") |>
  ggplot(aes(x = total_num_of_words, y = total_num_of_stop_words)) +
  geom_point()

tidy_holmes_scatter # This is fairly linear

tidy_holmes_bar <- tidy_holmes_count |>
  inner_join(tidy_holmes_stop_count, by = "book") |>
  ggplot(aes(
    x = book,
    y = (total_num_of_stop_words / total_num_of_words) * 100
  )) +
  geom_bar(stat = "identity")
tidy_holmes_bar #again flat distribution

base_tidy_plot <- tidy_holmes_no_stop |>
  count(word, sort = TRUE) |>
  filter(n > 500) |>
  mutate(word = reorder(word, n)) |>
  ggplot(aes(x = n, y = word)) +
  geom_col() +
  labs(y = NULL)


tidy_holmes_top10_books <- tidy_holmes_count |>
  slice_max(order_by = total_num_of_words, n = 10) |>
  select(book)

tidy_holmes_no_stop |>
  inner_join(tidy_holmes_top10_books, by = "book") |>
  count(word, sort = TRUE)

base_tidy_plot +
  theme(text = element_text(size = 16, family = "Baskerville Old Face"))

theme_aged_paper <- function() {
  theme_bw() %+replace%
    theme(
      # Set the background color of the entire plot and panel
      plot.background = element_rect(fill = "#f7f0e0", color = NA), # Aged paper cream/tan color
      panel.background = element_rect(fill = "#f7f0e0", color = NA),

      # Customize grid lines (remove them or make them very faint)
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),

      # Customize axes and text
      axis.line = element_line(colour = "#5e5e5e"), # Darker color for "ink"
      axis.text = element_text(colour = "#5e5e5e", size = 12),
      axis.title = element_text(colour = "#5e5e5e", size = 14, face = "bold"),

      # Customize plot title
      plot.title = element_text(
        colour = "#5e5e5e",
        size = 16,
        face = "bold",
        hjust = 0.5
      ),

      # Customize legend
      legend.background = element_rect(fill = "#f7f0e0", color = NA),
      legend.key = element_rect(fill = "#f7f0e0", color = NA),
      legend.text = element_text(colour = "#5e5e5e"),
      legend.title = element_text(colour = "#5e5e5e"),

      # Remove the panel border which is standard in theme_bw()
      panel.border = element_blank(),

      # Customize strip background for facets
      strip.background = element_rect(fill = "#e8e1d1", colour = "#5e5e5e")
    )
}
