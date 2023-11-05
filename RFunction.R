library('ctmm')
library("suncalc")

## ToDo
# add legend 
# add maybe some color() options like color ramp, transparency,
# add some plot.telemetry options like display error T/F, size of pts,
# pdf or png, jpg???

rFunction <- function(data,showError=T, colorby=c("individual", "time", "sun", "moon", "season", "tropic"))
{
  pdf(appArtifactPath(paste0("locations_colored_by_",colorby,".pdf")))
  lapply(data, function(ind){
    ind <- annotate(ind)
    COL <- color(ind,by=colorby)
    plot(ind,col=COL, error=showError, cex=.3, main= paste0("Track: ",as.character(ind@info$identity)))
  })
   dev.off()

  result <- data
  return(result)
}
