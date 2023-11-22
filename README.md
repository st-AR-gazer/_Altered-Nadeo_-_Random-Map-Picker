# Random Alt Map Picker

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
- `data.csv`: Contains the UIDs of the maps.
- Main plugin files with the core logic.

## Important Functions
- `CheckRequiredPermissions()`: Ensures the user's edition of the game supports the plugin's features.
- `NotifyWarn()`: Displays a notification in the game with warning messages.
- `RenderMenu()`: Renders the plugin menu in the game interface.

## Contributions
- Contributions to the plugin are welcome. Please follow the existing coding standards and submit pull requests for any enhancements or bug fixes.

## License
- The [Unlicense](https://unlicense.org/)

## Disclaimer
This plugin is not officially affiliated with TrackMania or Nadeo. It is a community-driven project! :)