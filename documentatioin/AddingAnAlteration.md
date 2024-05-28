## Adding an alteration in SettingUI is outdated

# Quick Guide to Adding an Alteration in Settings (Part 1)

This documentation aims to guide you through the process of adding a new alteration, season, or discovery campaign to your project. It is divided into two main parts. The first part covers the addition of alterations, and the second part delves into updating the Python script for sorting maps with alterations.

## Part 1: Adding an Alteration

### Step 1: Initialize a Setting

1. Navigate to `/src/Conditions/Settings/InitAllSettings.as`.
2. Add the settings for the new alteration. Settings are generally sorted based on their representation on Discord. Match the location of the added alteration accordingly.

All settings, including those for alteration, seasonal, and discovery campaigns, are initialized here.

```c
[Setting category="Alteration" name="EXAMPLE"]
bool IsUsing_EXAMPLE = false;
```

**IMPORTANT:** All settings are prefixed with `IsUsing_`.


### Step 2: Enable/Disable the Setting

Navigate to `/src/Conditions/Settings/DisableOrEnable`. Here, you will find folders for different categories:

1. **Alterational**: In this folder, add the new alteration to the correct file and function. This is crucial as it's used by the UI buttons. If a new category is created, add a new function with the category name in both enable and disable files and place this new function in "DisableOrEnable" with the correct `Select[...]` / `Deselect[...]` logic.

2. **Seasonal**: Seasonal sorting is similar to alteration-based sorting but doesn't need updates until summer 2025.

3. **Discovery**: Similar to seasonal, update this only when a new discovery campaign is made.


### Step 3: Add the Setting to the UI

Navigate to `/src/InGame/Render/SettingsUI.as` to add the setting to the UI:

1. **For New Categories**: If a new category or campaign type that can spawn a subset of alterations (e.g., envimix, discovery campaigns, etc) is created, navigate to the correct location in the code. In the `// Active TABS` section, add a new tab if necessary:

```c
if (UI::Button("TAB NAME")) activeTab = -1;
``` 
(if you do not change the active tab for the other ones I will come to your house and move your entire setup 5cm to the left)

2. **Adding the Visual Part**: Navigate to the correct 'tab' location and add the setting, a 'recent' change has made the `newset` obsolete, so we will be adding a "RenderS_{SOMEVOID}" to the location, and then we will add the void under with the correct information. 

```c
void RenderNN() { 
    RenderS_100WetIcyWood();
}

void RenderS_100WetIcyWood() { IsUsing_100WetIcyWood = UI::Checkbox("100% Wet-Icy-Wood", IsUsing_100WetIcyWood); }
```

Make sure to ALSO add the name of the alteration to the `alterationNames` and `alterationFuncs` arrays as they are used for the 'search' option, These are found the bottom of the page.

**Note:** If a category has changed name, simply update the `TAB NAME` to the new name. If an alteration has moved categories, cut it from its current location and move it to the correct tab.


### Step 4: Add the Setting to `bool MatchesAlterationSettings(Json::Value map)`

Got to `/src/InGame/LoadMaps/GetMapUrl/GetMapWithStorageObject.as`
This step ensures that the newly added alteration setting is recognized and processed correctly when filtering maps. The `MatchesAlterationSettings` function and `MatchSeasonalSettings` both help with determining whether a map matches the current alteration settings activated by the user. Here is how to add an alteration to them. 

This should also be added to "IsAlterationSettingActive", (when it is time to update the seasonal settings, this should also be updated, but for IsSeasonSettingActive instead of alteration)

#### Add Your Alteration

Within the `MatchesAlterationSettings` function, you'll need to add a new conditional check for your alteration setting. This involves verifying if the setting is active (`IsUsing_YourNewAlteration`) and if the map's alteration attribute matches your alteration's identifier.

Here's an example of what this might look like for an alteration named "YourNewAlteration":

```c
if (IsUsing_YourNewAlteration && map["alteration"] == "YourNewAlteration") return true;
```

Ensure that your condition correctly checks both the setting's activation status and the match between the map's alteration attribute and your alteration's name.


**Note:** It's very important that the alteration identifier used in your condition (`"YourNewAlteration"`) matches exactly with what's expected in the map's JSON attribute. Inconsistencies here can lead to your alteration not being correctly identified, resulting in filtering errors. Here is an example of what the JSON looks like, look for the 'alteration' key.

```json
{
    "author": "5c9f57d9-2b40-4560-8a6f-3140905a9e4e",
    "authorScore": 42985,
    "bronzeScore": 65000,
    "collectionName": "Stadium",
    "createdWithGamepadEditor": null,
    "createdWithSimpleEditor": null,
    "filename": "Summer 2022 - 11 Broken.Map.Gbx",
    "goldScore": 46000,
    "isPlayable": true,
    "mapId": "3fa6070a-6ae8-414f-a7c2-0d2374ce326e",
    "mapStyle": "",
    "mapType": "TrackMania\\TM_Race",
    "mapUid": "AAPneKouvGKTiRSw3ZrgGHXO41m",
    "name": "Summer 2022 - 11 Broken",
    "silverScore": 52000,
    "submitter": "5c9f57d9-2b40-4560-8a6f-3140905a9e4e",
    "timestamp": "2022-08-24T21:27:45+00:00",
    "fileUrl": "https://core.trackmania.nadeo.live/storageObjects/44963995-e0ff-4640-8039-92fe96c4d5c8",
    "thumbnailUrl": "https://core.trackmania.nadeo.live/storageObjects/15f577ef-60c2-4a70-be0f-a240079fcf40.jpg",
    "season": "Summer",
    "year": "2022",
    "alteration": "Broken"
}
```

### Step 5: Add the Setting to the Exports

After integrating your new setting into the application's logic, it's also decently important to ensure that this setting is correctly exported so that other plugins can use it. Though I don't think anyone will bother XertroV asked for it, and I'm happy to oblige xdd. 
To add this new alteration to exports go to `\src\Exports\Export_Impl.as` and find the `GetUserSettings` function, and include your new alteration, ensuring that it's saved and retrievable as part of the user's settings.

#### Update the Settings Structure

Within the `GetUserSettings` function, locate the appropriate section for your new setting. The settings are categorized for better organization (e.g., `Surface`, `Effects`, `Finish Location`, etc.). They are categorised based on how it is on the Altered Nadeo discord, please use this as a reference when adding/moving/removing things PeepoShy.

For example, if you're adding a new `Surface` alteration named "NewSurfaceType", you would add the following line under the `Surface` category:

```c
settings["Alteration"]["Surface"]["NewSurfaceType"] = IsUsing_NewSurfaceType;
```

Make sure to also add the alteration to the  `SetAlteration` function.
```c++
    else if (t_alteration.ToLower() == "ALTERATION") { IsUsing_ALTERATION = t_shouldUse; }
```


# Quick Guide to Adding an Alteration in Settings (Part 2.1)

This part of the documentation tackles how to update the Python sorting script, focusing on the alterations part.

## Step 1

Navigate to `TMDownloadingAndSortingMaps/SortByAlteration.py` and locate the dictionary `alterations_dict`. The structure here is similar to what was previously discussed, with each alteration 'sorted' by name. Please add your alteration to the correct location.

```py
dict = [
    ...
    "[Snow]": ["[Snow]", "SnowCar", "CarSnow"],

    "[Rally]": ["[Rally]", "RallyCar", "CarRally"], # add this line

    "[Desert]": ["[Desert]", "DesertCar", "CarDesert"],
    ...
]
```

Add the name as the 'key' for each array in the dictionary. The rest of the items in this array are the names of the alterations. Each string in the array has to have been a part of a name of a map in an alteration. Due to inconsistencies in naming conventions, there are often multiple strings here since one alteration has has often gone by many names hence the need for both `[Rally]` and `RallyCar`, etc.


# Quick Guide to Adding an Alteration in Settings (Part 2.2)

This part of the documentation tackles how to update the python sorting script, focusing on the seasonal part.

(Note: This script will cease to function in 2100, but it's unlikely Trackmania will last that long anyway xdd)


## Step 1

The seasonal sorting should work correctly 99% of the time. The only exception is if someone deliberately messes with the filenames. (or if the filenames are non standard like the discovery campaigns)

For example, the Super Sized alteration, with names like "Super{map number}", does not indicate the season of addition. Non-standard naming schemes were manually addressed:
`{"uid": "2SbX9YGOeEo9OVFErIZYzYGRjh5", "name": "Super01", "season": "summer", "year": "2023", "alteration": "SuperSized"}`



# Other Important Information


## Special Maps Sorting

This section explains the sorting of special maps. The UID was extracted from the map file, and the rest of the attributes were filled in accordingly:
`{"uid": "", "name": "", "season": "", "year": "", "alteration": ""}`


## Split Names

Issues arise with alterations that have split names, such as `YEET Reverse`. For skill issue reasons on my part, these cases must be declared in the `special_cases_array`:

```py
special_cases_array = [
    "YEET Reverse", "[Snow] Wood", "[Snow] Checkpointless"
]
```

This is only necessary for multi-alterations that are also split, while alterations with straightforward string matching still work as expected. (`Wet Icy Wood` works, but `Wet {some string} Icy Wood` does not work)


## XX-But Alteration

Sorting XX-But maps can be challenging due to the lack of a predefined naming scheme. Maps that cannot be sorted through regex are sorted manually. 
-See #Special Maps Sorting


## Official Campaigns and Competition Maps (Including Discovery Maps)

Official and competition maps, which do not have an alteration tag but are included as "Official", require manual sorting by obtaining their UID, the same goes for the discovery maps such as "Snow Discovery", "Rally Discovery" and "Desert Discovery"
-See #Special Maps Sorting


## Unlabled maps

Some maps lack alteration labels. These were sorted manually after playing through each one. It is now common practice to label maps with names, making this more of an honourable mention. Something important to know, but not really used any more (hopefully).
-See #Special Maps Sorting


## A08 Alteration

The A08 alteration name is too general and leads to false positives. For this reason, it must be manually declared.
-See #Special Maps Sorting


## Placeholder Maps

To my knowledge, there is only one placeholder map, tracked by the AN bot. This map has a special key `"obtainable": False`, which should be set to false for all placeholder maps.
