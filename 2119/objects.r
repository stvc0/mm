library("ggplot2")
library("leaflet")
library("rgdal")
library("dplyr")
library("viridis")

raw <- read.csv("raw.csv")                ## The raw data
data <- raw[,2:3]   		                  ## Data formatted for histogram
    colnames(data)[2] <- "Price"

############ GET MAP ##############
## Map file is part of repo

### Make it R Friendly and Tidy ###
## Read this shape file with the rgdal library. 
world_spdf <- readOGR(                     #Spatial Polygon Data Frame
  dsn="../world", 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)



############ MAP GIG COST DATA TO COUNTRIES ##############
## Merge gig price table with map's table
world_spdf@data <- left_join(
    world_spdf@data, data,
    by = c("NAME" = "Country")
    )

## Clean the data object
world_spdf@data$Price[ which(world_spdf@data$Price == 0)] = NA
world_spdf@data$Price <- as.numeric(as.character(world_spdf@data$Price))

############ CHOROPLETH ##########
### Create Elements


## Create palette
scheme <- "viridis"                 #set palette

pal <- colorNumeric(     
    palette = scheme, 
    domain = world_spdf@data$Price,
    na.color = "transparent"
    )     


## Add bins
mybins <- c(0,0.5,1,1.5,5,10,50,Inf)
mypalette <- colorBin( palette= scheme, domain=world_spdf@data$Price, na.color="transparent", bins=mybins)


## Prepare the text for tooltips:
mytext <- paste(
    "Country: ", world_spdf@data$NAME,"<br/>", 
    "Price: ","$", world_spdf@data$Price, 
    sep="") %>%
  lapply(htmltools::HTML)


## Make background map

map <- leaflet(world_spdf) %>%         # Make leaflet obj for map
 addTiles() %>%
 setView(lat=10, lng=0, zoom=2) %>%
 addPolygons(                          # Give shapes to countries and show price with color
    fillColor = ~pal(Price), 
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

  addLegend( pal=pal, values=~Price, opacity=0.9, title = "Price (USD)", position = "bottomleft" )


############ HISTOGRAM ############
### Using hist() ###
hist <- hist(data[,2],
    main = "Average Price of 1G of Data",     # Histogram title
    xlab = "Price")   						            # X-axis label

### Using ggplot() ###
gghist <- ggplot(data,aes(x =  Price))+
    geom_histogram(binwidth = 1)   		        # Bin width

map
