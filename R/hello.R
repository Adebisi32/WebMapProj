library("googlesheets")
library("leaflet")
library("shiny")
library("rgdal")
library("raster")
library("sp")
library("shapefiles")
library(htmltools)
library(htmltools)
#getwd()
setwd("F:/Spring2018/Web Mapping/Project/WebMap1/")

sheet<- gs_key('1hT9JHKGhKR1QcUDB8ylylURmgxoIkylLd4SF9zqdTVo')
kebele <- shapefile("inst/extdata/kebeles.shp")
class(kebele)
head(kebele)

#Creating School points
Schoolpoints<- sheet %>% gs_read(ws = 1, range = "A1:R18")

#Adding data to shapefile
UniT<- sheet %>% gs_read(ws = 2, range = "A1:C34")
UniT<- as.data.frame(UniT)
head(UniT)
#merge UniT to kebeles
merge1 <- merge(kebele,UniT, by="id")
head(merge1)
class(merge1)
#plot(merge1)

#Read and add Healthy Villages data
HV<- sheet %>% gs_read(ws = 3, range = "A1:I34")
HV<- as.data.frame(HV)
head(HV)
merge2 <- merge(merge1,HV)
head(merge2)
class(merge2)

#Read and add Economic opportunities data
EconOpp<- sheet %>% gs_read(ws = 4, range = "A1:E34")
EconOpp<- as.data.frame(EconOpp)
head(EconOpp)
head(HV)
kebeles <- merge(merge2,EconOpp)
head(kebeles)
class(kebeles)



# Create the map

m <- leaflet() %>%
  addProviderTiles(providers$OpenStreetMap) %>%
  #addProviderTiles("Esri.WorldImagery") %>%
  #addProviderTiles("CartoDB.Positron") %>%
  #addProviderTiles("Stamen.Terrain") %>%
  setView(36.776, 11.242, zoom = 10)%>%
  addLegend("bottomright", colors = c("YlOrRd", '#191970'), labels = c("University Awards", "School Points"))
#addLayersControl(
#overlayGroups = c("School Points", "University Awards"),
#options = layersControlOptions(collapsed = FALSE)

#create color palette for UniT2012
#create color palette for UniT2012
bins1 <- c(0, 1, 2, 3, 5, Inf)
palUniT <- colorBin(
  palette = "YlOrRd",
  domain = kebeles$UniT2012,
  bins=bins1
)
#pal <- colorFactor(
# palette = "BuPu",
#domain = kebeles$UniT2012,
#)

# add UniT data to the map
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
)
m <- m %>% addCircles(data=Schoolpoints,
                      lat = ~Lat, lng = ~Lng,
                      radius = 60,
                      color = '#191970',
                      label = Schoolpoints$`School Name`,
                      labelOptions = labelOptions(
                        style = list(
                          "color"= "black",
                          "font-size" = "12px",
                          "border-color" = "rgba(0,0,0,0.5)")),

                      popup = paste('<h5 style="color:white;">',"Name:", Schoolpoints$`School Name`, '</h5>', "<br>",
                                    '<h8 style="color:white;">',"New Buildings:", Schoolpoints$`New Buildings`,'</h8>', "<br>",
                                    '<h8 style="color:white;">', "New Classrooms:", Schoolpoints$`New Classrooms`, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Wells:", Schoolpoints$Wells, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Piped Water:", Schoolpoints$`piped water system`, '</h8>', "<br>",
                                    '<h8 style="color:white;">', "Latrines:", Schoolpoints$` Latrines `, '</h8>', "<br>",
                                    popupImage(Schoolpoints$photos)))



m

#create color palette
bins2<- c(0, 300, 450, 600, 750, Inf)
palHV <- colorBin(
  palette = "BuPu",
  domain = kebeles$Homes,
  bins = bins2
)
# add healthy villages data to the map

HV <- leaflet()%>%
  addProviderTiles(providers$OpenStreetMap)%>%
  setView(36.776, 11.242, zoom = 10)
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
                  popup = paste("Kebele:", kebeles$kebele, "<br>",
                                "Homes:", kebeles$Homes, "<br>",
                                "Wells:", kebeles$Wells, "<br>",
                                "PipedWater:", kebeles$`Piped water`,"<br>",
                                "CementFloors:", kebeles$`Cement Floors`,"<br>",
                                "MetalRoofs:", kebeles$`Metal Roofs`, "<br>",
                                "SolarLanterns:", kebeles$`Solar lanterns`, "<br>",
                                "Latrines:", kebeles$Latrines, "<br>",
                                popupImage(kebeles$HVphotos)))


HV

bins3<- c(0, 6, 30, 60, Inf)
palEO <- colorBin(
  palette = "YlGn",
  domain = kebeles$`Farmer's Association members assisted`,
  bins = bins3
)

#this is not done, photos not working
# add economic opportunity data to the map
#output$EconOpp <- renderLeaflet({
EO<- leaflet()
EO <- EO %>%
  addTiles()%>%
  addProviderTiles("CartoDB.Positron")%>%
  setView(36.776, 11.242, zoom = 10)
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
                                '<h8 style="color:white;">', "Wells:", kebelef$`Farmer's Association members assisted`, '</h8>', "<br>",
                                popupImage(kebeles$EOphotos)))
EO
kebeles$
  m$dependencies = c(m$dependencies,
                     leafletDependencies$bootstrap())

library(htmltools)
browsable(
  tagList(list(
    tags$head(
      tags$style(
        .mypopup.leaflet-popup-content-wrapper{
          background-color: white;
          opacity: 0.9
        }
      )
    ),
    m
  ))
)


