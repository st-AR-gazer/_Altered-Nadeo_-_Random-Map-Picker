# START.py

This script is the main entry point for the `TMDownloadingAndSortingMaps` application. It orchestrates the execution of several other scripts in a specific order to accomplish its tasks. Here's a brief overview of what each script does:

1. `RecordFileStateToDir.py`: This script records the current state of the files in the directory. This is useful for tracking changes over time.

2. `DownloadFromNadeo.py`: This script downloads map files from Nadeo, the developer of TrackMania.

3. `SortByAlteration.py`: This script sorts the downloaded files based on their alteration dates.

4. `SortBySeason.py`: This script sorts the downloaded files based on their associated TrackMania season.

5. `RecordNewFileState.py`: This script records the state of the files after the download and sorting operations have been completed.

6. `CompareFileStates.py`: This script compares the state of the files before and after the download and sorting operations. This can be used to identify new or updated files.

7. `CopyUpdatedFiles.py`: This script copies any new or updated files to a separate directory for further processing.

The new files are uploaded to ManiaCDN, this link: `http://maniacdn.net/ar_/Alt-Map-Picker/New-Sorting-System/[SORTING TYPE]/[FILE NAME]` (if this is changed an update to the location the plugin is nessesary this variable needs to be updated `string NewSortingSystemUrl;`)

8. `CreateManifest.py`: This script creates a manifest file that provides an overview of the current state of the files in the directory.

The new manifest file is uploaded to ManiaCDN, this link: `http://maniacdn.net/ar_/Alt-Map-Picker/manifest/manifest.json` (if this is changed an update to the location the plugin is nessesary this variable needs to be updated `string manifestUrl;`)


Each script is run in a separate subprocess, and any output or errors from the script are printed to the console. Each script can be run indvidually, and there are cases where you'd want to do this, but generally just using `START.py` will make your life much easier.

