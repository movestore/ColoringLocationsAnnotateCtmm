# Color Locations By Time Related Variables

MoveApps

Github repository: https://github.com/movestore/ColoringLocationsAnnotateCtmm

## Description
This App annotates the tracking data with time/location specific information (sunlight, moonlight, day length and calendar day) and creates a pdf with plots of the locations colored by time, sunlight, moonlight, day length, calendar day or individual, each with a color legend.

## Documentation
The App colors the locations of each track, these are the options: 

- `Time`: colors the tracking data with a gradient that increases in time. This is very useful to determine if an individual is range resident or not. A range resident individual will have a mix of blue and red locations across the space it occupied.
- `Sunlight`: colors according to the sine of the sun's altitude, which is proportional to solar flux during daylight hours. Values can go from -1 to 1.
- `Moonlight`: colors according to the illuminated fraction of the moon. Values can go from 0 to 1.
- `Day length`: colors according to the length of the day, and therefore corresponds to the local season. Values can go from 0 to 24h.
- `Calendar day`: colors according to the calendar day. Values go from 1 January to end of 31 December
- `Individual`: colors each individual in its own color.

For `Time`, `Sunlight`, `Moonlight` and `Day length` the colors run from blue to red with increasing time, sunlight, moonlight, or day length. The color scale is set per track, i.e. blue is the lowest and red the highest value of that track. Each plot contains a color bar showing the values of that track.

The added values to the data do not correspond always the lables in the plots, please check the section *"Changes in output data"*.

By default the size of each location is the location-error radius. If all (most) points are very small, or the error circles cover the plot and it is difficult to interpret, try setting the setting `Plot error circles if present in the data` to `False`.


### Application scope
#### Generality of App usability
This App was developed for any taxonomic group.

#### Required data properties
The App should work for any kind of location data. The calculations of sunlight, moonlight, day length and calendar day use the timestamps and the longitude and latitude of each location.

### Input type
`ctmm::telemetry.list`

### Output type
`ctmm::telemetry.list`

### Artefacts
`locations_colored_by_X.pdf`: pdf containing one plot per track of the locations colored by X, each with a color legend. X is the selected option of the setting `Color locations by:` (`time`, `sun`, `moon`, `season`, `tropic` or `individual`). When coloring by `individual`, the first page shows all tracks together.

### Settings
`Color locations by:` (colorby): variable by which the locations are colored. Options are `Time` (time), `Sunlight (sine of the sun's altitude)` (sun), `Moonlight (illuminated fraction of the moon)` (moon), `Day length` (season), `Calendar day` (tropic) or `Individual` (individual). Default: `Time`.

`Plot error circles if present in the data` (showError): if `True`, each location is plotted with its location-error radius, if this information is present in the data. If `False`, all locations have the same size. Default: `True`.

### Changes in output data
The App adds to the input data the following columns, independent of the selected coloring option:    
- `moonlight`: illuminated fraction of the moon, from 0 to 1.      
- `sunlight`: sine of the sun's altitude, from -1 to 1.       
- `season`: length of the day from -1 to 1 where -1 corresponds to 0 hours, 0 to 12 hours and 1 to 24 hours.      
- `tropic`: calendar day, as the fraction of the calendar year (UTC) elapsed, from 0 (1 January) to 1 (end of 31 December).      

### Errors and null handling
**Setting `colorby`:** When `Individual` is selected, `ctmm` fits a movement model to each track to calculate the overlap between individuals. This can take a long time for data sets with many individuals or locations.

**Setting `showError`:** If the data contain no location error information, all locations are plotted with the same size independent of this setting.

### Technical details
- The annotation and coloring rely on `ctmm::annotate()` and `ctmm::color()`, which use the `suncalc` package for the position and illumination of the sun and moon. The plots are made with `plot()` from `ctmm`.
- The day length is recalculated with `suncalc::getSunlightTimes()` and `suncalc::getSunlightPosition()`, as described below.
- Annotation and coloring by `Time`, `Sunlight`, `Moonlight`, `Day length` and `Calendar day` are done per track; coloring by `Individual` is done on all tracks together.
- The color legends are drawn with base R graphics in the right margin of each plot.

**Correction of the day length:** `ctmm::annotate()` (ctmm version 1.3.0) calculates the day length as sunset minus sunrise of the UTC date of each location. Far from the Greenwich meridian (e.g. in the Americas) sunset or sunrise falls on the other side of midnight UTC, which results in negative day lengths, or missing values on the day the time crosses midnight. In polar day or polar night there is no sunrise or sunset and the day length is missing. This App therefore recalculates the day length (column `season`) after annotating the data: the difference between sunset and sunrise is wrapped into 0-24 hours, missing values on the day sunset or sunrise crosses midnight UTC are replaced by the mean of the day before and after, and in polar day or polar night the day length is set to 24 hours if the sun is above the horizon at solar noon, and to 0 hours otherwise.