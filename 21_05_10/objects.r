library("ggplot2")
library("leaflet")
library("rgdal")
library("dplyr")
library("viridis")

raw <- read.csv("raw.csv")  ## The raw data
data <- raw[,2:3]           ## Data formatted for histogram
    colnames(data)[2] <- "Price"

############ MAP DATA ##############
# World spacial polygon dataframe
world_spdf <- readOGR( 
  dsn="../world", 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

# Clean the data object
world_spdf@data$POP2005[ which(world_spdf@data$POP2005 == 0)] = NA
world_spdf@data$POP2005 <- as.numeric(as.character(world_spdf@data$POP2005)) / 1000000 %>% round(2)

# Add price per gig column
mergedData <- left_join(world_spdf@data, data,
    by = c("NAME" = "Country"))

############ CHOROPLETH ##########
# Color palette
pal <- colorNumeric(
    palette = "plasma",
    domain = mergedData$Price,
    na.color = "transparent"
    )     
pal(c(0,30))

map <- leaflet(world_spdf) %>% # Make leaflet obj for map
addTiles() %>%
setView(lat=10, lng=0, zoom=2) %>%
addPolygons(fillColor = pal, stroke=FALSE) #give shapes to countries and show price with color


############ HISTOGRAM ############
### Using hist() ###
hist <- hist(data[,2],
    main = "Average Price of 1G of Data",    ## Histogram title
    xlab = "Price")   						 ## X-axis label

### Using ggplot() ###
gghist <- ggplot(data,aes(x =  Price))+
    geom_histogram(binwidth = 1)   		 ## Bin width
