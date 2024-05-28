# Quick overview of TM-DaSS

This documentation aims to give you a quick overviw of TM-DaSS (TrackMania - Downloading and Sorting Scripts).

I shall first go over the non python files (`Part 1: Non python files`), the the python files (`Part 2: Python files`).
Then we go over how to use the scripts (`Part 3: How to use the scripts`).

### Requirements

- Requests library installed


### Startup commands

Some files can start with a starup flag, these files are:
`STAET_V2.py`,
`ConsolidateFilesToOne.py`,
`SortByAlteration.py`,
`SortBySeason.py`
they both take the starup command -v or --verbose


## Part 1: Non python files

TM-DaSS has multiple files/folders that are used for different things. Here is the structure:

Folders:
`.\TM-DaSS/`
`.\TM-DaSS/ByAlteration`
`.\TM-DaSS/BySeason`
`.\TM-DaSS/ConsolidatedMaps`

`.\TM-DaSS/data.csv`
`.\TM-DaSS/map_data.json`
`.\TM-DaSS/processed_uids.txt`

### Active

Here is what each of the folders and maps are used for.

`.\TM-DaSS/ByAlteration` stores all the downloaded alteration files, they are sorted into the files with the names of the alterations. This is done to later save them to another file with another script.
`.\TM-DaSS/BySeason` is much of the same, it stores all the downloaded season file, but this time the downloaded maps are stored by season.
How this is utilized will be explained more in `Part 2: The Python Files`.

.\TM-DaSS/ConsolidatedMaps is used in conjunction with `ConsolidateFilesToOne.py`, for now you should know that this folder is used to store the final output (as well as error logs for the final merge incase something goes wrong).

`.\TM-DaSS/data.csv` is the file containing a list of all the Altered Nadeo maps tracked by the Altered Nadeo WR bot. This file is gotten from Kovca. (Kovacs).

`.\TM-DaSS/map_data.json`, after running `DownloadFromNadeo.py`, the UIDs from data.csv are converted to the fully downloaded map object, this contains more information that is requied for the plugin to work propperly.

`.\TM-DaSS/processed_uids.txt`, this file is used to keep track of the UIDs that have been processed, this is used to avoid spamming Nadeos API, it's a bit buggy sometimes though...


## Part 2: Python files

`.\TM-DaSS/ConsolidateFilesToOne.py`
`.\TM-DaSS/DownloadFromNadeo.py`
`.\TM-DaSS/SortByAlteration.py`
`.\TM-DaSS/SortBySeason.py`
`.\TM-DaSS/SART_V2.py`

### Active

`.\TM-DaSS/ConsolidateFilesToOne.py` is used to consolidate the files in the `ByAlteration` and `BySeason` folders into a single file. This is used to create the final output that is used by the plugin, this includes adding the 'alteratoin' 'season' and 'year' to each json object. This is the final step in the process of downloading and sorting the maps.

`.\TM-DaSS/DownloadFromNadeo.py` is used to download map files from Nadeo. This script uses the UIDs from `data.csv` to download the map files. The downloaded json objects are sotred in the map_data.json file.

`.\TM-DaSS/SortByAlteration.py` is used to sort the downloaded json objects in the map_data.json file based on what is mentationed in their names.
`.\TM-DaSS/SortBySeason.py` is used to sort the downloaded json objects in the map_data.json file based on what is mentationed in their names, but this time based on what season is in the name.
Each alteration / season year are stored individually.

`.\TM-DaSS/START_V2.py` is the main way to interact with `TM-DaSS`, so long as data.csv is propperly updated this should be the only file you have to run. It orchestrates the execution of several other scripts in a specific order to accomplish its tasks. This script is used to run the entire process of downloading and sorting the maps.


## Part 3: How to use the scripts

To use the scripts manually first make sure you 1. have the requests library installed, 2. have the data.csv file updated with the latest maps.

Then you can run the scripts in the following order:

1. `DownloadFromNadeo.py`
2. `SortByAlteration.py` / `SortBySeason.py`
3. `ConsolidateFilesToOne.py`

And you are done, this can also be done with just running `START_V2.py` which will do all of the above in the correct order. This is the recommended way to run the scripts.