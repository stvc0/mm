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
    geom_point(aes(Female, Animal, color = "orange")) +
    theme(axis.title.x = element_blank(), axis.title.y = element_blank()) +
    labs(title = "What animal could you beat in a fight?") +
    scale_x_continuous(breaks = , labels = c("0%", "10", "20", "30", "40", "50", "60", "70", "80"), expand = c(0,0))


plot(graph)
