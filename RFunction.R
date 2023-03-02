library('ctmm')

## ToDo
# add legend 
# add maybe some color() options like color ramp, transparency,
# add some plot.telemetry options like display error T/F, size of pts,
# pdf or png, jpg???

rFunction <- function(data, colorby=c("individual", "time", "sun", "moon", "season", "tropic"))
{
  data <- annotate(data)
  COL <- color(data,by=colorby)
  
  pdf(appArtifactPath(paste0("locations_colored_by_",colorby,".pdf")))
  plot(data,col=COL)
  dev.off()

  result <- data
  return(result)
}
