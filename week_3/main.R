source("plain_R/top10airports.R")
source("spark_R/top10airports.R")

main <- function(filepath){
  print(filepath)
  flights_table <- as.data.frame(read.csv(filepath, header=FALSE, sep = ";"))
  plainR(flights_table)
  sparkR
}

read <- function(filepath) {
  return (as.data.frame(read.csv(filepath, header=FALSE, sep = ";")))
}

# Plain R
one_hour <- read("./datasets/traffic1hour.exp2")
plain_1_hour = system.time(plainR(one_hour))

one_day <- read("./datasets/traffic1day.exp2")
plain_1_day = system.time(plainR(one_day))

one_week <- read("./datasets/traffic1day.exp2")
plain_1_week = system.time(plainR(one_week))