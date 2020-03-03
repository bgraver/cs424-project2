#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinydashboard)
library(ggplot2)
library(lubridate)
library(DT)
library(leaflet)
library(scales)
library(stringi)
library(leaflet)


hurdata <- read.csv("treated-data-atlantic.csv", header=TRUE, dec=',', row.names=NULL)

#making col of proper date and of years
hurdata$newDate <-ymd(hurdata$date)
hurdata$year <- year(hurdata$newDate)

#only hurricanes between 2005-2018
# hurdata <- subset(hurdata, (year > 2004 & year < 2019) )

# hurdata$newlat <- substr(hurdata$lat, 2, 5)
# hurdata$newlon <- substr(hurdata$lon, 3, 6)

# hurdata$newlat <- as.numeric(as.character(hurdata$newlat))
# hurdata$newlon <- as.numeric(as.character(hurdata$newlon ))

hurdata$newlat <- as.numeric(as.character(hurdata$lat))
hurdata$newlon <- as.numeric(as.character(hurdata$lon ))


hurdata$newlon <- hurdata$newlon * -1

pal <- colorFactor(
  palette = 'Dark2',
  domain = hurdata$name
)
# please hit the Wind Speed button to change away from the NA values
hurdata.windSpeed <- as.data.frame(table(hurdata$cycloneNumber))
order.windspd <- order(hurdata$maxWindSpeed, decreasing=TRUE)
hurdata.windSpeed <- hurdata.windSpeed[order.windspd, ]
colnames(hurdata.windSpeed) <- c("Cyclone ID", "Wind Speed")

# 
# m = leaflet(hurdata) %>% 
#   addTiles() %>% 
#   # addPolylines(lng = ~newlon, lat = ~newlat, color = "red", opacity = 0.25, weight = 1) %>%
#   addCircles(lng = ~newlon, lat = ~newlat, weight = 1,
#              radius = ~sqrt(maxWindSpeed) * 1750, color = ~pal(name),
#              
#              popup=paste("Hurricane Name: ", hurdata$sirName, "<br>",
#                          "Date: ", hurdata$newDate, "<br>",
#                          "Time: ", hurdata$time, "<br>",
#                          "Max Wind Speed: ", hurdata$maxWindSpeed, "<br>",
#                          "Min Wind Pressure: ", hurdata$minWindPressure, "<br>",
#                          "[Lat, Lon]: [", hurdata$newlat, ", ", hurdata$newlon, "]")
#   )
# 




# Define UI for application that draws a histogram
ui <- dashboardPage(

    dashboardHeader(title="CS 424 - Project 2 Alpha"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("", tabName="Empty", icon=NULL),
        menuItem("", tabName="Empty", icon=NULL),
        menuItem("", tabName="Empty", icon=NULL),
        menuItem("", tabName="Empty", icon=NULL),
        menuItem("", tabName="Empty", icon=NULL),
        menuItem("", tabName="Empty", icon=NULL),
        menuItem("", tabName="Empty", icon=NULL),
        menuItem("", tabName="Empty", icon=NULL)
        
        # selectInput("Date", "Select a date:", hurdata$date)
      )
    ),
  dashboardBody(
    column(12,
           fluidRow(
             box(title="Map", solidHeader = TRUE, status="primary", width=12, 
                 leafletOutput("map", height=400)
             )
           ),
           fluidRow(
             box(title="List by max windspeed", solidHeader=TRUE, status="primary", width=12,
                 dataTableOutput("windspd", height=100))
           ),
           fluidRow(
             box(title="About", solidHeader=TRUE,  status="primary", width=12,
                 htmlOutput("about", height=200))
           )
  )
  )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
    output$map <- renderLeaflet(
      {
        # m
        leaflet(hurdata) %>% 
          addTiles() %>% 
          # addPolylines(lng = ~newlon, lat = ~newlat, color = "red", opacity = 0.25, weight = 1) %>%
          addCircles(lng = ~newlon, lat = ~newlat, weight = 1,
                     radius = ~sqrt(maxWindSpeed) * 1750, color = ~pal(name),
                     
                     popup=paste("Hurricane Name: ", hurdata$sirName, "<br>",
                                 "Date: ", hurdata$newDate, "<br>",
                                 "Time: ", hurdata$time, "<br>",
                                 "Max Wind Speed: ", hurdata$maxWindSpeed, "<br>",
                                 "Min Wind Pressure: ", hurdata$minWindPressure, "<br>",
                                 "[Lat, Lon]: [", hurdata$newlat, ", ", hurdata$newlon, "]")
          ) %>%
          setView(lng=-35, lat=6, zoom=4)
      }
    )
    
    output$windspd <- DT::renderDataTable(
      DT::datatable(
        {
          hurdata.windSpeed
        },
        options = list(searching=FALSE, pageLength=10, lengthChange=FALSE,  rownames=FALSE)
      )
    )
    
    output$about <- renderUI({
      str0 <- paste("- Dashboard made by Brandon Graver, Nicholas Abbasi and Ho Chon")
      str1 <- paste("- Libraries used: Shiny, Shinydashboard, leaflet, DT, ggplot2, lubridate, stringr.")
      HTML(paste(str0, str1, sep='<br>'))
    })
      
}

# Run the application
shinyApp(ui = ui, server = server, options=(port=9001))
