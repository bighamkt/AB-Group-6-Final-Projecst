library(dplyr)
library(plotly)
source("./scripts/director.R")
source("./scripts/trends.R")

movie_data <- read.csv("./data/movie_metadata_original.csv", stringsAsFactors = FALSE)
server <- function(input, output) {
   
   
   
   

   # Director Tab
   director <- eventReactive(input$submit_search, {
      input$search
   })
   output$top_director_table_revenue <- renderTable(return(BuildDirectorTable("revenue")))
   output$top_director_table_created <- renderTable(return(BuildDirectorTable("numOfMovies")))
   output$top_director_table_score <- renderTable(return(BuildDirectorTable("score")))
   output$director_search_results <- renderTable(return(BuildDirectorSearchTable(director())))
   
   # Trends Tab
   output$duration_graph <- renderPlotly(return(BuildDurationOverTimePlot()))
   output$movie_rating_1960_1990 <- renderPlotly(return(BuildMovieRatingBar1960_1990()))
   output$movie_rating_post_1990 <- renderPlotly(return(BuildMovieRatingBarPost1990()))

   # Data
   output$movie_data <- renderDataTable(movie_data)
}