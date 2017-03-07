#install.packages("plotly")
library("ggplot2")
library("ggmap")
library("shiny")
library("dplyr")
library("plotly")

server <- function(input, output) {
  
  load(file = 'schools_names.jpg')
  
  
  # create map of seattle
  seattle_map.seattle_city <- qmap("seattle", zoom = 11, source="stamen", maptype="toner",darken = c(.3,"#BBBBBB"))
  
  # Combine the selected variables into a new data frame, for the graph
  selectedData <- reactive({
    df.public.schools[, c(input$x.axis, input$y.axis)]
  })
  
  # For the map
  reactive.data <- reactive({
    filter(df.public.schools, input$school.type == TYPE) %>% 
      filter(input$School.Rank[1] <= school.rank & input$School.Rank[2] >= school.rank)
  })
  
  # I dont know why I cant output the map to the map tab and the graph to the plot tab
  
  # plots the map of seattle
  output$seattle_map <- renderPlot({
    reactive.data <- data.frame(reactive.data())
    seattle_map.seattle_city +
      geom_point(data = reactive.data, aes(x=Longitude, y=Latitude), color="dark green", size=1)
  })
  
  # plots graph that the x and y axis can be changed
  output$seattle_plot <- renderPlot({ #switch to renderPlotly for plotly
    selectedData <- data.frame(selectedData())
    my.plot <- ggplot(data = selectedData, aes(x = selectedData[1], y = selectedData[2])) +
      geom_point() +
      # need to fix x and y axis names so they dont have a period in them also, dont know what to do with title
      labs(x = input$x.axis, y = input$y.axis, title = 'The Graph')
    return(my.plot)
    
    # some stuff as I was trying to get plotly to work
    
    #print(ggplotly(my.plot))  
    #gg <- plotly_build(my.plot)
    #renderPlotly(my.plot, env = parent.frame(), quoted = FALSE)
    #plot_ly(df.public.schools, x = ~percent.african.american, y = ~percent.free.disc.lunch)
    
  })
  
}

#creates the server out of the server function
shinyServer(server)
