library(ggplot2)
library(dplyr)
movie_data <- read.csv("data/movie_metadata_original.csv", stringsAsFactors = FALSE)

# IMDB score average by year as well as a post 2000 version to see modern trends
movie_imdb_score_year <- na.omit(movie_data) %>% filter(title_year < 2013 & title_year > 1950) %>% group_by(title_year) %>% summarise(avg_score = round(mean(imdb_score), 1)) %>% filter(title_year != "") %>% arrange(-as.numeric(title_year))
movie_imdb_score_post_2000 <- movie_imdb_score_year %>% filter(title_year >= 2000) %>% arrange(-as.numeric(title_year))
# Movie revenue by year with a post 2000 version to see modern trends
movie_revenue_year <- na.omit(movie_data) %>% filter(title_year < 2013 & title_year > 1950) %>% group_by(title_year) %>% summarise(revenue = sum(as.numeric(gross))) %>% arrange(-as.numeric(title_year))
movie_revenue_post_2000 <- movie_revenue_year %>% filter(title_year >= 2000) %>% arrange(-as.numeric(title_year))

# Average movie duration by year
movie_duration_year <- movie_data %>% group_by(title_year) %>% summarise(avg_duration = round(mean(duration, na.rm = TRUE))) %>% filter(title_year != "") %>% arrange(-avg_duration)

# The total and overall percentage of MODERN MPAA content ratings across dataset
movie_overall_content_rating <- movie_data %>% group_by(content_rating) %>% summarise(num_of_movies = n()) %>% 
   filter(content_rating != "" & !grepl("TV|Passed|Not Rated|GP|M|Unrated|Approved", content_rating)) %>% mutate(percent = round((num_of_movies * 100)/sum(num_of_movies)))


BuildRevenueScoreComparisonPlot <- function() {
   plot_data <- data.frame(movie_imdb_score_year$title_year, movie_imdb_score_year$avg_score, movie_revenue_year$revenue)
   revenue_imdb_score <- plot_ly(plot_data, x = plot_data$movie_imdb_score_year.title_year, y = plot_data$movie_imdb_score_year.avg_score, name = "IMDB Average Score", type = "scatter", mode = "lines") %>%
      add_trace(y = plot_data$movie_revenue_year.revenue / 1000000000, name = "Total Revenue (Billions)", mode = "lines")
   return(revenue_imdb_score)
}