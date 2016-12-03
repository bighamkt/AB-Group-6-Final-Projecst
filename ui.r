


#DIRECTOR TAB
#devtools::install_github("AnalytixWare/ShinySky")
movie_data <- read.csv("./data/movie_metadata_original.csv", stringsAsFactors = FALSE)
director_names <- select(movie_data, director_name)
director_names <- director_names[!duplicated(director_names[, 1]),]
jscode <- "
$(document).keyup(function(event) {
   if ($('#search').is(':focus') && (event.keyCode == 13)) {
      $('#submit_search').click();
   }
});
"
#END OF DIRECTOR TAB

shinyUI(navbarPage(title = "IMDB Dataset",
   theme = "boostrap.css",
   tabPanel("Home"
      
   
      
   ),
   tabPanel("Ratings"
      
       
   
   ),
   tabPanel("Actors"
   
      
      
   ),
   tabPanel("Directors",
      fluidPage(
         tags$script(HTML(jscode)),
         # Director Quick Fact Tables
         h1("Summary"),
         fluidRow(
            column(4,
               h4("Most Successful Directors By Movie Revenue", style = "text-align:left"),
               tableOutput("top_director_table_revenue")
            ),
            column(4,
               h4("Most Successful Directors By Movies Created", style = "text-align:left"),
               tableOutput("top_director_table_created") 
            ),
            column(4,
               h4("Most Successful Directors By IMDB Scores", style = "text-align:left"),
               tableOutput("top_director_table_score") 
            )
         ),
         # END OF TABLES
         HTML("<hr style='border-bottom: 2px solid gray'>"),
         # Director IMDB Movie Score Search
         fluidRow(
            column(4,
               h2("Director Movie Search", style = "text-align:left"),
               wellPanel(
                  textInput("search", placeholder = "Steven Spielberg", value = "Steven Spielberg", label = "Search for a director"),
                  actionButton("submit_search", "Search"),
                  tags$style(HTML('#submit_search{background-color:#3B5998; color:#ffffff}')),
                  HTML('
                     <br />
                     <br />
                     <h5>Examples</h5>
                     <div style="color:gray">
                        <p>George Lucas</p>
                        <p>Quentin Tarantino</p>
                        <p>James Cameron</p>
                        <p>Tim Burton</p>
                     </div>
                  ')
               )
            ),
            column(8,
               tableOutput("director_search_results")
            )
         )
         # END OF DIRECTOR SEARCH
      )
   )
   # navbarMenu(title = "Trends",
   #    tabPanel("Duration"
   # 
   #    ),
   #    tabPanel("Movie Output"
   # 
   #    ),
   #    tabPanel("Content Ratings"
   # 
   #    ),
   #    tabPanel("Revenue",
   #       h1("The Revenue Fallacy"),
   #       plotlyOutput("revenue_score_plot"),
   #       p("INSERT")
   #    ),
   #    tabPanel("Origin"
   # 
   #    ),
   #    tabPanel("Language"
   # 
   #    )
   #    # Maybe language and origin can be shown
   #    # an overall and overall graph
   # )
))