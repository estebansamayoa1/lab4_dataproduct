library(shiny)
library(DT)


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
  
  }

