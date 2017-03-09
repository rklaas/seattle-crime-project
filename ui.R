library("shiny")
library("leaflet")
library("plotly")

ui <- navbarPage("School Report",
        tabPanel('Introduction',
                  p('Insert Introduction')
        ),
        tabPanel("Map",
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
                  
              )
        ),
        tabPanel("Plot",
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
                )
        ), 
        tabPanel('Table',
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
        ),
        
        tabPanel('Conclusion',
                 p('Insert conclusion')
        )
)

shinyUI(ui)