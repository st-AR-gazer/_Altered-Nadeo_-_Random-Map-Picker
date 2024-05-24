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

**Prerequisites: ** A file containing all the UIDs (I have gotten this from Kovca.) 

- Downloads maps from the Nadeo Live Services API using the list of UIDs.
- Sorts the maps based on the alteration/season.
- Constructs one massive json file containing all the information about the maps, with the addition of 'alteration', 'season' and 'year'.

(this is talked about more in depth in '/documentation/TM-DaSS.md')


## How It Works

### Plugin

Once the plugins starts up it sends a request to ManiaCDN and gets a manifest file back, this contains info on wheather or not it should update 
with the latest version og data.csv or consolidation_maps.json. Afterwards it goes through the process of checking permissions checking if folders 
exist or not, if the current instlation is the new or not etc. The plugin then loads the data.csv file and consolidated_maps.json file, and then 
it waits for user interaction. 

After the user selects a set of settings the plugin can use to filter maps, the plugin will then go through the process of filtering the maps, based 
on the settings the user has chosen. Once the maps have been filtered the plugin will then select a map at random from the filtered maps, and then
play it. 


### TM-DaSS

Please see the documentation for TM-DaSS in `/documentation/TM-DaSS.md` for more information on how it works.


## Prerequisites

### Plugin
- [TrackMania](https://trackmania.com) game installed.
- Plugin requires permissions to play local maps.

### TM-DaSS
- python installed.
- requests module installed.


## Installation of the plguin
1. **Installation**: Install the latest plugin version through the integrated plugin manager or by getting the latest .op file from this directory and 
placing it in: `C:\Users\%USERPROFILE%\OpenplanetNext\Plugins`.
2. **Using the plugin**: Access the plugin through the game's 'plugins' menu after pressing f3. Use the "Load New Altered Map" option to open the 
map picker window, here you can select the different settings you want to filter the maps by, as well as load maps based on a profile.

## File Structure

### Plugin

All the plugin files are found in the `.\src` directory.

- `.\src\`: Contains the plugin source code.
- `.\src\CDN`: Contains the code for fetching the manifest and the new maps from ManiaCDN.
- `.\src\Conditions`: Contains the code for checking perms, the custom logging the plugin uses, as well as some custom namespaces I commonly use that in my oppinion should be in OpenPlanet, but are not...
- `.\src\Data`: Contains the code for handeling the DefaultData, e.g moving it to storage, checking if the user uses an outdated version of the local manifest file + some utility functions.
- `.\src\DefaultData`: Contains the default data that the plugin uses, including the data.csv file and defaultInstalledVersion.json.
- `.\src\Exports`: Contains the plugins exports.
- `.\src\InGame`: Contains the code for the in game UI (`.\src\InGame\Render`), as well as loading the maps and playing them (`.\src\InGame\LoadMaps`).
- `.\src\Profiles`: Contains the namespace code for loading, creating, deleting profiles, only used in a small part of SettingsUI.as `.\src\InGame\Render\SettingsUI.as`.
- `.\src\Settings`: Contains the code for initializing the settings, loading the settings, changing the settings etc.

## License
- The [Unlicense](https://unlicense.org/)