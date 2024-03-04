# Quick Guide to Adding an Alteration in Settings (Part 1)

This guide provides step-by-step instructions on how to add a new alteration.
For this explaination we're going to be adding "Rally"

**NOTE:** I'm using Rally as an example since it is newly added so this explanination is actually incorrect, Envimix campaigns are sorted at the top of every list, the rally campaign should therefore be located there, please use this as a generic explanination for most alterations.

**Note**: This is only part 1, part two tackles how to add it to the python script.
(It can be found further down)


## Step 0: Keeping the code 'clean'

Settings are sorted mostly alphabetically, but in this hirarcy:

Type e.g Season; Alteration; Other
Season.

Season has one special case you can read more about it in the `AddingASeason` documentation located in `\documentation`

Alterations does have a couple speical sorting cases

```bash
Envimix is sorted by itself.
```
There is no order to this yet, but when a new generation is added Snow(alpine) Rally and Dessert will be sorted as one group, moving onto the next.

Other than that it's alphabetically sorted, in the rest of the documentation this will loosely be reffered to as 'finding the correct spot to place the setting'.

**NOTE:** in `name=""` envimix is reffered to inside of `[]`



## Step 1: Adding the \[setting\]

1. Adding the main setting

Navigate to the file `src\Conditions\Settings\ByAlteration\IndividualEnableOrDissable.as` and add this in the correct location:
```c
[Setting category="ByAlteration" name="[Rally]"]
bool IsUsing_Rally_ = true;
```
(It's default state should be true)

2. Adding the alteration to the global dissable all

Navigate to the file `src\Conditions\Settings\DissableAll.as` and add this in the correct location:
```c
IsUsing_Rally_ = false;
```

3. Adding the alteration to the global enable all

Navigate to the file `src\Conditions\Settings\EnableAll.as` and add this in the correct location:
```c
IsUsing_Rally_ = true;
```

4. Adding the alteration to the files that should be included in a downlaod:

Navigate to the file `src\Conditions\Settings\ArrayKabeef\AlterationFiles.as` and add this in the correct location:
```c
if (IsUsing_Rally_) {
    filesToInclude.InsertLast(alterationFilePath + "_Rally_.json");
}
```

5. Adding the alteration to dissable all alterations:

Navigate to the file `src\Conditions\Settings\ByAlteration\DissableAllAlteration.as` and add this in the correct location:
```c
IsUsing_Rally_ = false;
```

6. Adding the alteration to enable all alterations:

Navigate to the file `src\Conditions\Settings\ByAlteration\EnableAllAlteration.as` and add this in the correct location:
```c
IsUsing_Rally_ = true;
```

7. Adding the alteration to Exports

Navigate to the file `src\Exports\Export_Impl.as` and add this in the correct location:

```c
bool SetRALLY(bool value) { if (value) { IsUsing_Rally_ = true; } else if (!value) { IsUsing_Rally_ = false; } else {return IsUsing_Rally_;} }
```

Now scroll up a big and add this line to the correct location:
```c
byAlteration["[Rally]"] = IsUsing_Rally_;
```

8. Adding the alteration to Exports p2

navigate to the file `` and add this to the correct location:
```c
import void SetRALLY(bool value) from "AlteredNadeo_RandomMapPicker";
```
Envimix alterations are reffered to with capitol case.


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