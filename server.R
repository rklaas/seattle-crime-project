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
      filter(input$african.american.percentage.key[1] <= PercentOfAfricanAmericanStudents & input$african.american.percentage.key[2] >= PercentOfAfricanAmericanStudents) 
  })
  
  pal <- colorQuantile("RdBu", df.public.schools$RankStatewidePercentage, n = 7)
  
  # plots the map of seattle
  output$seattle_map <- renderLeaflet({
    public.schools.map.data <- public.schools.filtered()
    m <- leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) #Add B/W Map in background
    
    #input$show.heatmap.key
    if(input$show.heatmap.key){
      m <- m %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents* 3, fillOpacity = 0.1, color = pal(public.schools.map.data$RankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents* 2, fillOpacity = 0.1, color = pal(public.schools.map.data$RankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents, fillOpacity = 0.1, color = pal(public.schools.map.data$RankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/2, fillOpacity = 0.1, color = pal(public.schools.map.data$RankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/3, fillOpacity = 0.1, color = pal(public.schools.map.data$RankStatewidePercentage)) 
    }
    
    
    #input$show.schools.key
    m <- addCircles(m, lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = 50 + df.public.schools$numberOfStudents/20, 
      popup = paste0(df.public.schools$schoolName, " (", df.public.schools$numberOfStudents, " students): ranked above ", df.public.schools$RankStatewidePercentage, "% of Seattle schools. (Demographics: ", df.public.schools$PercentOfWhiteStudents, "% White, ", df.public.schools$PercentOfAfricanAmericanStudents, "% African American, ", df.public.schools$percentofAsianStudents, "% Asian, ", df.public.schools$percentofHispanicStudents, "% Hispanic, and ", df.public.schools$percentofTwoOrMoreRaceStudents, "% Mixed Race. ", df.public.schools$PercentFreeDiscLunch, "% of students at this school are on free/discounted lunch)" ), 
      fillOpacity = 0.8 * as.numeric(!is.na(match(df.public.schools$OBJECTID, public.schools.filtered()$OBJECTID)) & input$show.schools.key), #Rather than redraw points, just make unselected points (points not present in the filtered database) opaque; as.numeric(FALSE) = 0, AKA fully transluctent
      color = "Grey")
    
    return(m)  # Print the map
  })
  
  # plots graph that the x and y axis can be changed
  output$seattle_plot <- renderPlot({ 
    x.label <- gsub("([[:upper:]][[:lower:]])", "\\2 \\1", input$x.var.key)
    y.label <- gsub("([[:upper:]][[:lower:]])", "\\2 \\1", input$y.var.key)
    p <- ggplot(data = public.schools.filtered())+
      geom_point(mapping = aes(x = get(input$x.var.key), y = get(input$y.var.key), text = SCHOOL)) +
      geom_smooth(mapping = aes(x = get(input$x.var.key), y = get(input$y.var.key))) +
      labs(x = x.label, y = y.label)
    #p <- ggplotly(p)    
    #plot_ly(df.public.schools, x = ~percentofWhiteStudents, y = ~percentFreeDiscLunch)  
    return(p)
  })
  
  output$seattle_table <- renderTable({
    zip.summaries <- df.public.schools %>%
      group_by(ZIP) %>% 
      summarise(round(mean(RankStatewidePercentage, na.rm = TRUE)), round(mean(PercentOfAfricanAmericanStudents)), mean(PercentFreeDiscLunch), round(mean(PercentOfWhiteStudents)))
  })
  
}

#creates the server out of the server function
shinyServer(server)

 