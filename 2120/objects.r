library("ggplot2")
library("leaflet")
library("rgdal")
library("dplyr")
library("viridis")
library("readxl")

raw <- read_xlsx("fightData.xlsx")  # The raw data

data <- raw

graph <- ggplot(data) +
geom_point(aes(Male, Animal, color = "blue")) +
geom_point(aes(Female, Animal, color = "orange"))