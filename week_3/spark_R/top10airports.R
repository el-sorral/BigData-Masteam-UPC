

sparkR <- function(flights_table){
  
  origin <- table(flights_table[,1])
  origin <- as.data.frame(origin)
  colnames(origin) <- c("Airport", "Origin")
  
  destination <- table(flights_table[,2])
  destination <- as.data.frame(destination)
  colnames(destination) <- c("Airport", "Destiny")
  
  merged = merge(origin, destination, all=T)
  merged[is.na(merged)] <- 0
  merged$Totals <- merged$Origin + merged$Destiny
  
  top_ten <- head(merged[order(-merged$Totals), ], 10)
}