library("shiny")
library("leaflet")
library("plotly")

ui <- navbarPage("School Report",
                 tabPanel('Introduction',
                          h1('AA'),
                          p('Insert Introduction')
                 ),
                 tabPanel("Map",
                          
                          h1('Mapping Seattle School Quality'),
                          
                          p("The goal in this graph is to demonstrate geographical trends in school quality around seattle. Schools across Seattle are plotted according to their quality (Blue means high-ranking schools, red represents low-ranking schools), with size proportinate to their student population. Schools can also be clicked on for more details! Zoom in on grey dots for information on those schools. In addition, the search bar can be used to find individual schools and their details. Finally a slider can be used to select a range of schools that fall within a specified % of free/reduced lunch students (IE- Schools where 20%-30% of the student body utilizes free/reduced lunch)"),
                          p("This map helps to demonstrate the severe divide between North and South Seattle schools. The southern region including South Shore and Rainier Beach in particular stands out an extreme pocket of low-quality schools and poverty. Adjusting the free/discounted lunch % slider (an indicator of student poverty) demonstrates a clear concentration of impoverished and poorly-performing schools in South Seattle, whereas North Seattle is home to far more wealthy public student bodies and high-quality schools (of primarily white student bodies)."),
                          
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

                              textInput("school.search.key", label = "Search for a school", value = "")
                              
                              #Search for a school
                            ),
                            
                            mainPanel( # sets the tabs in the main panel
                              #leafletOutput("seattle_map")
                              leafletOutput("seattle_map",width="100%",height="600px")
                            )
                          )
                 ),
                 tabPanel("Plot",
                          h1('Correlations Between Seattle Schools Demographics'),
                          p('This interactive plot provides a sandbox for users to explore correlations in the Seattle Schools dataset. Users are able to customize the plot axis based on a variety of variables (% of Asian/African American/White students, school ranking, and % of student body that utilizes free and reduced lunch). Schools with more students are plotted larger, and every point can be hovered over for more details on that individual school.'),
                          p("The plot comparing % of African American students and school ranking in particular shows a clear negative correlation, suggesting that African Americans are overwhelmingly placed in poorly performing schools. There's also a clear correlation between % African Americans and % Free/Discounted lunch suggesting not just that these students are placed into poorly performing schools, but also that school performance is a symptom of overwhelming poverty in the student body. Most of the lowest ranking schools (Rainier Beach, Emerson, and South Shore amongst others) are concentrated in South Seattle."),
                          
                          sidebarLayout(  # layout the page in two columns                 
                            sidebarPanel(  # specify content for the "sidebar" column
                              strong('Plot settings'),
                              
                              br(),
                              
                              selectInput("x.var.key", "X Axis:", selected = "% African American Students", 
                                          c("School Rank" = 'rankStatewidePercentage' , "% African American Students" = 'percentofAfricanAmericanStudents', "% Hispanic Students" = 'percentofHispanicStudents', "% Asian American Students" = 'percentofAsianStudents', "% White Students" = 'percentofWhiteStudents', '% Free/Disc Lunch' = 'percentFreeDiscLunch')),
                              
                              selectInput("y.var.key", "Y Axis:",  selected = "School Rank", 
                                          c("School Rank" = 'rankStatewidePercentage', "% African American Students" = 'percentofAfricanAmericanStudents',"% Hispanic Students" = 'percentofHispanicStudents', "% Asian American Students" = 'percentofAsianStudents', "% White Students" = 'percentofWhiteStudents', '% Free/Disc Lunch' = 'percentFreeDiscLunch'))
                            ),
                            
                            mainPanel( # sets the tabs in the main panel
                              plotlyOutput("seattle_plot")
                            )
                          )
                 ), 
                 tabPanel('Table',
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
                              dataTableOutput("seattle_table")
                            )
                          )
                 
                 ),
                 
                 tabPanel('Conclusion',
                          p('Insert conclusion')
                 )
)

shinyUI(ui)
