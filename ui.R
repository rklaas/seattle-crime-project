library(shiny)

ui <- fluidPage(
  titlePanel("School Data"), 
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
                  max = 100),
      
      br(),
      
      strong('Plot settings'),
      
      radioButtons(inputId = 'x.axis', label = 'X-Axis Choices',
                   c('Percent African American' = 'percent.african.american',
                     'Percent White' = 'percent.white')),
      
      radioButtons(inputId = 'y.axis', label = 'Y-Axis Choices',
                   c('Percent Free/Discounted Lunch' = 'percent.free.disc.lunch',
                     'School Rank' = 'school.rank'))
    ),
    
    mainPanel( # sets the tabs in the main panel
      tabsetPanel(type = "tabs",
                  tabPanel("Map", plotOutput("seattle_map")),
                  tabPanel("Plots", plotOutput("seattle_plot"))
      )
    )
  )
)

shinyUI(ui)