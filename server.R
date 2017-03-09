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
    df.schools.searched <- df.public.schools[grep(tolower(input$school.search.key), tolower(df.public.schools$NAME)),] %>% #Look up schools with matching strings
      filter((schoolLevel == "Elementary" & input$elem.key) | (schoolLevel == "Middle" & input$middle.key) | (schoolLevel == "High" & input$high.key)) %>% #Filter by school level
      filter(input$free.reduced.lunch.percentage.key[1] <= percentFreeDiscLunch & input$free.reduced.lunch.percentage.key[2] >= percentFreeDiscLunch) #Fiter by # of African Americans
    
    return(df.schools.searched)
  })
  
  test <- df.public.schools %>% 
    filter(SCHOOL, contains("g"))
  
  #7 cuts
  pal <- colorQuantile("RdBu", df.public.schools$rankStatewidePercentage, n = 4)
  
  # plots the map of seattle
  output$seattle_map <- renderLeaflet({
    public.schools.map.data <- public.schools.filtered() %>% 
      filter(NAME != "Roosevelt") #Rendering roosevelt makes the map unreadable, exclude it in the heatmap
    m <- leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) #Add B/W Map in background
    
    #input$show.heatmap.key
    if(input$show.heatmap.key){
      m <- m %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents* 3, fillOpacity = 0.037, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents* 2, fillOpacity = 0.037, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents, fillOpacity = 0.074, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/2, fillOpacity = 0.074, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/4, fillOpacity = 0.0925, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/7, fillOpacity = 0.185, color = pal(public.schools.map.data$rankStatewidePercentage)) 
    }
    
    
    #input$show.schools.key

    m <- addCircles(m, lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = 50 + df.public.schools$numberOfStudents/20, 
                    popup = paste0("<b>", df.public.schools$schoolName, "</b> (", df.public.schools$numberOfStudents, " students): </br>-Ranked above ", df.public.schools$rankStatewidePercentage, "% of Seattle schools. </br>-", df.public.schools$percentFreeDiscLunch, "% of students at this school are on free/discounted lunch)",  "</br></br>(Demographics: ", df.public.schools$percentofWhiteStudents, "% White, ", df.public.schools$percentofAfricanAmericanStudents, "% African American, ", df.public.schools$percentofAsianStudents, "% Asian, ", df.public.schools$percentofHispanicStudents, "% Hispanic, and ", df.public.schools$percentofTwoOrMoreRaceStudents, "% Mixed Race)"), 
                    fillOpacity = 0.8 * as.numeric(!is.na(match(df.public.schools$OBJECTID, public.schools.filtered()$OBJECTID)) & input$show.schools.key), #Rather than redraw points, just make unselected points (points not present in the filtered database) opaque; as.numeric(FALSE) = 0, AKA fully transluctent
                    color = "Grey")
    
    return(m)  # Print the map
  })
  
  axis.names <- reactive({
    axis.names.list <- list("rankStatewidePercentage" = "% of Schools this ranked above", 'percentofAfricanAmericanStudents' = "% African American Students", 'percentofHispanicStudents' = "% Hispanic Students", 'percentofWhiteStudents' = "% White Students", 'percentFreeDiscLunch' = '% Free/Disc Lunch', "pupilTeacherRatio" = "Pupil teacher ratio", 'percentofAsianStudents' = "% Asian American Students")
    
    x.name <- axis.names.list[[input$x.var.key]]
    y.name <- axis.names.list[[input$y.var.key]]
    
    return(c(x.name, y.name))
  })
  
  # Plots graph, x and y axis can be changed
  output$seattle_plot <- renderPlotly({
    p <- plot_ly(filter(df.public.schools, !is.na(rankStatewidePercentage)), x = ~get(input$x.var.key), y = ~get(input$y.var.key), type = 'scatter', mode = 'markers',
                 hoverinfo = 'text',
                 alpha = 0.8,
                 size = ~numberOfStudents,
                 text = ~paste0('School: ', SCHOOL, 
                                '</br>', axis.names()[1], ': ', get(input$x.var.key), "%" , 
                                '</br>', axis.names()[2], ': ', get(input$y.var.key), "%" ,
                                '</br>(School size:', numberOfStudents, ' students)')) %>% 
      layout(xaxis = list(title = axis.names()[1]), yaxis = list(title = axis.names()[2]))
    
    
    p <- ggplotly(p)
    return(p)
  })
  
  # variable inputs which alter the outputs below
  inputs <- reactive({
    input$elem.key.table
    input$middle.key.table
    input$high.key.table
    input$african.american.percentage.key.table
    input$rank.key.table
  })
  
  # creates table to display filtered by input sliders and checkboxes
  output$seattle_table <- renderDataTable({
    
    #selects appropriate filters and filter specified columns by the values in the input sliders
    df.public.schools.table <- select(df.public.schools, NAME, ZIP, schoolLevel, numberOfStudents, percentFreeDiscLunch, 
                                      percentofAfricanAmericanStudents, pupilTeacherRatio, rankStatewidePercentage) %>%
      filter((schoolLevel == "Elementary" & input$elem.key.table) | 
               (schoolLevel == "Middle" & input$middle.key.table) | 
               (schoolLevel == "High" & input$high.key.table)) %>%
      filter(input$african.american.percentage.key.table[1] <= percentofAfricanAmericanStudents & 
               input$african.american.percentage.key.table[2] >= percentofAfricanAmericanStudents) %>% 
      filter(input$rank.key.table[1] <= rankStatewidePercentage & 
               input$rank.key.table[2] >= rankStatewidePercentage)
    
    colnames(df.public.schools.table) <- c("School", "ZIP", "Type", "# of Students", "% Free/Reduced Lunch Students", "% of African Americans", "Students per Teacher", "School Ranking (out of 100)")
    
    return(df.public.schools.table)
    
  })
  
  # returns the average rank of all of the selected schools
  output$school_avg_rank <- renderText({
    #selects appropriate filters and filter specified columns by the values in the input sliders
    df.public.schools.table <- select(df.public.schools, NAME, schoolLevel, numberOfStudents, percentFreeDiscLunch, 
                                      percentofAfricanAmericanStudents, pupilTeacherRatio, rankStatewidePercentage) %>%
      filter((schoolLevel == "Elementary" & input$elem.key.table) | 
               (schoolLevel == "Middle" & input$middle.key.table) | 
               (schoolLevel == "High" & input$high.key.table)) %>%
      filter(input$african.american.percentage.key.table[1] <= percentofAfricanAmericanStudents & 
               input$african.american.percentage.key.table[2] >= percentofAfricanAmericanStudents) %>% 
      filter(input$rank.key.table[1] <= rankStatewidePercentage & 
               input$rank.key.table[2] >= rankStatewidePercentage)
    return(round(mean(df.public.schools.table[,7], na.rm = TRUE))) 
  })
  
  # returns the average percent of free and reduced lunches for all selected schools
  output$school_avg_pfdl <- renderText({
    #selects appropriate filters and filter specified columns by the values in the input sliders
    df.public.schools.table <- select(df.public.schools, NAME, schoolLevel, numberOfStudents, percentFreeDiscLunch, 
                                      percentofAfricanAmericanStudents, pupilTeacherRatio, rankStatewidePercentage) %>%
      filter((schoolLevel == "Elementary" & input$elem.key.table) | 
               (schoolLevel == "Middle" & input$middle.key.table) | 
               (schoolLevel == "High" & input$high.key.table)) %>%
      filter(input$african.american.percentage.key.table[1] <= percentofAfricanAmericanStudents & 
               input$african.american.percentage.key.table[2] >= percentofAfricanAmericanStudents) %>% 
      filter(input$rank.key.table[1] <= rankStatewidePercentage & 
               input$rank.key.table[2] >= rankStatewidePercentage)
    return(round(mean(df.public.schools.table[,4], na.rm = TRUE)))
  })
}

#creates the server out of the server function
shinyServer(server)