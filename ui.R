library(shiny)

ui <- fluidPage(
  titlePanel("Crime Data"),
  sidebarLayout(  # layout the page in two columns
    sidebarPanel(  # specify content for the "sidebar" column
      
    ),
    
    mainPanel( # sets the tabs in the main panel
      tabsetPanel(type = "tabs",
                  tabPanel("tab1"),
                  tabPanel("tab2")
      )
    ))

  )

shinyUI(ui)