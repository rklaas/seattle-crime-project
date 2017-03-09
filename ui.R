library("shiny")
library("leaflet")
library("plotly")


ui <- fluidPage(theme = "bootstrap.min.css",
  titlePanel("School Data"), 
  
  h5("Navigate through the report"),
  
  column(12,p(HTML("<a href='#seattle_map'>View Map Data</a>"))),
  column(12,p(HTML("<a href='#seattle_plot'>View Plot Data</a>"))),
  column(12,p(HTML("<a href='#seattle_table'>View Summary Tables and Analysis</a> <br> "))),
  
  h3("Map Section"),
  
  p("Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space."),
  
  sidebarLayout(  # layout the page in two columns
    
    sidebarPanel(  # specify content for the "sidebar" column
      
      strong('Map Settings'),
      
      checkboxInput("show.schools.key", "Show School Locations?", FALSE),
      checkboxInput("show.heatmap.key", "Show Heatmap?", TRUE),
      
      strong('Filter schools:'),
      
      checkboxInput("elem.key", "Elementary Schools", TRUE),
      checkboxInput("middle.key", "Middle Schools", TRUE),
      checkboxInput("high.key", "Highschools", TRUE),
      
      br(),
      
      sliderInput('free.reduced.lunch.percentage.key', label = '% of Free/Reduced Lunch Students',
                  value = c(0, 85),
                  min = 0,
                  max = 85,
                  step = 3,
                  animate = animationOptions(interval = 1600)),
      
      br(),
      
      textInput("school.search.key", label = "Search for a school", value = "")
      
      #Search for a school
    ),
    
    mainPanel( # sets the tabs in the main panel
      
      #leafletOutput("seattle_map")
      leafletOutput("seattle_map",width="100%",height="700px")
    )
    
  ),
  
  h3("Plot Section"),
  
  p("Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space."),
  
  sidebarLayout(  # layout the page in two columns
    sidebarPanel(  # specify content for the "sidebar" column
      strong('Plot settings'),
      
      br(),
      
      selectInput("x.var.key", "X Axis:", selected = "% African American Students", 
                  c("School Rank" = 'rankStatewidePercentage' , "% African American Students" = 'percentofAfricanAmericanStudents', "% Asian American Students" = 'percentofAsianStudents', "% White Students" = 'percentofWhiteStudents', '% Free/Disc Lunch' = 'percentFreeDiscLunch')),
      
      selectInput("y.var.key", "Y Axis:",  selected = "School Rank", 
                  c("School Rank" = 'rankStatewidePercentage', "% African American Students" = 'percentofAfricanAmericanStudents', "% Asian American Students" = 'percentofAsianStudents', "% White Students" = 'percentofWhiteStudents', '% Free/Disc Lunch' = 'percentFreeDiscLunch'))
    ),
    
    mainPanel( # sets the tabs in the main panel
      plotlyOutput("seattle_plot")
    )
  ),
  
  h3("Summary tables and worst schools analysis"),
  
  p("Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
     Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space."),
  
  sidebarLayout(  # layout the page in two columns
    sidebarPanel(  
      # specify content for the "sidebar" column
      strong('Table settings'),
      
      #Include tables and summary data
      strong('Filter schools:'),
      
      # checkbox filters for viewing a certain type of school
      checkboxInput("elem.key.table", "Elementary Schools", TRUE),
      checkboxInput("middle.key.table", "Middle Schools", TRUE),
      checkboxInput("high.key.table", "Highschools", TRUE),
      
      # slider to alter min and max percent of african american students in the schools viewed in the table
      sliderInput('african.american.percentage.key.table', label = '% of African American Students',
                  value = c(0, 100),
                  min = 0,
                  max = 60),
      
      # displays average school rank
      h4("Average school rank: "), h4(textOutput("school_avg_rank")),
      
      # slider to adjust the min and max rank of the schools viewed in the table
      sliderInput('rank.key.table', label = 'School Rank',
                  value = c(0, 100),
                  min = 0,
                  max = 100),
      
      # displays the average percent of free and discount lunches offered at the schools viewed in the table
      h4("Average percent of free and discount lunch: "), h4(textOutput("school_avg_pfdl"))
    ),
    
    mainPanel( 
      # sets the tabs in the main panel
      tableOutput("seattle_table")
    )
    
  )
)

shinyUI(ui)