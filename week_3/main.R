source("plain_R/top10airports.R")

main <- function(filepath){
  filepath
  flights_table <- read.table(filepath, header=T)
  flights_table
  plainR(flights_table)
  
}

main("./datasets/traffic1day.exp2")

