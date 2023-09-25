library(shiny)
library(DT)
library(ggplot2)
library(plotly)
library(leaflet)
library(wordcloud2)
library(ggmap)

fluidPage(
  titlePanel("Lab 4: Popular Movies"),
  tabsetPanel(
    tabPanel("Movie Charts", 
             fluidRow(
               column(6, plotOutput("genre_pie_chart"))
             ),
             plotOutput("ratings_bar_chart")
             
    ),
    tabPanel("Most Popular Directors",
             wordcloud2Output("wordcloud")),
    
    tabPanel("Data Table", 
             DTOutput("data_table")
    )
  )
)

