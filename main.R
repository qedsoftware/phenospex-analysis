# load libraries
library(dplyr)
library(MESS)
library(mgcv)
library(grofit)

# source other R scripts
source("data_cleaning.R")
source("data_analysis.R")

# read in data
datafile <- "Rep1_planteye 1108.csv"
planteye_data <- read.csv(datafile)

# keep the measurements between 10/25/2019 and 11/09/2019
planteye_data$timestamp_orig <- planteye_data$timestamp
planteye_data$timestamp <- as.POSIXct(strptime(planteye_data$timestamp, "%m/%d/%Y %H:%M"))
startingtime <- as.POSIXct(strptime("10/25/2019 00:00", "%m/%d/%Y %H:%M"))
endingtime <- as.POSIXct(strptime("11/09/2019 00:00", "%m/%d/%Y %H:%M"))
planteye_data <- filter(planteye_data, timestamp >= startingtime & timestamp <= endingtime)


# keep units with 30 to 48 measurements, between 10/25/2019 and 11/09/2019
unit_count <- planteye_data %>% group_by(unit) %>% summarize(n = n(), mindate = as.Date(min(timestamp)), maxdate = as.Date(max(timestamp)))
unit_keep <- as.data.frame(unit_count %>% filter(n >= 30 & n <= 48 & mindate == "2019-10-25" & maxdate == "2019-11-08") %>% dplyr::select(unit))
planteye_data <- filter(planteye_data, unit %in% unit_keep[, 1])

# order the data
planteye_data <- arrange(planteye_data, unit, timestamp)

# start the analysis
properties <- c("Height")
for (property in properties) {
   # data cleaning
    planteye_data_cleaned <- data_cleaning(planteye_data, property)
    # time range for the growth curve
    time_range <- planteye_data_cleaned %>% group_by(unit) %>% summarize(mintime = min(timestamp), maxtime = max(timestamp))
    mintime <- as.numeric(max(time_range$mintime))
    maxtime <- as.numeric(min(time_range$maxtime))
    lentime <- (maxtime - mintime) / 3600 # in Hours
    # auc estimation
    auc_data <- GetPhenospexAUC(planteye_data_cleaned, property, mintime, maxtime)
    write.csv(auc_data, paste("auc_", property, ".csv", sep = ""), row.names = FALSE)
}
