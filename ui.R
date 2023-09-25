library(shiny)
library(DT)
library(ggplot2)
library(plotly)
library(leaflet)
library(wordcloud2)
library(dplyr)
library(jsonlite)
library(shinydashboard)

# Define UI
dashboardPage(
  dashboardHeader(title = "Lab 4: Popular Movies"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Movie Charts", tabName = "movie_charts"),
      menuItem("Most Popular Directors", tabName = "popular_directors"),
      menuItem("Search for a Movie", tabName = "search_movie"),
      menuItem("Data Table", tabName = "data_table")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "movie_charts",
        fluidRow(
          div(style = "display: flex; justify-content: space-between;",
              plotOutput("genre_pie_chart", width = "48%"),
              plotOutput("pie_chart", width = "50%")
          ),
          valueBoxOutput("top_year_box"),
          valueBoxOutput("top_month_box"),
          valueBoxOutput("average_rating_box"),
          plotOutput("ratings_bar_chart")
        )
      ),
      tabItem(
        tabName = "popular_directors",
        wordcloud2Output("wordcloud")
      ),
      tabItem(
        tabName = "search_movie",
        fluidRow(
          textInput("movie_name", "Movie name:"),
          actionButton("submit", "Submit")
        ),
        fluidRow(
          tags$br(),
          valueBoxOutput("movie_info_box")
        )
      ),
      tabItem(
        tabName = "data_table",
        DTOutput("data_table")
      )
    )
  )
)


