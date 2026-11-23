library("ctmm")
library("suncalc")

## ToDo
# add maybe some color() options like color ramp, transparency,
# pdf or png, jpg???

## remove the sampling-rate transparency that ctmm::color() adds, to get the solid legend colour
opaqueCol <- function(col) {
  grDevices::rgb(t(grDevices::col2rgb(col = col)), maxColorValue = 255)
}

## day length in hours, robust to sunset/sunrise crossing UTC midnight and to polar day/night
## (ctmm::annotate() 'season' gives negative or NA day lengths far from Greenwich)
dayLengthHours <- function(timestamp, lat, lon) {
  sunTimes <- function(dates, lat, lon) {
    st <- suncalc::getSunlightTimes(data = data.frame(date = dates, lat = lat, lon = lon),
                                    keep = c("sunrise", "sunset", "solarNoon"))
    st$len <- (as.numeric(st$sunset) - as.numeric(st$sunrise)) %% 86400 / 3600
    st
  }
  dates <- as.Date(timestamp)
  st <- sunTimes(dates = dates, lat = lat, lon = lon)
  h <- st$len
  ## sunset/sunrise exactly on UTC midnight -> NA: use mean of the neighbouring days
  miss <- is.na(h)
  if (any(miss)) {
    h[miss] <- rowMeans(cbind(sunTimes(dates = dates[miss] - 1, lat = lat[miss], lon = lon[miss])$len,
                              sunTimes(dates = dates[miss] + 1, lat = lat[miss], lon = lon[miss])$len))
  }
  ## polar day / polar night: sun above or below the horizon at solar noon
  miss <- is.na(h)
  if (any(miss)) {
    noonAlt <- suncalc::getSunlightPosition(data = data.frame(date = st$solarNoon[miss], lat = lat[miss], lon = lon[miss]),
                                            keep = "altitude")$altitude
    h[miss] <- ifelse(noonAlt > 0, 24, 0)
  }
  h
}

## colour bar in the right margin for the continuous colourings
## ctmm::color() default col.fn: rgb(i, 0, 1 - i), i.e. blue (low) -> red (high), rescaled per track
addColorBar <- function(ind, colorby) {
  if (colorby == "tropic") {
    ## calendar day is not rescaled: 0 = 1 Jan, 1 = 31 Dec
    at <- c(0, 0.25, 0.5, 0.75, 1)
    labs <- c("1 Jan", "1 Apr", "1 Jul", "1 Oct", "31 Dec")
    title <- "Calendar day"
  } else {
    vals <- switch(colorby,
                   time   = ind$t,
                   sun    = ind$sunlight,
                   moon   = ind$moonlight,
                   season = (ind$season + 1) * 12) # ctmm 'season' = 2*daylength[days]-1 -> hours
    rng <- range(vals, na.rm = TRUE)
    at <- seq(from = 0, to = 1, length.out = 5)
    v <- rng[1] + at * diff(rng)
    labs <- switch(colorby,
                   time   = format(as.POSIXct(v, origin = "1970-01-01", tz = "UTC"), format = "%Y-%m-%d"),
                   sun    = formatC(v, digits = 2, format = "f"),
                   moon   = formatC(v, digits = 2, format = "f"),
                   season = formatC(v, digits = 1, format = "f"))
    title <- switch(colorby,
                    time   = "Time (UTC)",
                    sun    = "Sunlight\n(sine of sun's altitude)",
                    moon   = "Moonlight\n(illuminated fraction)",
                    season = "Day length (h)")
  }
  usr <- par("usr")
  dx <- diff(usr[1:2])
  dy <- diff(usr[3:4])
  x0 <- usr[2] + 0.04 * dx
  x1 <- x0 + 0.04 * dx
  y0 <- usr[3] + 0.15 * dy
  y1 <- usr[4] - 0.15 * dy
  ramp <- grDevices::rgb(red = seq(from = 0, to = 1, length.out = 100), green = 0,
                         blue = seq(from = 1, to = 0, length.out = 100))
  rasterImage(image = as.raster(rev(ramp)), xleft = x0, ybottom = y0, xright = x1, ytop = y1, interpolate = TRUE, xpd = NA)
  rect(xleft = x0, ybottom = y0, xright = x1, ytop = y1, xpd = NA)
  yt <- y0 + at * (y1 - y0)
  segments(x0 = x1, y0 = yt, x1 = x1 + 0.01 * dx, y1 = yt, xpd = NA)
  text(x = x1 + 0.015 * dx, y = yt, labels = labs, adj = 0, cex = 0.6, xpd = NA)
  text(x = x0, y = y1 + 0.03 * dy, labels = title, adj = c(0, 0), cex = 0.7, xpd = NA)
}

## names + colours legend in the right margin for colouring by individual
addIndLegend <- function(ids, cols) {
  usr <- par("usr")
  legend(x = usr[2] + 0.03 * diff(usr[1:2]), y = usr[4], legend = ids, col = cols,
         pch = 16, bty = "n", cex = 0.7, title = "Individual", xpd = NA)
}

rFunction <- function(data, showError = TRUE, colorby = c("individual", "time", "sun", "moon", "season", "tropic")){
  colorby <- match.arg(colorby)
  ids <- sapply(data, function(ind) as.character(ind@info$identity))

  ## annotate all tracks (moonlight, sunlight, season, tropic); these columns are kept in the output data
  data <- lapply(data, function(ind) {
    ind <- annotate(ind)
    ## replace ctmm's 'season' with corrected day length, keeping ctmm's scale (2 * days - 1)
    ind$season <- 2 * dayLengthHours(timestamp = ind$timestamp, lat = ind$latitude, lon = ind$longitude) / 24 - 1
    ind
  })

  pdf(appArtifactPath(paste0("locations_colored_by_", colorby, ".pdf")))
  on.exit(dev.off(), add = TRUE) # close the pdf also if plotting fails
  par(mar = c(5, 4, 4, 9) + 0.1)

  if (colorby == "individual") {
    ## colours computed across all individuals, so each individual gets its own, overlap-minimising colour
    COL <- color(data, by = "individual")
    if (!is.list(COL)) COL <- list(COL) # color() returns a vector when there is only one individual
    indCols <- sapply(COL, function(x) opaqueCol(col = x[1]))
    ## overview page with all individuals
    plot(data, col = COL, error = showError, cex = .3, main = "All tracks")
    addIndLegend(ids = ids, cols = indCols)
    ## one page per individual
    for (i in seq_along(data)) {
      plot(data[[i]], col = COL[[i]], error = showError, cex = .3, main = paste0("Track: ", ids[i]))
      addIndLegend(ids = ids[i], cols = indCols[i])
    }
  } else {
    for (i in seq_along(data)) {
      COL <- color(data[[i]], by = colorby)
      plot(data[[i]], col = COL, error = showError, cex = .3, main = paste0("Track: ", ids[i]))
      addColorBar(ind = data[[i]], colorby = colorby)
    }
  }

  result <- data
  return(result)
}
