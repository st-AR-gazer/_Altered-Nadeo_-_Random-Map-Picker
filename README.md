# Altered Nadeo - Random Map Picker

## Overview
This plugin for TrackMania allows users to load and play custom maps from a specified URL. It utilizes TrackMania's Nadeo live services API to fetch map URLs based on their UIDs.

## Features
- Fetches and plays maps from the TrackMania Nadeo live services API.
- Ability to load a new map from a list of UIDs.
- Notification system to warn about game edition compatibility.
- Custom logging functionality with different log levels (Info, Warn, Error).

## How It Works
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