library(dplyr)
library(nycflights13)
library(ggplot2)
library(sparklyr)

rm(list = ls())
setwd(".")


sc <- spark_connect(master="local")

flights_r <- copy_to(sc, flights, "flights_sc", overwrite = TRUE)
airlines_r <- copy_to(sc, airlines, "airlines_sc", overwrite = TRUE)

src_tbls(sc)

select(flights_r, year:day, arr_delay, dep_delay)
filter(flights_r, dep_delay > 1000)
arrange(flights_r, desc(dep_delay))
summarise(flights_r, mean_dep_delay = mean(dep_delay))
mutate(flights_r, speed = distance / air_time * 60)

## OTHER EXAMPLE
c1 <- filter(flights_r, day == 17, month == 5, carrier %in% c('UA', 'WN', 'AA', 'DL'))
c2 <- select(c1, year, month, day, carrier, dep_delay, air_time, distance)
c3 <- arrange(c2, year, month, day, carrier)
c4 <- mutate(c3, air_time_hours = air_time / 60)

c4

c4 <- flights_r %>%
  filter(month == 5, day == 17, carrier %in% c('UA', 'WN', 'AA', 'DL')) %>%
  select(carrier, dep_delay, air_time, distance) %>%
  arrange(carrier) %>%
  mutate(air_time_hours = air_time / 60)

c4 %>%
  group_by(carrier) %>%
  summarize(count = n(), mean_dep_delay = mean(dep_delay))

carrierhours <- collect(c4)

flights %>% left_join(airlines)
flights %>% left_join(airlines, by = "carrier")
flights %>% left_join(airlines, by = c("carrier", "carrier"))

spark_disconnect()


