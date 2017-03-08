#install.packages("plotly")
library("ggplot2")
library("shiny")
library("dplyr")
library("plotly")
library("leaflet")

df.public.schools <- read.csv("public_school_data_full.csv")

server <- function(input, output) {
  
  # For the map
  reactive.data <- reactive({
    filter(df.public.schools, (schoolLevel == "Elementary" & input$elem.key) | (schoolLevel == "Middle" & input$middle.key) | (schoolLevel == "High" & input$high.key)) %>% 
      filter(input$School.Rank[1] <= rankStatewidePercentage & input$School.Rank[2] >= rankStatewidePercentage) %>% 
      filter(input$african.american.percentage.key[1] <= percentofAfricanAmericanStudents & input$african.american.percentage.key[2] >= percentofAfricanAmericanStudents) 
  })
  
  # plots the map of seattle
  output$seattle_map <- renderLeaflet({
    #Add Map code in here
  })
  
  # plots graph that the x and y axis can be changed
  output$seattle_plot <- renderPlotly({ 
    #Add Plotly code in here
  })
  
}

#creates the server out of the server function
shinyServer(server)
