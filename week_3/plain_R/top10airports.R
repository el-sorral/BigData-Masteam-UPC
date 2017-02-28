

plainR <- function(flights_table){
  #origin <- flights_table[,1]
  #destination <- flights_table[,2]
  
  
  origin <- table(flights_table[,1])
  
  colnames(origin) <- c("Airport", "Origin")
  print(origin)
  
  origin$V1 <- "Airport"
  origin$V2 <- "Origin"
  
  destination <- table(flights_table[,2])
  destination$V1 <- "Airport"
  destination$V2 <- "Destination"
  
  merged = merge(origin, destination, all=T)
  
  print(merged)
}