library('move')
library('ctmm')

#data0 <- readRDS("input3_stork.rds")
#data <- as.telemetry(data0)

rFunction <- function(data)
{
  plot(data)
  
  #guess  <- ctmm.guess(data)
  #fit    <- ctmm.fit(data,guess)
  #ud     <- akde(dat, fit, weights = TRUE )
  #saveRDS(list(ud=ud,fit=fit), "akde_data.rds")
  
  result <- data
  return(result)
}

  
  
  
  
  
  
  
  
  
  
