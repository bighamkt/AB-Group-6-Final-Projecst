library(plotly)

jscodeActor <- "
$(document).keyup(function(event) {
   if ($('#name1').is(':focus') && (event.keyCode == 13)) {
      $('#submit_actor_search').click();
   } else if ($('#name2').is(':focus') && (event.keyCode == 13)) {
      $('#submit_actor_search').click();
   }
});
"
#DIRECTOR TAB
#devtools::install_github("AnalytixWare/ShinySky")
movie_data <- read.csv("./data/movie_metadata_original.csv", stringsAsFactors = FALSE)
director_names <- select(movie_data, director_name)
director_names <- director_names[!duplicated(director_names[, 1]),]
jscodeDirector <- "
$(document).keyup(function(event) {
   if ($('#search').is(':focus') && (event.keyCode == 13)) {
      $('#submit_search').click();
   }
});
"
#END OF DIRECTOR TAB

shinyUI(navbarPage(title = "IMDB Dataset",
   theme = "boostrap.css",
   tabPanel("Home",
      HTML("<h1><u>Project Proposal</u><h1>"),
      h3("Project Description"),
      p("We will be working with an IMDB dataset from Kaggle. The dataset was created by Kaggle user chuansun76. They created it by scraping IMDB. Allowing them to accumulate 28 variables for 5043 movies, 
        that span across 100 years and 66 countries. Some of the variables include the movie’s title, director, actors, critic reviews, user reviews, and genres. The dataset can be downloaded from Kaggle website
        (https://www.kaggle.com/deepmatrix/imdb-5000-movie-dataset). Our target audience is movie lovers who is trying to find good movies based on his or her interests. Some specific questions our audience will 
        be able to answer from our project will be:"),
      HTML('
            <ol>
               <li>What are the best rated movies in certain genres?</li>
               <li>What are the movies that have audience’s two favorite actors?</li>
               <li>What are the movies that have the most popular actors?</li>
            </ol>
           '),
      h3("Technical Description"),
      p("We’ll be formating our final project as an HTML page. Our data will be read in using the .CSV file downloaded from Kaggle. Some reshaping will be necessary for our project such as rearranging the movies 
        based on genre since one movie could have many genres, as well as trimming down some of the unnecessary variables since we won’t be using all 28 available in the original dataset. We plan on using the 
        libraries we’ve used up until now such as dplyr and plotly. We don’t currently plan on using any new libraries but we will research them as we run into issues that require additional capabilities. We’ll 
        be using some basic statistical analysis but don’t anticipate needing to use anything beyond the basics or machine learning. The biggest challenge we foresee is maintaining a vision for this project in 
        the face of such a large dataset. Since we have so many variables available to investigate we will need to maintain strong communication to make sure that everyone is on the same page about which questions 
        we are focusing on.")
   ),
   tabPanel("Ratings"
      
      
   
   ),
   tabPanel("Actors",
      fluidPage(
      tags$script(HTML(jscodeActor)),
      # Director Quick Fact Tables
      h1("Summary"),
      fluidRow(
         column(4,
            h4("Most Successful Actors By Movie Revenue", style = "text-align:left"),
            tableOutput("top_actor_table_revenue")
         ),
         column(4,
            h4("Most Successful Actors By Movies Created", style = "text-align:left"),
            tableOutput("top_actor_table_created") 
         ),
         column(4,
            h4("Most Successful Actors By IMDB Scores", style = "text-align:left"),
            tableOutput("top_actor_table_score") 
         )
      ),
      # END OF TABLES
      HTML("<hr style='border-bottom: 2px solid gray'>"),
      # Actor Search
      fluidRow(
         column(4,
            h2("Actor Movie Search", style = "text-align:left"),
            wellPanel(
               h5("Search for one or more actors"),
               textInput("name1", placeholder = "Search...", value = "", label = "Actor 1"),
               textInput("name2", placeholder = "Search...", value = "", label = "Actor 2 (Optional)"),
               actionButton("submit_actor_search", "Search"),
               tags$style(HTML('#submit_actor_search{background-color:#3B5998; color:#ffffff}')),
               HTML('
                  <br />
                  <br />
                  <h5>Examples</h5>
                  <div style="color:gray">
                  <p>Johnny Depp</p>
                  <p>Matt Damon</p>
                  <p>Jennifer Lawrence</p>
                  <p>Natalie Portman</p>
                  </div>'
               )
            )
         ),
         column(8,
            tableOutput("actor_search_results")
         )
      )
        # END OF ACTOR SEARCH
      )
            
      
   ),
   tabPanel("Directors",
      fluidPage(
         tags$script(HTML(jscodeDirector)),
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
                  textInput("search", placeholder = "Search...", value = "Steven Spielberg", label = "Search for a director"),
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
   ),
   tabPanel("Trends",
      HTML("<h1><u>Duration</u><h1>"),
      h2("Average Movie Duration Over Time"),
      plotlyOutput("duration_graph"),
      p("As the movie industry has aged, there seems to be a standard movie length developing in the movie industry. As the industry was growing, it seems there was no clear consensus on just how long a movie should be.
        However, over the last 20 or so years, the movie industry has consistently averaged right under two hours for a film. This may be due to the industry maturing and developing trends and standards for how the industry
        should move forward."),
      br(),
      hr(),
      br(),
      HTML("<h1><u>Content Ratings</u><h1>"),
      h2("The Change in Content Ratings Into The 21st Century"),
      br(),
      fluidRow(
         column(6,
                plotlyOutput("movie_rating_1960_1990")
         ),
         column(6,
                plotlyOutput("movie_rating_post_1990")
         )
      ),
      p("As the moviegoers of the 20th century matured through the decades leading up to the new millenia, so did the movie industryas well. When comparing the late 20th century movie ratings to the 21st, there is a clear
        difference in the amount of PG-13 movies compared to PG. This may be due to the fact that the industry finds PG-13 movies to be more profitable as they could be an acceptable middle ground between mature R movies 
        and kid friendly PG movies. A parent may be a lot more willing to take a child to a PG-13 movies where there is a better chance that they will both enjoy a movie, whereas an R movie is unacceptable and a PG movie 
        may be to boring for a parent. Another theory may be that directors could feel too limited trying to make a movie suitable for PG audiences, whereas with PG-13, directors have more creative freedom."),
      br(),
      hr(),
      br(),
      HTML("<h1><u>Origin</u><h1>"),

      #CONTENT
      
      br(),
      hr(),
      br(),
      HTML("<h1><u>Language</u><h1>")

      #CONTENT
      
   ),
   tabPanel("Data",
      dataTableOutput("movie_data")       
   )
))