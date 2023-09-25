library(shiny)
library(DT)
library(ggplot2)
library(plotly)
library(wordcloud2)
library(leaflet)
library(ggmap)

function(input, output, session) {
  my_data <- read.csv("movies.csv")
  
  
  output$data_table <- DT::renderDataTable({
    print("Rendering data")
    datatable(my_data, 
              options = list(
                searching = TRUE,     
                pageLength = 10
              )
    )
  })
  
  genre_freq <- table(my_data$Genre)
  top_3_genres <- head(sort(genre_freq, decreasing = TRUE), 3)
  pie_data <- data.frame(Genre = names(top_3_genres), Frequency = as.vector(top_3_genres))
  output$genre_pie_chart <- renderPlot({
    pie(pie_data$Frequency, labels = pie_data$Genre, main = "Top 3 Genres")
  })
  
  ratings_distribution <- reactive({
    ggplot(data = my_data, aes(x = Rating)) +
      geom_bar(fill = "blue", color = "black") +
      labs(title = "Ratings de Peliculas", x = "Rating", y = "Count") +
      theme_minimal()
  })
  
  output$ratings_bar_chart <- renderPlot({
    ratings_distribution()
  })
  
  director_counts <- table(my_data$Director)
  director_data <- data.frame(Director = names(director_counts), Count = as.vector(director_counts))
  
  
  
  output$wordcloud <- renderWordcloud2({
    # Prepare data for the word cloud
    director_wordcloud_data <- data.frame(
      words = director_data$Director,
      freq = director_data$Count
    )
    
    wordcloud2(
      director_wordcloud_data,
      color = "random-dark",
      backgroundColor = "white",
      size = 1.5
    )
  })
  
  
  
  
}

