# Altered Nadeo - Random Map Picker

## Overview

This repo contains one project split into two parts, the in game Trackmania2020 plugin, and the downloading and sorting python files. 
The plugin can be found in `.\src/`, and the downloading and sorting can be found in `.\TM-DaSS` (TrackMania-Download and Sorting Scripts).

The plugin and scripts provide a way for players to enhance their Trackmania2020 experience by allowing them to play random maps from a 
selected pool, and sort these maps based on their preferred style. This adds a new layer of unpredictability and excitement to the game, 
as players won't know what map they'll be playing next. It also allows players to tailor their game experience to their preferences, by 
sorting the maps based on style.


## Features

### Plugin
- Plays random maps from a selected pool of all Altered Nadeo maps.
- Allows sorting of maps based on alteration/season/score.
- Provides options to set max/min author/gold/silver/bronze score that a map is required to have.
- Supports loading/creating profiles with pre-set alterations/years/seasons/scores, which can automatically adjust the local settings to match the profile.
- Includes a search function for specific alterations.
- Exports available for retrieving and setting the current user settings (selected alterations, scores, etc.).

### TM-DaSS



- Fetches and plays maps from the TrackMania Nadeo live services API.
- Ability to load a new map from a list of UIDs.
- Notification system to warn about game edition compatibility.
- Custom logging functionality with different log levels (Info, Warn, Error).

## How It Works

- Fetches and plays maps from the TrackMania Nadeo live services API.

1. **Fetching Map URL**: `GetMapUrl` takes a map's UID and constructs a URL using the Nadeo live services API endpoint.
2. **Playing Maps**: `PlayMap` checks for necessary permissions, fetches the map URL, and instructs the game to load the map.
3. **Loading New Maps**: `LoadNewMap` reads map UIDs from a file and randomly selects one to play.
4. **Permission Checking**: The plugin verifies if the user's edition of TrackMania allows playing local maps.

## Prerequisites
- TrackMania game installed.
- Plugin requires permissions to play local maps.

## Installation and Usage
1. **Installation**: Copy the plugin files into the Plugins directory of your TrackMania installation.
2. **Running the Plugin**: Access the plugin through the game's 'plugins' menu. Use the "Load New Altered Map" option to load a new map.

## File Structure
- `info.toml`: Includes metadata about the plugin such as name ("Altered Nadeo - Alt Map Picker"), author, category, version (0.1.0), and dependencies.
- `MoveToPluginStorage.as`: Manages file operations related to plugin storage, including data and version files.
- `Render.as`: Contains code for rendering elements and handling game edition compatibility checks.
- `Main.as`: Core functionality of the plugin, including fetching map URLs and managing global variables.
- `VersionCheckCDN.as`: Manages version checking from a CDN, with URLs for fetching the latest version information.
- `LogInfo.as`: Implements custom logging and notification functions, including various log levels.
- `data.csv`: Contains the UIDs of the maps.

## License
- The [Unlicense](https://unlicense.org/)