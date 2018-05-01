library("googlesheets")
library("leaflet")
library("shiny")
library("rgdal")
library("raster")
library("sp")
library("mapview")
library("shinymaterial")
shinyServer(function (input, output) {
  output$map <- renderLeaflet({
  })
})
bins1 <- c(0, 1, 2, 3, 5, Inf)
palUniT <- colorBin(
  palette = "YlOrRd",
  domain = kebeles$UniT2012,
  bins=bins1
)
bins2<- c(0, 300, 450, 600, 750, Inf)
palHV <- colorBin(
  palette = "BuPu",
  domain = kebeles$Homes,
  bins = bins2
)
bins3<- c(0, 6, 30, 60, Inf)
palEO <- colorBin(
  palette = "YlGn",
  domain = kebeles$`Farmer's Association members assisted`,
  bins = bins3
)
shinyServer(function(input,output) {
  output$map<- renderLeaflet({
    m <- leaflet()
    m <- m %>%
      addTiles()%>%
      addProviderTiles(providers$OpenStreetMap)%>%
      setView(36.776, 11.242, zoom = 10) %>%
      addLegend("bottomright", pal = palUniT, values = kebeles$UniT2012,
                title = "Number of Awards (2012)",
                opacity = 1
      )
    m <- addPolygons(m,
                     data = kebeles,
                     color = "#444444",
                     weight = 1,
                     smoothFactor = 0.5,
                     opacity = 1.0,
                     fillOpacity = 0.7,
                     highlightOptions = highlightOptions(color = "white", weight = 2,
                                                         bringToFront = FALSE),
                     fillColor = ~palUniT(kebeles$UniT2012),
                     popup = paste("Number of University Transition Awards: ", kebeles$UniT2012, sep="")
    ) %>%
      addCircles(data=Schoolpoints,
                 lat = ~Lat, lng = ~Lng,
                 radius = 60,
                 color = '#191970',
                 label = Schoolpoints$`School Name`,
                 labelOptions = labelOptions(
                   style = list(
                     "color"= "black",
                     "font-size" = "12px",
                     "border-color" = "rgba(0,0,0,0.5)")),
                 popup =  paste('<h7 style="color:white;">', "Name:", "<b>", Schoolpoints$`School Name`, "</b>", '</h7>', "<br>",
                                '<h8 style="color:white;">',"New Buildings:", Schoolpoints$`New Buildings`,'</h8>', "<br>",
                                '<h8 style="color:white;">', "New Classrooms:", Schoolpoints$`New Classrooms`, '</h8>', "<br>",
                                '<h8 style="color:white;">', "Wells:", Schoolpoints$Wells, '</h8>', "<br>",
                                '<h8 style="color:white;">', "Piped Water:", Schoolpoints$`piped water system`, '</h8>', "<br>",
                                '<h8 style="color:white;">', "Latrines:", Schoolpoints$` Latrines `, '</h8>', "<br>",
                                popupImage(Schoolpoints$photos)))
  })
  output$mapHV<- renderLeaflet({
    HV<- leaflet()
    HV <- HV %>%
      addTiles()%>%
      addProviderTiles(providers$OpenStreetMap.HOT)%>%
      setView(36.776, 11.242, zoom = 10)%>%
      addLegend("bottomright", pal = palHV, values = kebeles$Homes,
                title = "Homes Improved",
                opacity = 1
      )
    HV <- addPolygons(HV,
                      data = kebeles,
                      color = "#444444",
                      weight = 1,
                      smoothFactor = 0.5,
                      opacity = 1.0,
                      fillOpacity = 0.7,
                      label = kebeles$Kebele,
                      labelOptions = labelOptions(
                        style = list(
                          "color"= "black",
                          "font-size" = "12px",
                          "border-color" = "rgba(0,0,0,0.5)")),
                      highlightOptions = highlightOptions(color = "white", weight = 2,
                                                          bringToFront = TRUE),
                      fillColor = ~palHV(kebeles$Homes),
                      popup = paste('<h7 style="color:white;">',  "Name:", "<b>", kebeles$Kebele, "</b>", '</h7>', "<br>",
                                    '<h8 style="color:white;">',"Total Homes Improved:", kebeles$Homes,'</h8>', "<br>",
                                    '<h8 style="color:white;">', "Wells:", kebeles$Wells, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Piped Water:", kebele$Wells, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Cement Floors:", kebeles$`Piped water`, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Solar Lanterns:", kebeles$`Cement Floors`, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Latrines:", kebeles$`Latrines`, '</h8>', "<br>",
                                    popupImage(kebeles$HVphotos)))
  })
  output$mapEO<- renderLeaflet({
    EO<- leaflet()
    EO <- EO %>%
      addTiles()%>%
      addProviderTiles(providers$OpenStreetMap.DE)%>%
      setView(36.776, 11.242, zoom = 10)%>%
      addLegend("bottomright", pal = palEO, values = kebeles$`Farmer's Association members assisted`,
                title = "Farmers Assisted",
                opacity = 1
      )
    EO <- addPolygons(EO,
                      data = kebeles,
                      color = "#444444",
                      weight = 1,
                      smoothFactor = 0.5,
                      opacity = 1.0,
                      fillOpacity = 0.7,
                      label = kebeles$Kebele,
                      labelOptions = labelOptions(
                        style = list(
                          "color"= "black",
                          "font-size" = "12px",
                          "border-color" = "rgba(0,0,0,0.5)")),
                      highlightOptions = highlightOptions(color = "white", weight = 2,
                                                          bringToFront = TRUE),
                      fillColor = ~palEO(kebeles$`Farmer's Association members assisted`),
                      popup = paste('<h7 style="color:white;">',  "Name:", "<b>", kebeles$Kebele, "</b>", '</h7>', "<br>",
                                    '<h8 style="color:white;">',"Microloans Distributed:", kebeles$Microloans,'</h8>', "<br>",
                                    '<h8 style="color:white;">', "Farmers Assisted:", kebeles$`Farmer's Association members assisted`, '</h8>', "<br>",
                                    popupImage(kebeles$EOphotos)))
  })
})
