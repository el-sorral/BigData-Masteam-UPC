

plainR <- function(flights_table){
  #origin <- flights_table[,1]
  #destination <- flights_table[,2]
  
  origin <- table(flights_table[,1])
  origin <- as.data.frame(origin)
  colnames(origin) <- c("Airport", "Origin")
  
  destination <- table(flights_table[,2])
  destination <- as.data.frame(destination)
  colnames(destination) <- c("Airport", "Destiny")
  
  merged = merge(origin, destination, all=T)
  merged[is.na(merged)] <- 0
  merged$Totals <- merged$Origin + merged$Destiny
  
  
  View(merged[order(-merged$Totals), ])
}