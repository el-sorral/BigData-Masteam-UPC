source("plain_R/plain.R")
source("spark_R/spark.R")

library(reshape2)

main <- function() {
  times = rbind(
    plainTimes(),
    sparkTimes()
  )
  
  df <- melt(times, id.vars = "Method")  #the function melt reshapes it from wide to long
  assign("time_df", df, envir = .GlobalEnv)
  
  graph = ggplot(df, aes(variable, value, group=factor(Method))) + 
    geom_line(aes(color=factor(Method))) +
    scale_x_discrete(name="Database") +
    scale_y_continuous(name="Time (s)") +
    ggtitle("PlainR vs Sparklyr")
  graph
  
}

main()