library("ggplot2")
library("shiny")
library("dplyr")
library("plotly")
library("leaflet")

server <- function(input, output) {
  
  df.public.schools <- read.csv("public_school_data_full.csv")
  
  #For the map, filters the dataframe based on selected widgets
  public.schools.filtered <- reactive({
    df.schools.searched <- df.public.schools[grep(tolower(input$school.search.key), tolower(df.public.schools$NAME)),] %>% #Look up schools with matching strings
      filter((schoolLevel == "Elementary" & input$elem.key) | (schoolLevel == "Middle" & input$middle.key) | (schoolLevel == "High" & input$high.key)) %>% #Filter by school level
      filter(input$free.reduced.lunch.percentage.key[1] <= percentFreeDiscLunch & input$free.reduced.lunch.percentage.key[2] >= percentFreeDiscLunch) %>%  #Fiter by % of Free/Reduced lunch students
      filter(input$african.american.percentage.key[1] <= percentofAfricanAmericanStudents & input$african.american.percentage.key[2] >= percentofAfricanAmericanStudents) #Filter by % of African American Students
    
    return(df.schools.searched)
  })

  pal <- colorQuantile("RdBu", df.public.schools$rankStatewidePercentage, n = 4) #creating a palette for the map (Red = Low-ranking schols, Blue = High-ranking schools)
  
  #Plots the map of seattle
  output$seattle_map <- renderLeaflet({
    public.schools.map.data <- public.schools.filtered() %>% 
      filter(NAME != "Roosevelt") #Rendering Roosevelt makes the map busy and difficult to read, exclude it in the heatmap
    m <- leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) #Add B/W Map in background
    
    #input$show.heatmap.key
    if(input$show.heatmap.key){
      
      #Add the heatmap
      m <- m %>% 
        #This looks ridiculous, essentially we're drawing 6 translucent circles on top of eachother, each with smaller radius than the last. Creates the school-ranking radii that encircle each school
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents* 3, fillOpacity = 0.047, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents* 2, fillOpacity = 0.057, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents, fillOpacity = 0.084, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/2, fillOpacity = 0.084, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/4, fillOpacity = 0.1025, color = pal(public.schools.map.data$rankStatewidePercentage)) %>% 
        addCircles(lng=public.schools.map.data$Longitude, lat=public.schools.map.data$Latitude, weight = 0, radius = public.schools.map.data$numberOfStudents/7, fillOpacity = 0.195, color = pal(public.schools.map.data$rankStatewidePercentage)) 
    }
    
    #Add the actual points for each school. Points are always rendered, just made fully translucent if "Show schools" is unselected
    m <- addCircles(m, lng=df.public.schools$Longitude, lat=df.public.schools$Latitude, weight = 0, radius = 50 + df.public.schools$numberOfStudents/20, 
                    popup = paste0("<b>", df.public.schools$schoolName, "</b> (", df.public.schools$numberOfStudents, " students): </br>-Ranked above ", df.public.schools$rankStatewidePercentage, "% of Washington schools. </br>-", df.public.schools$percentFreeDiscLunch, "% of students at this school are on free/discounted lunch)",  "</br></br>(Demographics: ", df.public.schools$percentofWhiteStudents, "% White, ", df.public.schools$percentofAfricanAmericanStudents, "% African American, ", df.public.schools$percentofAsianStudents, "% Asian, ", df.public.schools$percentofHispanicStudents, "% Hispanic, and ", df.public.schools$percentofTwoOrMoreRaceStudents, "% Mixed Race)"), 
                    fillOpacity = 0.8 * as.numeric(!is.na(match(df.public.schools$OBJECTID, public.schools.filtered()$OBJECTID)) & input$show.schools.key), #Rather than redraw points, just make unselected points (points not present in the filtered database) opaque; as.numeric(FALSE) = 0, AKA fully transluctent
                    color = "Grey")
    
    return(m)  # Return the map
  })
  
  #Nice looking axes names for the plot
  axis.names <- reactive({
    
    #This list essentially "undoes" the selectInput, converting variable names into human-readable descriptions
    axis.names.list <- list("rankStatewidePercentage" = "% of Washington Schools this ranked above", 'percentofAfricanAmericanStudents' = "% African American Students", 'percentofHispanicStudents' = "% Hispanic Students", 'percentofWhiteStudents' = "% White Students", 'percentFreeDiscLunch' = '% Free/Disc Lunch', "pupilTeacherRatio" = "Pupil teacher ratio", 'percentofAsianStudents' = "% Asian American Students")
    
    x.name <- axis.names.list[[input$x.var.key]] #IE: rankStateWidePercentage becomes "% of Washington Schools this ranked above" 
    y.name <- axis.names.list[[input$y.var.key]]
    
    return(c(x.name, y.name)) #Return those two human-readable names as a vector
  })
  
  # Plots graph, x and y axis can be changed
  output$seattle_plot <- renderPlotly({
    
    #Create a plotly scatterplot
    p <- plot_ly(df.public.schools, 
                 x = ~get(input$x.var.key), y = ~get(input$y.var.key), #Set axes to display the x.var.key and y.var.key
                 type = 'scatter', 
                 mode = 'markers',
                 alpha = 0.8,
                 size = ~numberOfStudents,
                 hoverinfo = 'text',
                 
                 #Add text labels for when users hover over points
                 text = ~paste0('School: ', SCHOOL, 
                                '</br>', axis.names()[1], ': ', get(input$x.var.key), "%" , 
                                '</br>', axis.names()[2], ': ', get(input$y.var.key), "%" ,
                                '</br>(School size:', numberOfStudents, ' students)')) %>% 
            layout(xaxis = list(title = axis.names()[1]), yaxis = list(title = axis.names()[2])) #Rename the axes into human-readable form
    return(p) #Return that scatterplot
  })
  
  #creates table to display filtered by input sliders and checkboxes
  output$seattle_table <- renderDataTable({
    
    #selects appropriate filters and filter specified columns by the values in the input sliders
    df.public.schools.table <- select(df.public.schools, NAME, ZIP, schoolLevel, numberOfStudents, percentFreeDiscLunch, 
                                      percentofAfricanAmericanStudents, pupilTeacherRatio, rankStatewidePercentage) %>%
      #Filter for school level
      filter((schoolLevel == "Elementary" & input$elem.key.table) | 
               (schoolLevel == "Middle" & input$middle.key.table) | 
               (schoolLevel == "High" & input$high.key.table)) %>%
      #Filter for African American percentage
      filter(input$african.american.percentage.key.table[1] <= percentofAfricanAmericanStudents & 
               input$african.american.percentage.key.table[2] >= percentofAfricanAmericanStudents) %>% 
      #Filter for school rank
      filter(input$rank.key.table[1] <= rankStatewidePercentage & 
               input$rank.key.table[2] >= rankStatewidePercentage)
    
    #Turn those table columns into human-readable names
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
    
    school.rank.mean <- mean(df.public.schools.table[,7], trim = 0.5, na.rm = TRUE)
    
    #Handle for an empty data set
    if(is.na(school.rank.mean)){
      school.rank.mean <- "No data available"
    } else {
      #Add a % on the end of the data if it returns a value
      school.rank.mean <- paste0(school.rank.mean, "%")
    }
    
    #Return the mean of school as a string for display
    return(school.rank.mean) 
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
    
    percentage.free.reduced.lunch.mean <- mean(df.public.schools.table[,4], trim = 0.5, na.rm = TRUE)
    
    #Handle for an empty data set
    if(is.na(percentage.free.reduced.lunch.mean)){
      percentage.free.reduced.lunch.mean <- "No data available"
    } else {
      #Add a % on the end of the data if it returns a value
      percentage.free.reduced.lunch.mean <- paste0(percentage.free.reduced.lunch.mean, "%")
    }
    
    #Return that string for display
    return(percentage.free.reduced.lunch.mean)
  })
  
  #Creates a text output of Rainier Beach statistics for use with the conclusion
  output$insights <- renderText({
    insight.text <- paste0("Rainier Beach stood out in particular, with a student body of ", 
                           df.public.schools[8,39], #Total count of Rainier Beach students
                           " students, ranking above only ", 
                           df.public.schools[8,60], #School ranking of Rainier Beach
                           "% of Washington schools. What makes Rainier Beach peculiar though is its incredibly high % of African Americans (", 
                           df.public.schools[8,41], #% African American
                           "% African American), and a student population largely on free and reduced lunch (", 
                           df.public.schools[8,40], #% Free/Reduced Lunch
                           "% of the student body)."  )
    return(insight.text) #Return that string for rendering in the conclusion
  })
}