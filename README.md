# Color Locations By Time Related Variables 

MoveApps

Github repository: https://github.com/movestore/ColoringLocationsAnnotateCtmm

## Description
This App generates a plot with the locations colored by time, sunlight, moonlight, day length, calendar day or individual.

## Documentation
`Time` refers to the timestamps of the locations; `Sunlight` is calculated as the the sine of the sun's altitude, which is proportional to solar flux during daylight hours; `Moonlight` is calculated as the illuminated fraction of the moon; `Day length` will also correspond to the local season; `Calender day` will eventually be upgraded to tropical-year cycle; when coloring by `Individual` it will color to minimize the maximum combined spatial and color overlap.

The output data set will contain the added columns named `moonlight`, `sunlight`, `season` (day length), `tropic` (calender day).

### Input data
telemetry.list

### Output data
telemetry.list

### Artefacts
`locations_colored_by_X.pdf"`: a pdf containing the plot of the location colored by X. X will be the selected variable by which locations are colored.

### Parameters 
`Color locations by:`: options are `Time`, `Sunlight`, `Moonlight`, `Day length`, `Calendar day` or `Individual`. By default `Time` is selected.

### Most common errors


### Null or error handling

**Data**: The full input data set with the additional columns is returned for further use in a next App and cannot be empty. 
