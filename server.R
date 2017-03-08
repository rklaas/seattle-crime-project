#install.packages("plotly")
library("ggplot2")
library("shiny")
library("dplyr")
library("plotly")
library("leaflet")

server <- function(input, output) {
  
  df.public.schools <- read.csv("public_school_data_full.csv")
  
  # For the map
  public.schools.filtered <- reactive({
    filter(df.public.schools, (schoolLevel == "Elementary" & input$elem.key) | (schoolLevel == "Middle" & input$middle.key) | (schoolLevel == "High" & input$high.key)) %>% 
      filter(input$african.american.percentage.key[1] <= percentofAfricanAmericanStudents & input$african.american.percentage.key[2] >= percentofAfricanAmericanStudents) 
  })
  
  pal <- colorQuantile("RdBu", df.public.schools$rankStatewidePercentage, n = 7)
  
  # plots the map of seattle
  output$seattle_map <- renderLeaflet({
    public.schools.map.data <- public.schools.filtered()
    m <- leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron)
    
    #input$show.heatmap.key
    if(input$show.heatmap.key){
      m <- m %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents* 3, fillOpacity = 0.1, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents* 2, fillOpacity = 0.1, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents, fillOpacity = 0.1, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/2, fillOpacity = 0.1, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/3, fillOpacity = 0.1, color = pal(public.schools.map.data$rankStatewidePercentage)) 
    }
    
    
    #input$show.schools.key
    if(input$show.schools.key){
      m <- addCircles(m, lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = 50 + public.schools.map.data$numberOfStudents/20, 
        popup = paste0(public.schools.map.data$schoolName, " (", public.schools.map.data$numberOfStudents, " students): ranked above ", public.schools.map.data$rankStatewidePercentage, "% of Seattle schools. (Demographics: ", public.schools.map.data$percentofWhiteStudents, "% White, ", public.schools.map.data$percentofAfricanAmericanStudents, "% African American, ", public.schools.map.data$percentofAsianStudents, "% Asian, ", public.schools.map.data$percentofHispanicStudents, "% Hispanic, and ", public.schools.map.data$percentofTwoOrMoreRaceStudents, "% Mixed Race. ", public.schools.map.data$percentFreeDiscLunch, "% of students at this school are on free/discounted lunch)" ), 
        fillOpacity = 0.8, color = "Grey")
    }
    
    return(m)  # Print the map
  })
  
  # plots graph that the x and y axis can be changed
  output$seattle_plot <- renderPlotly({ 
    #Add Plotly code in here
  })
  
  output$seattle_table <- renderTable({
    #Add Table code in here
  })
  
}

#creates the server out of the server function
shinyServer(server)
