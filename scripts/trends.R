library(plotly)
library(dplyr)

BuildDurationOverTimePlot <- function() {
   movie_data <- read.csv("data/movie_metadata_original.csv", stringsAsFactors = FALSE)
   movie_duration_year <- movie_data %>% group_by(title_year) %>% summarise(avg_duration = round(mean(duration, na.rm = TRUE))) %>% filter(title_year != "") %>% arrange(-avg_duration)
   duration_year <- plot_ly(movie_duration_year, x = movie_duration_year$title_year, color = movie_duration_year$avg_duration) %>%
      add_trace(y = movie_duration_year$avg_duration, name = "Duration") %>%
      layout(xaxis = list(title = "Year"), yaxis = list(title = "Average Movie Duration (minutes)"))
   return(duration_year)
}

BuildMovieRatingBar1960_1990 <- function() {
   movie_data <- read.csv("data/movie_metadata_original.csv", stringsAsFactors = FALSE)
   movie_content_rating_1960_1990 <- movie_data %>% filter(title_year > as.numeric(1960) & title_year <= as.numeric(1990)) %>% group_by(content_rating) %>% summarise(num_of_movies = n()) %>%
      filter(content_rating != "" & !grepl("TV|Passed|Not Rated|GP|M|Unrated|Approved|X", content_rating))
   movie_ratings_1960_1990 <- plot_ly(movie_content_rating_1960_1990, x = ~content_rating, y = ~num_of_movies, type = "bar", 
                                      marker = list(color = c("#388697", "#2EC4B6", "#68B0AB", "#304D6D", "rgb(40, 97, 95)"))) %>%
      layout(title = "Movie Rating 1960 to 1990", xaxis = list(title = "Rating"), yaxis = list(title = "Number of Movies"))
   return(movie_ratings_1960_1990)
}

BuildMovieRatingBarPost1990 <- function() {
   movie_data <- read.csv("data/movie_metadata_original.csv", stringsAsFactors = FALSE)
   movie_content_rating_post_1990 <- movie_data %>% filter(title_year > as.numeric(1990)) %>% group_by(content_rating) %>% summarise(num_of_movies = n()) %>%
      filter(content_rating != "" & !grepl("TV|Passed|Not Rated|GP|M|Unrated|Approved|X", content_rating))
   movie_ratings_post_1990 <- plot_ly(movie_content_rating_post_1990, x = ~content_rating, y = ~num_of_movies, type = "bar",
                                      marker = list(color = c("#388697", "#2EC4B6", "#68B0AB", "#304D6D", "rgb(40, 97, 95)"))) %>%
      layout(title = "Movie Rating 1990 to Present", xaxis = list(title = "Rating"), yaxis = list(title = "Number of Movies"))
   return(movie_ratings_post_1990)
}

BuildRevenueScoreComparisonPlot <- function() {
   movie_data <- read.csv("data/movie_metadata_original.csv", stringsAsFactors = FALSE)
   # IMDB score average by year as well as a post 2000 version to see modern trends
   movie_imdb_score_year <- na.omit(movie_data) %>% filter(title_year < 2013 & title_year > 1950) %>% group_by(title_year) %>% summarise(avg_score = round(mean(imdb_score), 1)) %>% filter(title_year != "") %>% arrange(-as.numeric(title_year))
   movie_imdb_score_post_2000 <- movie_imdb_score_year %>% filter(title_year >= 2000)
   # Movie revenue by year with a post 2000 version to see modern trends
   movie_revenue_year <- na.omit(movie_data) %>% filter(title_year < 2013 & title_year > 1950) %>% group_by(title_year) %>% summarise(revenue = sum(as.numeric(gross))) %>% arrange(-as.numeric(title_year))
   movie_revenue_post_2000 <- movie_revenue_year %>% filter(title_year >= 2000)
   
   plot_data <- data.frame(movie_imdb_score_post_2000$title_year, movie_imdb_score_post_2000$avg_score, movie_revenue_post_2000$revenue)
   revenue_imdb_score <- plot_ly(plot_data, x = plot_data$movie_imdb_score_post_2000.title_year, y = plot_data$movie_imdb_score_post_2000.avg_score, name = "IMDB Average Score", type = "scatter", mode = "lines") %>%
      add_trace(y = plot_data$movie_revenue_post_2000.revenue / 1000000000, name = "Total Revenue (Billions)", mode = "lines")
   return(revenue_imdb_score)
}

