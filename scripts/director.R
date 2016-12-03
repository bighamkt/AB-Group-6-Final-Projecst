require(dplyr)
movie_data <- read.csv("./data/movie_metadata_original.csv", stringsAsFactors = FALSE)

BuildDirectorTable <- function(type = "revenue") {
   if(type == "revenue") {
      director_revenue <- na.omit(movie_data) %>% select(director_name, gross) %>% group_by(director_name) %>% 
         summarise(total_revenue = round(sum(as.numeric(gross))/1000000000, 2)) %>% arrange(-total_revenue)
      top_10_director_revenue <- head(director_revenue, 10)
      colnames(top_10_director_revenue) <- c("Director", "Revenue (Billions)")
      return(top_10_director_revenue)
   } else if(type == "numOfMovies") {
      top_10_director_num_movies <- movie_data %>% group_by(director_name) %>% summarise(numOfMovies = n()) %>% 
         filter(director_name != "") %>% arrange(-numOfMovies) %>% head(10)
      colnames(top_10_director_num_movies) <- c("Director", "Movies Created")
      return(top_10_director_num_movies)
   } else if(type == "score") {
      top_10_director_score <- movie_data %>% group_by(director_name) %>% filter(n() > 1) %>% summarise(score = mean(imdb_score)) %>%
         filter(director_name != "") %>% arrange(-score) %>% head(10)
      colnames(top_10_director_score) <- c("Director", "IMDB Average Score")
      return(top_10_director_score)
   }
}

BuildDirectorSearchTable <- function(name = "Steven Spielberg") {
   director_movies <- movie_data %>% filter(tolower(director_name) == tolower(name)) %>% mutate(revenue = round(gross/1000000, 2)) %>% mutate(cost = round(budget/1000000)) %>% filter(director_name != "")
   formatted_data <- director_movies %>% select(movie_title, title_year, imdb_score, content_rating, duration, revenue, cost)
   colnames(formatted_data) <- c("Title", "Year", "IMDB Score", "Rating", "Duration (m)", "Revenue (millions)", "Cost (millions)")
   return(formatted_data)
}