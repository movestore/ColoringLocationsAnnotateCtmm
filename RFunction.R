library('move')
library('ctmm')

#data0 <- readRDS("input3_stork.rds")
#data <- as.telemetry(data0)

# telemetry||telemetry-list to telemetry||telemetry-list
rFunction <- function(data)
{
  data <- annotate(data)
  COL <- color(data,by="sun")
  plot(data,col=COL)

  result <- data
  return(result)
}

# telemetry-list to ctmm-list
rFunction2 <- function(data)
{
  result <- lapply(data,ctmm.fit)
  return(result)
}
  
  
  
  
  
  
  
  
  
