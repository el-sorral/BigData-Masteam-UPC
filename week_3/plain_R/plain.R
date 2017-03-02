


plainR_prepare <- function(filepath) {
  return (as.data.frame(read.csv(filepath, header=FALSE, sep = ";")))
}


plainR <- function(name, flights_table){
  
  origin <- table(flights_table[,1])
  origin <- as.data.frame(origin)
  colnames(origin) <- c("Airport", "Origin")
  
  destination <- table(flights_table[,2])
  destination <- as.data.frame(destination)
  colnames(destination) <- c("Airport", "Destiny")
  
  merged = merge(origin, destination, all=T)
  merged[is.na(merged)] <- 0
  merged$Totals <- merged$Origin + merged$Destiny
  
  top_ten = head(merged[order(-merged$Totals), ], 10)
  assign(name, top_ten, envir = .GlobalEnv)
}

plainTimes <- function(){
  
  prepare_times = data.frame(
    Method="PlainR Prepare",
    Hour=system.time(flights_r_hour <- plainR_prepare("./datasets/traffic1hour.exp2"))[["elapsed"]],
    Day= system.time(flights_r_day  <- plainR_prepare("./datasets/traffic1day.exp2")) [["elapsed"]],
    Week=system.time(flights_r_week <- plainR_prepare("./datasets/traffic1week.exp2"))[["elapsed"]]
  )
  
  execute_times = data.frame(
    Method="PlainR Execute",
    Hour=system.time(plainR("plainR.oneHour", flights_r_hour))[["elapsed"]],
    Day= system.time(plainR("plainR.oneDay",  flights_r_day)) [["elapsed"]],
    Week=system.time(plainR("plainR.oneWeek", flights_r_week))[["elapsed"]]
  )

  total_times = data.frame(
    Method="PlainR Total",
    Hour=execute_times$Hour + prepare_times$Hour,
    Day= execute_times$Day  + prepare_times$Day,
    Week=execute_times$Week + prepare_times$Week
  )
  
  return (rbind(prepare_times, execute_times, total_times))
}
