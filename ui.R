library("shiny")
library("leaflet") #For the school map
library("plotly") #For the scatterplots

ui <- navbarPage("Segregated Seattle", 
                 theme = "bootstrap.min.css",
                 selected = 'Map', #Default to the map panel
                 
                 #About panel
                 tabPanel('About',
                          h1('Segregated Seattle:'),
                          h4('Mapping Racial Inequalities With Seattle Schools Data'),
                          p('This project started as an exploration of the relation between crime rates in Seattle and the quality of schools in areas affected by crime. In exploring the data, we quickly discovered strong correlations between racial demographics in Seattle schools and their respective test scores, prompting further exploration. Soon, we decided to map the data, discovering a strong divide between North and South Seattle school rankings. What we present today, is the synthesis of our insights from examining Seattle school data; primarily that minority races in Seattle are overwhelmingly placed in poorly performing schools, and that this phenomenon dispoportinately affects African Americans.'),
                          p("Data for this project was pulled from the", a("Seattle Public Schools Dataset", href="https://catalog.data.gov/dataset/public-schools-2d727"), " and merged with data called from the ", a("SchoolDigger API", href="https://developer.schooldigger.com/"), " for further information on school demographics, as well as state-wide school rankings for 2016"),
                          em('This project was a collaboration between INFO 201 students Ian Wohlers, Roger Klaaskate, and Brandon Kinard')
                          
                 ),
                 
                 #Map panel
                 tabPanel("Map",
                          
                          h1('Mapping Seattle School Quality'),
                          
                          p("The goal in this graph is to demonstrate geographical trends in school quality around seattle. Schools across Seattle are plotted according to their ranking (Blue means high-ranking schools, red represents low-ranking schools calculated via average test scores from the SchoolDigger API), with size proportinate to their student population. Schools can also be clicked on for more details! Zoom in on grey dots for information on those schools. In addition, the search bar can be used to find individual schools and their details. Finally a two sliders exist that can be used to select a range of schools that fall within a specified % of free/reduced lunch students and % of African American students (IE- filter for schools where 20%-30% of the student body utilizes free/reduced lunch)"),
                          p("This map helps to demonstrate the severe divide between North and South Seattle schools. The southern region including South Shore and Rainier Beach in particular stands out an extreme pocket of low-ranking schools and poverty. Adjusting the free/discounted lunch % slider (an indicator of student poverty) demonstrates a clear concentration of impoverished and poorly-performing schools in South Seattle, whereas North Seattle is home to far more wealthy public student bodies and high-ranking schools (of primarily white student bodies)."),
                          
                          sidebarLayout(  # layout the page in two columns
                            
                            sidebarPanel(  # specify content for the "sidebar" column
                              
                              strong('Map Settings'),
                              
                              #Allows the user to hide/show map elements
                              checkboxInput("show.schools.key", "Show School Locations?", FALSE),
                              checkboxInput("show.heatmap.key", "Show Heatmap?", TRUE),
                              
                              strong('Filter schools:'),
                              
                              #Allows user to filter by school level
                              checkboxInput("elem.key", "Elementary Schools", TRUE),
                              checkboxInput("middle.key", "Middle Schools", TRUE),
                              checkboxInput("high.key", "Highschools", TRUE),
                              
                              br(),
                              
                              #Allows for filtering of map by African American %
                              sliderInput('african.american.percentage.key', label = '% of African American Students',
                                          value = c(0, 60),
                                          min = 0,
                                          max = 60,
                                          step = 3,
                                          animate = animationOptions(interval = 1600)),
                              
                              #Allows for filtering of map by free/reduced lunch %
                              sliderInput('free.reduced.lunch.percentage.key', label = '% of Free/Reduced Lunch Students',
                                          value = c(0, 85),
                                          min = 0,
                                          max = 85,
                                          step = 3,
                                          animate = animationOptions(interval = 1600)),
                              
                              #Allows for searching of schools
                              textInput("school.search.key", label = "Search for a school", value = "")
                            ),
                            
                            mainPanel( # sets the tabs in the main panel
                              #leafletOutput("seattle_map")
                              leafletOutput("seattle_map",width="100%",height="600px")
                            )
                          )
                 ),
                 
                 #Plot panel
                 tabPanel("Plot",
                          h1('Correlations Between Seattle Schools Demographics'),
                          p('This interactive plot provides a sandbox for users to explore correlations in the Seattle Schools dataset. Users are able to customize the plot axis based on a variety of variables (% of Asian/African American/White students, school ranking, and % of student body that utilizes free and reduced lunch). Schools with more students are plotted larger, and every point can be hovered over for more details on that individual school.'),
                          p("The plot comparing % of African American students and school ranking in particular shows a clear negative correlation, suggesting that African Americans are overwhelmingly placed in poorly performing schools. There's also a clear correlation between % Free/Discounted lunch and school ranking, suggesting not just that these students are placed into poorly performing schools, but also that school performance is a symptom of overwhelming poverty in the student body. Most of the lowest ranking schools (Rainier Beach, Emerson, and South Shore amongst others) are concentrated in South Seattle."),
                          
                          sidebarLayout(  # layout the page in two columns                 
                            sidebarPanel(  # specify content for the "sidebar" column
                              strong('Plot settings'),
                              
                              br(),
                              
                              #Two select inputs for X vars and Y vars respectively (x.var.key and y.var.key)
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
                 
                 #Table panel
                 tabPanel('Table',
                          h1('Summary Statistics Used For Analysis'),
                          
                          p('This interactive table provides a adjustable view for users to read the data from the Seattle 
                              Schools dataset. Users are able to customize the column valuesbased on a variety of variables 
                              (whether or not the school is an elementary, middle, or high school, % of African American Students,
                              and school rank).'),
                          
                          p('From the table we can see that as the percent of African American students increase, the average school
                              rank decreases. For example when the range is set between 0% and 10% the schools are, on average, better
                              than 83% of other schools. Alternatively, when the percent is set between 50 and 60% the the schools are, 
                              on average, better than only 25% of other schools. You can also see a drastic change in the number of free
                              and discounted lunches where schools with between 0% and 10% African American students have an, on average
                              15% of students receiving free or discounted lunches compared to 72% of students receiving free or discounted
                              lunches in schools with between 50 and 60% African American students. Again, here there is a clear 
                              correlation between % African Americans and % Free/Discounted lunch suggesting that these students are placed
                              into poorly performing schools which may come as a result of poverty/low-income in the student body and 
                              their families.'),

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
                              h4(em("Average school rank: ")), h4(textOutput("school_avg_rank"), br()),  
                              
                              # slider to adjust the min and max rank of the schools viewed in the table
                              sliderInput('rank.key.table', label = 'School Rank',
                                          value = c(0, 100),
                                          min = 0,
                                          max = 100),
                              
                              # displays the average percent of free and discount lunches offered at the schools viewed in the table
                              h4(em("Average percent of free and discount lunch: ")), h4(textOutput("school_avg_pfdl"))
                            ),
                            
                            mainPanel( 
                              # sets the tabs in the main panel
                              dataTableOutput("seattle_table")
                            )
                          )
                 ),
                 
                 #Conclusion panel
                 tabPanel('Conclusion',
                          h1('Insights - A Segregated Seattle'),
                          p('From each tab of this report we have learned that certain schools are not being treated with the care that they deserve. From the map tab, we can see that the southern region including South Shore and Rainier Beach in particular stands out an extreme pocket of low-ranking schools and poverty based on the low school ranks and high percent of students on free or discounted lunch. Steps ', em('can'), " be taken though to help mitigate these unfair systemic inequalities found across Seattle. "),
                          p(textOutput("insights")), #Insert those generated stats for Rainier Beach into a paragraph
                          p("Rainier Beach is also a standout due to its largely successful International Baccalaureate program which is poised to soon be cut, ", a("due to lack of funding", href = "http://www.seattletimes.com/opinion/editorials/more-funding-needed-to-ensure-rainier-beach-high-schools-success/"), " from the city. Funding, of course, is not a panacea for issues of school performance (Garfield Highschool in particular ", a("stands out as an example", href = "http://www.seattletimes.com/education-lab/microcosm-of-the-city-garfield-principal-navigates-racial-divide/"), "of a well-funded shool that still fails to serve minority students), but it's a step in the right direction. Rainier Beach is one of many underfunded schools, along with South Shore and other south Seattle schools."),
                          p("The ", a("Supreme Court's McCleary Decision", href = "http://www.washingtonpolicy.org/publications/detail/overview-of-the-mccleary-decision-on-public-education-funding-and-reform"), " necessitates equal access and funding of schools across Washington. Still, split Washington legislators have shirked on their duties (for 5 years now) in enforcing the decision; ", em("lobbying your senator"), " about the McCleary Decision is a quick way citizens can help to ensure schools like Rainier Beach are provided the resources they need to better serve their diverse student bodies."),
                          p("The battle for diversity in education is hard-fought in Seattle and far from over, but it's a vital step in ensuring students of minority can make it through the bottleneck of higher education. Eliminating traces of systemic racism leads to more diverse workspaces (which in turn increases creativity), and a greater diversity of viewpoints presented in fields of all levels.")
                 )
)