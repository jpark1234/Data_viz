setwd("C:/Users/Jeeyoon/Documents/Columbia University/FALL SEMESTER CLASSES/SPRING SEMESTER CLASSES/QMSS G4063/Lab/Lab5")
library(maps)
map("state")
map("world")

# plot north America (Figure 3)
xlim <- c(-171.738281, -56.601563)
ylim <- c(12.039321, 71.856229)
map("world", col= "#f3f3f3", fill= TRUE, bg= "white", lwd= 0.3,
    xlim=xlim, ylim=ylim)
#gpsvisualizer.com to get coordinates 

map("state", "New York")
map("county", "illinois")

?map

data(us.cities)
map.cities(us.cities, country="NY")

map("state", interior= FALSE)
map("state", boundary= TRUE, col="gray", add= TRUE) #add TRUE means add layers of data 
map.text("state","texas", add= TRUE)

map("state", col= "grey", boundary=TRUE, fill= TRUE, lty= 1,lwd= 1)

map("state", regions= "texas", col = "red", fill= TRUE, add= TRUE, lty=
      1, lwd= 1)
map.text("state","texas", col="white", add= TRUE)

require(ggplot2)
require(ggmap)

#columbia map (Figure 8)
#maptype: terrain, satellite, roadmap, hybrid, toner, watercolor
qmss.map <- get_map(location=c(lon=-73.961, lat=40.808), zoom=16,
                    maptype="roadmap")
# Generate some data
# http://www.gpsvisualizer.com/geocoder/
long = c(-73.96196, -73.9598589,-73.9604685)
lat = c(40.80699, 40.8076773,40.8098162)
who = c("Hamilton", "QMSS", "Joes cafe")
qmss.data = data.frame (long, lat, who)

ggmap(qmss.map) +
  geom_point(data=qmss.data, aes(x=long, y=lat, fill= factor(who)),
             colour="blue", size=6, alpha= 0.6)

#maptypes can be roadmap, satelite, watercolor for figure 8

setwd("C:/Users/Jeeyoon/Documents/Columbia University/FALL SEMESTER CLASSES/SPRING SEMESTER CLASSES/QMSS G4063/Lab/Lab5/Data")
earthquake <- read.csv("earthquake.csv")
earthquake.points <-earthquake[,c("Longitude","Latitude")]
earthquake.map <- get_map(location=c(lon=150, lat=20), zoom=3,
                          maptype="terrain", filename="earthquake_map.png")
ggmap(earthquake.map) +
  geom_point(data=earthquake.points, aes(x=Longitude, y=Latitude),
             col="red", size=2)

library(ggplot2)
library(maps)
library(scales)


