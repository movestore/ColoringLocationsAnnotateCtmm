library('move')
library('ctmm')

#data0 <- readRDS("input3_stork.rds")
#data <- as.telemetry(data0)

rFunction <- function(data)
{
  data <- annotate(data)
  COL <- color(data,by="sun")
  plot(data,col=COL)

  result <- data
  return(result)
}

  
  
  
  
  
  
  
  
  
  
