# Quick Guide to Adding an Alteration in Settings (Part 1)

This guide provides step-by-step instructions on how to add a new alteration.
For this explaination we're going to be adding "Rally"

**NOTE:** I'm using Rally as an example since it is newly added so this explanination is actually incorrect, Envimix campaigns are sorted at the top of every list, the rally campaign should therefore be located there, please use this as a generic explanination for most alterations.

Note that this is only part 1, part two tackles how to add it to the python script.


## Step 1: Add Alteration to DisableAllAlterations

1. Navigate to the file: `src/Conditions/Settings/ByAlteration/DisableAllAlterations.as`

2. Locate the appropriate section within the file and add the alteration:
   ```c
   IsUsing_Random = false;
   IsUsing_Random_Dankness = false;
   IsUsing_Random_Effects = false;

   IsUsing_Rally = false; // Add this line

   IsUsing_Reactor = false;
   IsUsing_Reactor_Down = false;
   IsUsing_Reverse = false;
   ```


## Step 2: Enable Alteration in EnableAllAlterations

The process is the same for `src\Conditions\Settings\ArrayKabeef\EnableAllAlterations.as`
The only difference is that they are all true this time:
```c
IsUsing_Random = true;
IsUsing_Random_Dankness = true;
IsUsing_Random_Effects = true;

`IsUsing_Rally = true` // Add this line

IsUsing_Reactor = true;
IsUsing_Reactor_Down = true;
IsUsing_Reverse = true;
```

## Step 3: List Alterations Separately

This step is again mostly the same for  `src\Conditions\Settings\ArrayKabeef\` the only differnece is that each of the alterations this time are listed seperatly.

```c
[Setting category="ByAlteration" name="Random"]
bool IsUsing_Random = true;

[Setting category="ByAlteration" name="Random Dankness"]
bool IsUsing_Random_Dankness = true;

[Setting category="ByAlteration" name="Random Effects"]
bool IsUsing_Random_Effects = true;


`[Setting category="ByAlteration" name="Rally"]` // Add this line // Name should be the same as the alteration
`bool IsUsing_Rally = true;`                     // Add this line // Append `IsUsing_` to the start of alt name


[Setting category="ByAlteration" name="Reactor"]
bool IsUsing_Reactor = true;

[Setting category="ByAlteration" name="Reactor Down"]
bool IsUsing_Reactor_Down = true;

[Setting category="ByAlteration" name="Reverse"]
bool IsUsing_Reverse = true;
```

### NOTE: 
The rest of the code relies on this, so while everything works without the others, the setting will not show up if this is not here.


## Step 4: Update AlterationFiles

Next go to `src\Conditions\Settings\ArrayKabeef\AlterationFiles.as` and find the correct location again:

```c
if (IsUsing_Random) {
    filesToInclude.InsertLast(alterationFilePath + "Random.json");
}
if (IsUsing_Random_Dankness) {
    filesToInclude.InsertLast(alterationFilePath + "Random_Dankness.json");
}
if (IsUsing_Random_Effects) {
    filesToInclude.InsertLast(alterationFilePath + "Random_Effects.json");
}

if (IsUsing_Rally) {                                                // Add this line
    filesToInclude.InsertLast(alterationFilePath + "_Rally_.json"); // Add this line
}                                                                   // Add this line

if (IsUsing_Reactor) {
    filesToInclude.InsertLast(alterationFilePath + "Reactor.json");
}
if (IsUsing_Reactor_Down) {
    filesToInclude.InsertLast(alterationFilePath + "Reactor_Down.json");
}
if (IsUsing_Reverse) {
    filesToInclude.InsertLast(alterationFilePath + "Reverse.json");
}
```

### NOTE: 
Make sure that the file name is correct, alterations that use anything other than a "\_" to separete differenct characters are not supported by ManiaCDN and are automatically converted to a "\_", this means that "\[Rally\].json" is converted to "\_Rally\_.json".


## Step 5: Update DisableAll

Go to `src\Conditions\Settings\DissableAll.as` and find the correct location.

```c
IsUsing_Random = false;
IsUsing_Random_Dankness = false;
IsUsing_Random_Effects = false;

`IsUsing_Rally = false;` // Add this line

IsUsing_Reactor = false;
IsUsing_Reactor_Down = false;
IsUsing_Reverse = false;
```

## Step 6: Update EnableAll

Go to `src\Conditions\Settings\EnableAll.as` and find the correct location.

```c
IsUsing_Random = true;
IsUsing_Random_Dankness = true;
IsUsing_Random_Effects = true;

`IsUsing_Rally = true;` // Add this line

IsUsing_Reactor = true;
IsUsing_Reactor_Down = true;
IsUsing_Reverse = true;
```

## Step 7: Adding Alteration to Exports

Go to `src/Exports/Exports_impl.as` and find the correct location once again:
```c
void SetPodium(bool value)      { if (value) { IsUsing_Podium = true; }          if else (!value) { IsUsing_Podium = false; }          else {return;} }
void SetPoolHunters(bool value) { if (value) { IsUsing_Pool_Hunters = true; }    if else (!value) { IsUsing_Pool_Hunters = false; }    else {return;} }
void SetPuzzle(bool value)      { if (value) { IsUsing_Puzzle = true; }          if else (!value) { IsUsing_Puzzle = false; }          else {return;} }

void SetRALLY(bool value)       { if (value) { IsUsing_Rally_ = true; }          if else (!value) { IsUsing_Rally_ = false; }          else {return;} } // This is the spot

void SetRandom(bool value)      { if (value) { IsUsing_Random = true; }          if else (!value) { IsUsing_Random = false; }          else {return;} }
void SetRandomD(bool value)     { if (value) { IsUsing_Random_Dankness = true; } if else (!value) { IsUsing_Random_Dankness = false; } else {return;} }
void SetRandomE(bool value)     { if (value) { IsUsing_Random_Effects = true; }  if else (!value) { IsUsing_Random_Effects = false; }  else {return;} }
```

Next go to `src/Exports/Exports.as` and find the correct spot to add the alteraiton:

```c
import void SetPodium(bool value)         from "AlteredNadeo_RandomMapPicker";
import void SetPoolHunters(bool value)    from "AlteredNadeo_RandomMapPicker";
import void SetPuzzle(bool value)         from "AlteredNadeo_RandomMapPicker";

import void SetRALLY(bool value)          from "AlteredNadeo_RandomMapPicker"; // This is the spot

import void SetRandom(bool value)         from "AlteredNadeo_RandomMapPicker";
import void SetRandomDankness(bool value) from "AlteredNadeo_RandomMapPicker";
import void SetRandomEffects(bool value)  from "AlteredNadeo_RandomMapPicker";
```




## Summary

You have successfully added an alteration to the project settings, and added it as an export. Repeat this process for any additional alterations you wish to include. The process is the same for adding seasonal campaigns.


# Quick Guide to Adding an Alteration in Settings (Part 2.1)

This part of the documentation tackles how to update the python sorting script, focusing on the alterations part.

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

The seasonal sorting should work correctly 99% of the time. The only exception is if someone deliberately messes with the filenames. (or if the filenames are non standared like the discovery campaigns)

For example, the Super Sized alteration, with names like "Super{map number}", does not indicate the season of addition. Non-standard naming schemes were manually addressed:
`{"uid": "2SbX9YGOeEo9OVFErIZYzYGRjh5", "name": "Super01", "season": "summer", "year": "2023", "alteration": "SuperSized"}`



# Other Important Information


## Special Maps Sorting

This section explains the sorting of special maps. The UID was extracted from the map file, and the rest of the attributes were filled in accordingly:
`{"uid": "", "name": "", "season": "", "year": "", "alteration": ""}`


## Split Names

Issues arise with alterations that have split names, such as `YEET Reverse`. For skill issue reasons on my part these cases must be declared in the `special_cases_array`:

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

Official and competition maps, which do not have an alteration tag but are included as "Official", require manual sorting by obtaining their UID, the same goes for the discovery maps such as "Snow Discovery", "Rally Discovery" and "Desert Discorvery"
-See #Special Maps Sorting


## Unlabled maps

Some maps lack alteration labels. These were sorted manually after playing through each one. It is now common practice to label maps with names, making this more of an honorable mention. Something important to know, but not really used any more (hopefully).
-See #Special Maps Sorting


## A08 Alteration

The A08 alteration name is too general and leads to false positives. For this reason, it must be manually declared.
-See #Special Maps Sorting


## Placeholder Maps

To my knowledge, there is only one placeholder map, tracked by the AN bot. This map has a special key `"obtainable": False`, which should be set to false for all placeholder maps.