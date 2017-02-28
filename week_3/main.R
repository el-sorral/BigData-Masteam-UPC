source("plain_R/top10airports.R")

main <- function(filepath){
  print(filepath)
  flights_table <- as.data.frame(read.csv(filepath, header=FALSE, sep = ";"))
  plainR(flights_table)
}

# Plain R
plain_1_hour = system.time(main("./datasets/traffic1hour.exp2"))
plain_1_day = system.time(main("./datasets/traffic1day.exp2"))
plain_1_week = system.time(main("./datasets/traffic1week.exp2"))

print("D")