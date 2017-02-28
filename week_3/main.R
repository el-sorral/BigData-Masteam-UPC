source("plain_R/plain.R")
source("spark_R/spark.R")

read <- function(filepath) {
  return (as.data.frame(read.csv(filepath, header=FALSE, sep = ";")))
}

main <- function(){
  # Plain R
  one_hour <- read("./datasets/traffic1hour.exp2")
  plain_1_hour = system.time(plainR(one_hour))
  
  one_day <- read("./datasets/traffic1day.exp2")
  plain_1_day = system.time(plainR(one_day))
  
  one_week <- read("./datasets/traffic1day.exp2")
  plain_1_week = system.time(plainR(one_week))
}

main2 <- function(){
  sc <- startContext()
  # Plain R
  one_hour <- read("./datasets/traffic1hour.exp2")
  plain_1_hour = system.time(sparkR(sc, one_hour))
  
  stopContext(sc)
}

main2()