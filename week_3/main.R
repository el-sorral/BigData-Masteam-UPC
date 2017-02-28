source("plain_R/top10airports.R")

main <- function(filepath){
  print(filepath)
  flights_table <- as.data.frame(read.csv(filepath, header=FALSE, sep = ";"))
  plainR(flights_table)
}

main("./datasets/traffic1day.exp2")

