library("shiny")
library("leaflet")


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
      
      checkboxInput("show.schools.key", "Show School Locations?", TRUE),
      checkboxInput("show.heatmap.key", "Show Heatmap?", TRUE),
      
      strong('Filter schools:'),
      
      checkboxInput("elem.key", "Elementary Schools", TRUE),
      checkboxInput("middle.key", "Middle Schools", TRUE),
      checkboxInput("high.key", "Highschools", TRUE),
      
      br(),
      
      sliderInput('african.american.percentage.key', label = '% of African American Students',
                  value = c(0, 100),
                  min = 0,
                  max = 60,
                  step = 3,
                  animate = animationOptions(interval = 1600))
    ),
    
    mainPanel( # sets the tabs in the main panel
      leafletOutput("seattle_map")
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
                  c("School Rank" = 'rankStatewidePercentage' , "% African American Students" = 'percentofAfricanAmericanStudents', "% White Students" = 'percentofWhiteStudents', '% Free/Disc Lunch' = 'percentFreeDiscLunch', "Pupil teacher ratio" = "pupilTeacherRatio")),
      
      selectInput("y.var.key", "Y Axis:",  selected = "School Rank", 
                  c("School Rank" = 'rankStatewidePercentage', "% African American Students" = 'percentofAfricanAmericanStudents', "% White Students" = 'percentofWhiteStudents', '% Free/Disc Lunch' = 'percentFreeDiscLunch', "Pupil teacher ratio" = "pupilTeacherRatio"))
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
    sidebarPanel(  # specify content for the "sidebar" column
      strong('Table settings')
    ),
    
    mainPanel( # sets the tabs in the main panel
      tabsetPanel(type = "tabs", 
        tabPanel("Tables",
          p("this is where the tables go")
        )
      )
    )
  )
)

shinyUI(ui)