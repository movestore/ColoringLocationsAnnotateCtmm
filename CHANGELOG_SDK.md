
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [4.1.0] - 2026-10

### Added
- Example in `sdk.R`: run your App locally with other settings than in `app-configuration.json`, e.g. with personal credentials from `personal.env`, via `moveapps::runMoveAppsApp(args)`. This replaces overriding `args` in `sdk.R`, which fails since `4.0.0` with "object of type 'closure' is not subsettable"
- `personal.env` in `.gitignore`

### Changed
- Upgraded the [`moveapps`](https://github.com/movestore/moveapps-sdk-r-package) SDK package to `v1.2.0`

## [4.0.2] - 2026-09

### Changed
- Updated `README.md` including new sections
- Updated `move2` and `telemetry list` input files

## [4.0.1] - 2026-09

### Added
- `cmake` to the `Dockerfile`: `rocker/geospatial` dropped it with R `4.5.3`, and without it `s2` — and therefore `sf` and `move2` — cannot be built

### Changed
- Upgraded `R` to version `4.6.1` (`renv.lock` + `Dockerfile`)
    - Your fork keeps its own `renv.lock` and `renv/` — both are listed in `.github/.templatesyncignore` and are not synced. After taking this update, `renv` reports an R version mismatch against the new base image. To follow along, run `renv::restore()` inside a container built from the new `Dockerfile` and commit the regenerated `renv.lock`. If your App uses neither Docker nor `renv`, nothing changes for you.
- Upgraded the [`moveapps`](https://github.com/movestore/moveapps-sdk-r-package) SDK package to `v1.0.3`
- Upgraded `renv` to `1.2.4`

## [4.0.0] - 2025-10

### Added
- Support for R source scripts from the `./src/app/` directory (must be sourced by the App Developer on their own)

### Changed
- Extracted MoveApps SDK scripts to R package [moveapps](https://github.com/movestore/moveapps-sdk-r-package) while keeping backward compatibility to v3
- Upgraded R to version 4.5.1 (`renv.lock` + `Dockerfile`)

### Removed
- App setting type `LOCAL_FILE` and its associated function `getAppFilePath()`

## [3.3.0] - 2025-07

### Added
- App-setting-type `SECRET`

### Changed
- Updated `README.md` including new sections
- Updated `developer_README.md`

## [3.2.0] - 2024-03

### Added
- App-setting-type `USER_FILE`

### Deprecated
- App-setting-type `LOCAL_FILE`

## [3.1.0] - 2024-02

### Added
- `appspec.json` version `1.2`

### Removed
- `createsArtifacts` from `appspec.json` (v1.2). It is safe to remove it completely from your `appspec.json` - MoveApps now tries to fetch artifacts for every running App.

### Changed
- Verify to include the `null` option for setting types `DROPDOWN` and `RADIOBUTTONS` if `defaultValue` is set to `null`
- Dropped `move1` dependency

## [3.0.5] - 2023-12

### Changed
- Updated input files for testing apps. Files now include `move2_loc` and `telemetry.list` I/O types, and projected and non-projected data. All details included in the README.txt in the data/raw folder.

## [3.0.4] - 2023-11

### Changed
- Upgraded `R` framework to version `4.3.2`

## [3.0.3] - 2023-09

### Added
- `appspec.json` version 1.1

### Changed
- Documentation link is no longer required in `appspec.json` (v1.1)

## [3.0.2] - 2023-08

### Removed
- MoveApps IO-Type dependency

## [3.0.1] - 2023-07

### Added
- New `move2` input files

### Fixed
- Minor fixes in src/io files

## [3.0.0] - 2023-06

### Added
- Template versioning (starting with v3.0.0 as this is the third major iteration)
- `dotenv` to control/adjust local app development
- Template Synchronization GitHub Action. Use it to synchronize your forked app with template updates. If you already forked from the template before SDK v3.0.0, you can (*only use this option if your app is written for input data of class `move2`*):
    1. Manually add the files `.github/workflows/template-sync.yml` and `.github/.templatesyncignore` to your fork
    2. With these files you can manually execute the GitHub Action named `.github/workflows/template-sync.yml`
    3. After merging the generated pull request, add the file `app-configuration.json` manually to the root directory of your App
- SDK now supports [`move2`](https://gitlab.com/bartk/move2/). If input is of class [`move`](https://gitlab.com/bartk/move/), it will be converted into class `move2`

### Changed
- Updated developer readme
- Output is always `move2`
- Upgraded R framework to version 4.3.1

### Fixed
- App configuration for execution on moveapps.org
- App output of previous app run is now cleared at each start of the SDK
