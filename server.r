source("./scripts/director.R")
source("./scripts/trends.R")
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
   
   # Revenue
   # output$revenue_score_plot <- renderPlotly(return(BuildRevenueScoreComparisonPlot()))
}