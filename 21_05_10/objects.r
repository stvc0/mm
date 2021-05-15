library("ggplot2")
library("leaflet")
library("rgdal")
library("dplyr")

raw <- read.csv("raw.csv")    ## The raw data
data <- raw[,2:3]   		 ## Data formatted for histogram
    colnames(data)[2] <- "Price"

############ GET MAP ##############
### Get the base file ###
# Download the shapefile.
# download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="/world_shape_file.zip")
# You now have it in your current working directory, have a look!

# Unzip this file. You can do it with R (as below), or clicking on the object you downloaded.
#system("unzip /world_shape_file.zip")
#  -- > You now have 4 files. One of these files is a .shp file! (TM_WORLD_BORDERS_SIMPL-0.3.shp)

### Make it R Friendly and Tidy ###
# Read this shape file with the rgdal library. 
world_spdf <- readOGR( 
  dsn="../world", 
  layer="TM_WORLD_BORDERS_SIMPL-0.3",
  verbose=FALSE
)

# Clean the data object
world_spdf@data$POP2005[ which(world_spdf@data$POP2005 == 0)] = NA
world_spdf@data$POP2005 <- as.numeric(as.character(world_spdf@data$POP2005)) / 1000000 %>% round(2)

# -- > Now you have a Spdf object (spatial polygon data frame). You can start doing maps!

############ CHLOROPLETH ##########
### Create Elements

colorNumeric() # Add a palette

leaflet() # These three make background map
addTiles()
setView()

addPolygons() #give shapes to countries and show population with color

############ HISTOGRAM ############
### Using hist() ###
hist <- hist(data[,2],
    main = "Average Price of 1G of Data",    ## Histogram title
    xlab = "Price")   						 ## X-axis label

### Using ggplot() ###
gghist <- ggplot(data,aes(x =  Price))+
    geom_histogram(binwidth = 1)   		 ## Bin width
