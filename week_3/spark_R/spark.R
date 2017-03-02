library(dplyr)
library(nycflights13)
library(ggplot2)
library(sparklyr)


startContext <- function(){
  sc <- spark_connect(master="local")
  return (sc)
}

sparkR_prepare <- function(name, sc, filename) {
  return (spark_read_csv(sc, name=name, path=filename,
                        header=F, delimiter = ";"))
}

sparkR <- function(name, sc, flights_r){
  # Count take of for all airports
  origin <- flights_r %>%
              select(airport=V1) %>%
              mutate(departure = 1) %>%
              group_by(airport) %>%
              summarize(departure = sum(departure))

  # Count landings for all airports
  destination <- flights_r %>%
                  select(airport=V2) %>%
                  mutate(arrival = 1) %>%
                  group_by(airport) %>%
                  summarize(arrival = sum(arrival))

  # Join everythink and arrange the data
  airports <- origin %>%
                full_join(destination, by = "airport") %>%
                mutate(departure = if_else(is.na(departure), 0, departure),
                       arrival = if_else(is.na(arrival), 0, arrival),
                       movements = departure + arrival) %>%
                arrange(-movements) %>%
                collect()
  
  assign(name, head(airports, 10), envir = .GlobalEnv)
}
  
stopContext <- function(sc){
  spark_disconnect(sc)
}

sparkTimes <- function(){
  sc <- startContext()
  
  # Spark R
  prepare_times = data.frame(
    Method="Sparklyr Prepare",
    Hour=system.time(flights_r_hour <- sparkR_prepare("sparkR_oneHour", sc, "./datasets/traffic1hour.exp2"))[["elapsed"]],
    Day= system.time(flights_r_day  <- sparkR_prepare("sparkR_oneDay",  sc, "./datasets/traffic1day.exp2")) [["elapsed"]],
    Week=system.time(flights_r_week <- sparkR_prepare("sparkR_oneWeek", sc, "./datasets/traffic1week.exp2"))[["elapsed"]]
  )
  
  execute_times = data.frame(
    Method="Sparklyr Execute",
    Hour=system.time(sparkR("sparkR.oneHour", sc, flights_r_hour))[["elapsed"]],
    Day= system.time(sparkR("sparkR.oneDay",  sc, flights_r_day)) [["elapsed"]],
    Week=system.time(sparkR("sparkR.oneWeek", sc, flights_r_week))[["elapsed"]]
  )

  stopContext(sc)

  total_times = data.frame(
    Method="Sparklyr Total",
    Hour=execute_times$Hour + prepare_times$Hour,
    Day= execute_times$Day  + prepare_times$Day,
    Week=execute_times$Week + prepare_times$Week
  )

  return (rbind(prepare_times, execute_times, total_times))
}

