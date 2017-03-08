library(shiny)

ui <- fluidPage(
  titlePanel("School Data"), 
  
  strong("Navigate through the report"),

  column(12,p(HTML("<a href='#seattle_map'>View Map Data</a>"))),
  column(12,p(HTML("<a href='#seattle_plot'>View Plot Data</a>"))),
  # column(12,p(HTML("<a href='#seattle_map'>View Map Data</a>"))),
  
  h3(strong("Map Section")),
  
  h5("Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
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
      
      radioButtons(inputId = 'school.type', label = 'School Type',
                   c('Elementary' = 'Elementary',
                     'Middle School' = 'Middle School',
                     'High School' = 'High School')),
      
      br(),
      
      sliderInput('School.Rank', label = 'School Rank',
                  value = c(25, 75),
                  min = 0,
                  max = 100)
    ),
    
    mainPanel( # sets the tabs in the main panel
      plotOutput("seattle_map")
    )
    
  ),
  
  h3(strong("Plot Section")),
  
  h5("Large block of text to take up space and test the 'jumping to element by click'. This text will be repeated 9 times to take up space.
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
      
      radioButtons(inputId = 'x.axis', label = 'X-Axis Choices',
                   c('Percent African American' = 'percent.african.american',
                     'Percent White' = 'percent.white')),
      
      radioButtons(inputId = 'y.axis', label = 'Y-Axis Choices',
                   c('Percent Free/Discounted Lunch' = 'percent.free.disc.lunch',
                     'School Rank' = 'school.rank'))
    ),
    
    mainPanel( # sets the tabs in the main panel
      plotOutput("seattle_plot")
    )
    
  )
)

shinyUI(ui)