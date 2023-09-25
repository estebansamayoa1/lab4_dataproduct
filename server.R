library(shiny)
library(DT)
library(ggplot2)
library(plotly)
library(wordcloud2)
library(dplyr)

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
    pie(pie_data$Frequency, labels = pie_data$Genre, main = "3 Géneros de Peliculas más Populares")
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
  
  movie_info <- reactive({
    movie_name <- input$movie_name
    movie <- my_data[my_data$Title == movie_name, ]
    
    if (nrow(movie) == 0) {
      return(NULL)
    } else {
      info_text <- paste(
        "Title:", movie$Title[1], "<br>",
        "Director:", paste0(movie$Director[1]), "<br>",
        "Duration:", paste0(movie$Runtime[1], " minutes"), "<br>",
        "Rating:", paste0(movie$Rating[1]), "<br>",
        "Stars:", paste0(movie$Stars[1]), "<br>",
        "Genre:", paste0(movie$Genre[1])
      )
      
      return(HTML(info_text))
    }
  })
  
  output$movie_info_box <- renderValueBox({
    info <- movie_info()
    
    if (!is.null(info)) {
      infoBox(
        info,
        "Movie Information",
        icon = icon("film"),
        color = "blue", 
        fill = TRUE
      )
    } else {
      infoBox(
        "Movie not found",
        "Movie Information",
        icon = icon("film"),
        color = "teal",
        fill = TRUE
        
      )
    }
  })
  
  
  data_filtered <- my_data %>%
    filter(!is.na(Month) & Month != "Unknown" & Month != "")
  
  month_counts <- table(data_filtered$Month)
  
  top_months <- names(sort(month_counts, decreasing = TRUE)[1:5])
  
  top_month <- names(sort(month_counts, decreasing = TRUE)[1])
  
  data_top_months <- data_filtered %>%
    filter(Month %in% top_months)
  
  data_top_month <- data_filtered %>%
    filter(Month == top_month)
  
  summarized_data <- data_top_months %>%
    group_by(Month) %>%
    summarize(Count = n())
  
  
  output$pie_chart <- renderPlot({
    pie_chart <- ggplot(summarized_data, aes(x = "", y = Count, fill = Month)) +
      geom_bar(stat = "identity") +
      coord_polar(theta = "y") +
      theme_void() +
      labs(title = "Meses en los que se estrenan más peliculas")
    
    print(pie_chart)
  })
  
  output$top_month_box <- renderValueBox({
    valueBox(
      top_month,
      subtitle = "Top Month",
      icon = icon("calendar"),
      color = "blue"
    )
  })
  
  
  filtered_data <- my_data %>%
    filter(!is.na(Year) & Year != "Unknown" & Year != "")
  
  year_counts <- table(filtered_data$Year)
  
  top_year <- names(sort(year_counts, decreasing = TRUE)[1])
  
  data_top_year <- filtered_data %>%
    filter(Year == top_year)
  
  
  output$top_year_box <- renderValueBox({
    valueBox(
      top_year,
      subtitle = "Top Year",
      icon = icon("calendar"),
      color = "purple"
    )
  })
  

  average_rating <- mean(my_data$Rating, na.rm = TRUE)
  
  output$average_rating_box <- renderValueBox({
    valueBox(
      round(average_rating, 2),  # Round to 2 decimal places
      "Average Rating",
      icon = icon("star"),
      color = "green"
    )
  })
  
  
}

