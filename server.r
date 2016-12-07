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
   
   # Trends Tabs
   ## Duration
   output$duration_graph <- renderPlotly(return(BuildDurationOverTimePlot()))
   
   ## Revenue
   output$revenue_score_plot <- renderPlotly(return(BuildRevenueScoreComparisonPlot()))
   
   ## Origin
   
   # Data
   output$movie_data <- renderDataTable(movie_data)
}