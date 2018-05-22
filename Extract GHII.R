# Code to extract human influence index from spatial coordinates
# Written by Abel Valdivia


#Set WD to wherever you have the GHII file and the Coordinate file
setwd("C:/Users/avaldivia/Dropbox/Publications/015 Mesoamerican Barrier Reef paper/Data")


#Load data
mbr <- read.csv("mbrdata.csv")

#Install and Load raster package
install.packages("raster")
library (raster)

#Load Human Influence Index layer
#Download layer first here, you need to create an account
#http://sedac.ciesin.columbia.edu/data/set/wildareas-v2-human-influence-index-geographic/data-download

hii_global <- raster(paste0("C:/Users/avaldivia/Dropbox/Publications/009 IUCN Caribbean Paper/Data/Human Population Data/hii-global-geo-grid/HII Geo BIL/hii_v2geo1.bil", sep = ""))

# Plot data only for the Mesoamerican Barrier Region
plot(hii_global, ylim=c(14,23), xlim=c(-91,-82),  main="Human Influence Index")

# Define spatial projections to standard WGS84 datum
crs.geo <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")  # geographical, datum WGS84

# Project for Human Infl Index data
proj4string(hii_global) <- crs.geo

# Get site coordinates and check data
str(mbr)
coord <- mbr[,c(5,6)] #Coordinates in columns 5  and 6
head(coord)

# Define coordinates columns
coordinates(coord)<- c("Longitude","Latitude")
head(coord)

# Define spatial projections for sites
proj4string(coord) <- crs.geo
summary(coord)


#Plot map with coral reefs
install.packages("rworldmap")
library(rworldmap)
install.packages('mapdata')
library(mapdata)

#Draw map of the area
map("worldHires", ylim=c(15,22), xlim=c(-90,-83), fill=T, col="grey90")
rect(-90.1,14.9,-82.9,22.1, xpd=NA)

# Plot coordinates to make sure they make sense
plot(coord, add=T,  cex=0.5, col="blue", pch=16)

# Extract Human Influence Index for the site coordinates within 100 km buffer
mbr$hii100km <- extract(hii_global, coord, buffer = 100000, fun = sum)

# Extract Human Influence Index for the site coordinates within 75 km buffer
mbr$hii75km <- extract(hii_global, coord, buffer = 75000, fun = sum)

# Extract Human Influence Index for the workd within 50 km buffer
mbr$hii50km <- extract(hii_global, coord, buffer = 50000, fun = sum)

# Extract Human Influence Index for the workd within 25 km buffer
mbr$hii25km <- extract(hii_global, coord, buffer = 25000, fun = sum)

# Extract Human Influence Index for the workd within 10 km buffer
mbr$hii10km <- extract(hii_global, coord, buffer = 10000, fun = sum)


#  Save the new data in the mbr csv as "mbr+human.csv" 
write.csv(mbr, "mbr+hii.csv")