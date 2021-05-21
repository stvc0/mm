library("ggplot2")
library("leaflet")
library("rgdal")
library("dplyr")
library("RColorBrewer")

### Price Data
raw <- read.csv("raw.csv")    ## The raw data
data <- raw[,2:3]   		 ## Data formatted for histogram
    colnames(data)[2] <- "Price"


### Map Data
world_spdf <- readOGR(          
  dsn="../world", 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)


### Merge Price and Map Data
world_spdf@data <- left_join(
    world_spdf@data, data,
    by = c("NAME" = "Country")
    )


# Clean the data object
world_spdf@data$Price[ which(world_spdf@data$Price == 0)] = NA
world_spdf@data$Price <- as.numeric(as.character(world_spdf@data$Price))


# Create a color palette with handmade bins.
library(RColorBrewer)
mybins <- c(0,0.5,1,5,10,50,Inf)
mypalette <- colorBin( palette="YlOrBr", domain=world_spdf@data$Price, na.color="transparent", bins=mybins)
 
# Prepare the text for tooltips:
mytext <- paste(
    "Country: ", world_spdf@data$NAME,"<br/>", 
    "Area: ", world_spdf@data$AREA, "<br/>", 
    "Price: ", world_spdf@data$Price, 
    sep="") %>%
  lapply(htmltools::HTML)
 
# Final Map
m <- leaflet(world_spdf) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
    fillColor = ~mypalette(Price), 
    stroke=TRUE, 
    fillOpacity = 0.9, 
    color="white", 
    weight=0.3,
    label = mytext,
    labelOptions = labelOptions( 
      style = list("font-weight" = "normal", padding = "3px 8px"), 
      textsize = "13px", 
      direction = "auto"
    )
  ) %>%
  addLegend( pal=mypalette, values=~Price, opacity=0.9, title = "Price (USD)", position = "bottomleft" )

