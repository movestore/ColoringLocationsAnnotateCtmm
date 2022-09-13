library('move')
library('ctmm')
library('suncalc')

#data0 <- readRDS("input2_geese.rds")
#data <- as.telemetry(data0)
#saveRDS(data,file="input2_geese_telemetry_list.rds")
#data <- readRDS("input2_geese_telemetry_list.rds")

# telemetry||telemetry-list to telemetry||telemetry-list
rFunction <- function(data)
{
  data <- annotate(data)
  COL <- color(data,by="sun")
  
  pdf(paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"), "locations_colored_by_daynight.pdf"))
  plot(data,col=COL)
  dev.off()

  result <- data
  return(result)
}
