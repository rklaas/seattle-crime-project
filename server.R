#install.packages("plotly")
library("ggplot2")
library("shiny")
library("dplyr")
library("plotly")
library("leaflet")

server <- function(input, output) {
  
  df.public.schools <- read.csv("public_school_data_full.csv")
  
  # For the map
  reactive.data <- reactive({
    filter(df.public.schools, (schoolLevel == "Elementary" & input$elem.key) | (schoolLevel == "Middle" & input$middle.key) | (schoolLevel == "High" & input$high.key)) %>% 
      filter(input$School.Rank[1] <= rankStatewidePercentage & input$School.Rank[2] >= rankStatewidePercentage) %>% 
      filter(input$african.american.percentage.key[1] <= percentofAfricanAmericanStudents & input$african.american.percentage.key[2] >= percentofAfricanAmericanStudents) 
  })
  
  pal <- colorQuantile("RdBu", df.public.schools$rankStatewidePercentage, n = 8)
  
  # plots the map of seattle
  output$seattle_map <- renderLeaflet({
    df.public.schools <- reactive.data()
    m <- leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron)
    
    #input$show.heatmap.key
    if(input$show.heatmap.key){
      m <- m %>% 
        addCircles(lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = df.public.schools$numberOfStudents* 3, fillOpacity = 0.1, color = pal(df.public.schools$rankStatewidePercentage)) %>% 
        addCircles(lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = df.public.schools$numberOfStudents* 2, fillOpacity = 0.1, color = pal(df.public.schools$rankStatewidePercentage)) %>% 
        addCircles(lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = df.public.schools$numberOfStudents, fillOpacity = 0.1, color = pal(df.public.schools$rankStatewidePercentage)) %>% 
        addCircles(lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = df.public.schools$numberOfStudents/2, fillOpacity = 0.1, color = pal(df.public.schools$rankStatewidePercentage)) %>% 
        addCircles(lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = df.public.schools$numberOfStudents/3, fillOpacity = 0.1, color = pal(df.public.schools$rankStatewidePercentage)) 
    }
    
    
    #input$show.schools.key
    if(input$show.schools.key){
      m <- addCircles(m, lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = 100, popup = paste0(df.public.schools$schoolName, ": ranked above ", df.public.schools$rankStatewidePercentage, "% of Seattle schools"), fillOpacity = 0.8, color = "Grey")
    }
    
    return(m)  # Print the map
  })
  
  # plots graph that the x and y axis can be changed
  output$seattle_plot <- renderPlotly({ 
    #Add Plotly code in here
  })
  
}

#creates the server out of the server function
shinyServer(server)
