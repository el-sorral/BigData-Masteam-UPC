library(dplyr)
library(nycflights13)
library(ggplot2)
library(sparklyr)

#startContext <- function(){
#  return (spark_connect(master="local"))
#}

sc <- spark_connect(master="local")

flights_r <- spark_read_csv(sc, name="flights_sc", path="./datasets/traffic1hour.exp2", header=F, delimiter = ";")

origin <- select(flights_r, airport=V1)
destination <- select(flights_r, airport=V2)

origin <- mutate(origin, departure = 1, arrival=0, total=1)
destination <- mutate(destination, departure=1, arrival = 1, total=1)

origin %>% group_by(airport)
destination %>% group_by(airport)



  

  filter(flights_r, dep_delay > 1000)
  arrange(flights_r, desc(dep_delay))
  summarise(flights_r, mean_dep_delay = mean(dep_delay))
  mutate(flights_r, speed = distance / air_time * 60)
  

stopContext <- function(sc){
  spark_disconnect(sc)
}