#Seattle Segregated App

#Install packages for app deployment
install.packages("shiny")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("plotly")
install.packages("leaflet")


# Load the shiny, ggplot2, plotly, leaflet, and dplyr libraries
library("ggplot2")
library("shiny")
library("dplyr")
library("plotly")
library("leaflet")

#Load in ui and server files
source("ui.R")
source("server.R")

# Create a new `shinyApp()` using the above ui and server
shinyApp(ui = my.ui, server = my.server)