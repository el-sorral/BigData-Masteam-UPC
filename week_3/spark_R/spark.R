
startContext <- function(){
  return (spark_connect(master="local"))
}

sparkR <- function(){
  
}

stopContext <- function(sc){
  spark_disconnect(sc)
}