library(dplyr)
library(plotly)
movie_data <- read.csv("data/movie_metadata_original.csv", stringsAsFactors = FALSE)
######################## TODOS?? ############################
#top movie by <insert actor here in search box>
#############################################################

# Number of movies in each labeled langauge as well as their overall percentage
movies_languages <- movie_data %>% group_by(language) %>% summarise(num_of_movies = n()) %>% filter(language != "") %>% mutate(percent = round((num_of_movies * 100)/sum(num_of_movies), 2)) %>% arrange(-num_of_movies)

# Num of movies in each labeled country of origin as well as their overall percentage
movies_origin <- movie_data %>% group_by(country) %>% summarise(num_of_movies = n()) %>% filter(country != "") %>% mutate(percent = round((num_of_movies * 100)/sum(num_of_movies), 2)) %>% arrange(-num_of_movies)

# Num of movies filmed in each respective year sorted in descending order by num of movies
movies_year <- movie_data %>% group_by(title_year) %>% summarise(num_of_movies = n()) %>% filter(title_year != "") %>% arrange(-num_of_movies)

top_10_revenue <- movie_data %>% arrange(-gross) %>% head(10) %>% select(movie_title, gross)
top_10_duration <- movie_data %>% arrange(-duration) %>% head(10) %>% select(movie_title, duration)

# Average number of movies created every year across whole dataset
avg_movies_by_year <- round(mean(movies_year$num_of_movies))

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


plot_data <- data.frame(movie_imdb_score_year$title_year, movie_imdb_score_year$avg_score, movie_revenue_year$revenue)
revenue_imdb_score <- plot_ly(plot_data, x = plot_data$movie_imdb_score_year.title_year, y = plot_data$movie_imdb_score_year.avg_score, name = "IMDB Average Score", type = "scatter", mode = "lines") %>%
   add_trace(y = plot_data$movie_revenue_year.revenue / 1000000000, name = "Total Revenue (Billions)", mode = "lines")
