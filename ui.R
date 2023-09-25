library(shiny)
library(DT)

fluidPage(
  titlePanel("Lab 4: Popular Movies"),
  tabsetPanel(
    tabPanel("Movie Charts", 
             plotOutput("genre_pie_chart")
    ),
    tabPanel("Data Table", 
             DTOutput("data_table")
    )
  )
)


