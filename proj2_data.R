# Project 2, Nicholas Abbasi

#Needed Libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(lubridate)
library(DT)
library(leaflet)
library(scales)
library(stringi)
library(leaflet)


#read in .csv file
hurdata <- read.table(file = "treated-data-atlantic.csv", sep = ",", header = TRUE)

#making col of proper date and of years
hurdata$newDate <-ymd(hurdata$date)
hurdata$year <- year(hurdata$newDate)


#only hurricanes between 2005-2018
hurdata <- subset(hurdata, (year > 2004 & year < 2019) )

hurdata$newlat <- substr(hurdata$lat, 2, 5)
hurdata$newlon <- substr(hurdata$lon, 3, 6)


hurdata$newlat <- as.numeric(as.character(hurdata$newlat))
hurdata$newlon <- as.numeric(as.character(hurdata$newlon ))

hurdata$newlon <- hurdata$newlon * -1

pal <- colorFactor(
  palette = 'Dark2',
  domain = hurdata$name
)


m = leaflet(hurdata) %>% addTiles() %>% addPolylines(lng = ~newlon, lat = ~newlat, color = "red", opacity = 0.25, weight = 1) %>%
  addCircles(lng = ~newlon, lat = ~newlat, weight = 1,
             radius = ~sqrt(maxWindSpeed) * 1750, color = ~pal(name),
             
             popup=paste("Hurricane Name: ", hurdata$sirName, "<br>",
                                                              "Date: ", hurdata$newDate, "<br>",
                                                              "Time: ", hurdata$time, "<br>",
                                                              "Max Wind Speed: ", hurdata$maxWindSpeed, "<br>",
                                                              "Min Wind Pressure: ", hurdata$minWindPressure, "<br>",
                                                              "[Lat, Lon]: [", hurdata$newlat, ", ", hurdata$newlon, "]")
  )

m
