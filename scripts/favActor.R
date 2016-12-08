require(dplyr)
require(plotly)

# Actor Summary Table
BuildActorTable <- function(type) {
  movie_data <- read.csv("./data/movie_metadata_original.csv", stringsAsFactors = FALSE)
  if(type == "revenue") {
    actor_revenue <- na.omit(movie_data) %>% select(actor_1_name, gross) %>% group_by(actor_1_name) %>% 
      summarise(total_revenue = round(sum(as.numeric(gross))/1000000000, 2)) %>% arrange(-total_revenue)
    top_10_actor_revenue <- head(actor_revenue, 10)
    colnames(top_10_actor_revenue) <- c("Actor", "Revenue (Billions)")
    return(top_10_actor_revenue)
  } else if(type == "numOfMovies") {
    top_10_actor_num_movies <- movie_data %>% group_by(actor_1_name) %>% summarise(numOfMovies = n()) %>% 
      filter(actor_1_name != "") %>% arrange(-numOfMovies) %>% head(10)
    colnames(top_10_actor_num_movies) <- c("Actor", "Movies Created")
    return(top_10_actor_num_movies)
  } else if(type == "score") {
    top_10_actor_score <- movie_data %>% group_by(actor_1_name) %>% filter(n() > 5) %>% summarise(score = mean(imdb_score)) %>%
      filter(actor_1_name != "") %>% arrange(-score) %>% head(10)
    colnames(top_10_actor_score) <- c("Actor", "IMDB Average Score")
    return(top_10_actor_score)
  }
}

# Movies with selcted actors (one or two)
BuildFavActorsTable <- function(name1, name2) {
  movie_data <- read.csv("/Users/apple/Desktop/INFO201/Homework/AB-Group-6-Final-Project/data/movie_metadata_original.csv", stringsAsFactors = FALSE)
  # If user fills out both search bars with actor names.
  if(name1 != "" & name2 != ""){
  actor_movies <- movie_data  %>% filter(actor_1_name == name1 | actor_2_name == name1 | actor_3_name == name1) %>%
    filter(actor_1_name == name2 | actor_2_name == name2 | actor_3_name == name2)
  # If user only fills out one search bar with actor name. 
  } else if(name1!= "" & name2 =="") {
    actor_movies <- movie_data  %>% filter(actor_1_name == name1 | actor_2_name == name1 | actor_3_name == name1)  
  }
  formatted_data <- actor_movies %>% select(actor_1_name, actor_2_name, actor_3_name, movie_title, title_year, imdb_score, content_rating, duration)
  colnames(formatted_data) <- c("Lead Actor", "Supporting Actor", "Supporting Actor", "Title", "Year", "IMDB Score", "Rating", "Duration (m)")
  return(formatted_data)
}

# A plot shows actor's IMDB score for movie
BuildActorPlot <- function(name) {
  movie_data <- read.csv("/Users/apple/Desktop/INFO201/Homework/AB-Group-6-Final-Project/data/movie_metadata_original.csv", stringsAsFactors = FALSE)
  actor_movies <- movie_data  %>% filter(actor_1_name == name | actor_2_name == name | actor_3_name == name) %>%
    select(movie_title, title_year, imdb_score) 
  ndx = order(actor_movies$title_year)
  actor_movies_sorted = actor_movies[ndx,]
  actor_movies_graph <- plot_ly(actor_movies_sorted,
                                x = ~title_year, y = ~imdb_score,
                                name = "IMDB Score",
                                text = ~movie_title,
                                plot = "scatter") 
  return(actor_movies_graph)
}
