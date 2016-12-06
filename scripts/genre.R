#Set-up, load data and relevant libraries
movie_data<- read.csv("C:/Users/Katie/Desktop/AB-Group-6-Final-Project/data/movie_metadata_original.csv", header=FALSE)
library(dplyr)
library(plotly)

#Select Top Ten of Genre of Choice
SearchGenre<- function(Genre){
  #Search for the Genre
  hasGen <-  sapply( movie_data, grepl, patt=Genre, ignore.case=FALSE)
  #Sort and refine the data table, the columns selected here will be used in later graphics
  searched.genre.table<- movie_data[ rowSums(hasGen) > 0 , ] %>%
    select(V2, V4, V7, V9, V10, V11, V12, V15, V21, V22, V23, V24, V26, V28) %>%
  #Sort the data by IMDB rating
    arrange(desc(V26)) %>%
  #Cut table to down to top ten
    slice(1:10)
  #Reorder the dataframe's columns
  searched.genre.table<- searched.genre.table[c("V12", "V24", "V2", "V11", "V7", "V15", "V10", "V22", "V4", "V21", "V23", "V9", "V26", "V28" )]
  #Add desired column names
  colnames(searched.genre.table)<- c("Title", "Title_Year", "Director_Name", "First_Actor_Name", "Second_Actor_Name", "Third_Actor_Name", "Genres", "Content_Rating", "Duration", "Country_of_Origin", "Budget", "Gross_Income", "IMDB_Rating", "Facebook_Likes")
  View<- View(searched.genre.table)
  return(View)
}


#Bar Chart of Budget and Gross Income
  #Displays each title's budget in a bar graph
  budget.graph<- plot_ly(searched.genre.table, 
                       x = ~Title, y = ~Budget,
                       type = 'bar',
                       name = 'Movie or Television Budget') 
  #Displalys each title's gross income in a bar graph
  gross.income.graph<- plot_ly(searched.genre.table, 
                             x = ~Title, y = ~Gross_Income,
                             type = 'bar',
                             name = 'Movie or Television Gross Income') 
  #Displays each title's budget and gross income side by side in a clustered bar graph
  budget.income.graph<- plot_ly(searched.genre.table,
                                x = ~Title, y = ~Budget,
                                type = 'bar',
                                name = 'Movie or Television Budget') %>%
                            add_trace(y = ~Gross_Income, 
                                      name = 'Movie or Television Gross Income') %>%
                            layout(barmode = 'group')

#IMDB Rating compared to Facebook Likes
  IMDB.Facebook.table<- mutate(searched.genre.table, ratio = Facebook_Likes/IMDB_Rating)
  IMDB.Facebook.graph<- plot_ly(IMDB.Facebook.table,
                                x = ~Title, y = ~IMDB_Rating,
                                type = 'bar',
                                name = 'Ratio of Facebook Likes to IMDB Rating for Movie or Television')
  
#Bar Chart for Duration
  duration.graph<- plot_ly(searched.genre.table, 
                           x = ~Title, y = ~Duration,
                           type = 'bar',
                           name = 'Movie or Television Length')

#Pie Chart for Content Ratings
  rating.table<- select(searched.genre.table, Title, Content_Rating) %>%
                group_by(Content_Rating) %>%
                summarise(n = n())
  rating.graph<- plot_ly(rating.table,
                         labels = ~Content_Rating,
                          values = ~n, type = 'pie') %>%
                        layout(title = 'Movie or Television Content Rating')
  
#Pie Chart for Country of Origin
  country.table<- select(searched.genre.table, Title, Country_of_Origin) %>%
    group_by(Country_of_Origin) %>%
    summarise(n = n())