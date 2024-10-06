# QuickAddingAnAlteration.md

## Files to Update

### Initialize Setting
1. **File**: `/src/Settings/InitAllSettings.as`
2. **Add**: 
   ```c
   [Setting category="Alteration" name="EXAMPLE"]
   bool IsUsing_EXAMPLE = false;
   ```
   
### Enable/Disable Setting
These are for seasonal and others (ctrl + p defaults to seasonal), check 'Alterational' folder too if you're adding an 'Alt' not just a season.
1. **Folder**: `/src/Settings/DisableOrEnable/*`
2. **Files**: `/src/Settings/DisableOrEnable/DisableDiscordBased.as`
3. **Files**: `/src/Settings/DisableOrEnable/EnableDiscordBased.as`
4. **Files**: `/src/Settings/DisableOrEnable/DisableOrEnableDiscordBased.as`

(If it's a discovery add it there)
5. **Files**: `/src/Settings/DisableOrEnable/`

6. **Add**: Variable so that a setting can be disabled / enabled by the user at the click of a button.

### Update UI
1. **File**: `/src/InGame/Render/SettingsUI.as`
2. **Add**: 
   Make sure to add to correct location, (if it's an effect alt it should go into effects etc)
   ```c
   alterationNames.InsertLast("EXAMPLE");
   alterationNames.InsertLast(@RenderS_EXAMPLE);
   ```
   ```c
   RenderS_Red_Effects();
   ```
   ```c
   void RenderS_EXAMPLE() { IsUsing_EXAMPLE = UI::Checkbox("Example", IsUsing_EXAMPLE); }
   ```

### MatchesAlterationSettings
1. **File**: `/src/InGame/LoadMaps/GetMapUrl/GetMapWithStorageObject.as`
2. **Add**: 
   ```c
   if (IsUsing_EXAMPLE && map["alteration"] == "EXAMPLE") return true;
   ```
3. **Add**:
   Make sure to add it in the correct location
   ```
   IsUsing_EXAMPLE 
   ```
   
### Exports
1. **File**: `\src\Exports\Export_Impl.as`
2. **Add**: 
   Add this to GetUserSettings
   ```c
   settings["Alterations"]["Category"]["EXAMPLE"] = IsUsing_EXAMPLE;
   ```
   And add this to SetAlteration
   ```c
   else if (t_alteration.ToLower() == "example") { IsUsing_EXAMPLE = t_shouldUse; }
   ```
   Update `SetAlteration` function accordingly.


# QuickAddingANewCategory

## Files to Update

### Initialize Setting

1. **File**: `/src/Settings/InitAllSettings.as`
2. **Add**: 
   Same as upper. Though, no new alts are needed since only the category is being made.

### Enable/Disable Setting
1. **Files**: `/src/Settings/DisableOrEnable/All/*`
2. **Add**:
   Add the new category function to both DisableAll and EnableAll. e.g `Select[CATEGORY]`.

### Update UI

1. **File**: `/src/InGame/Render/SettingsUI.as`
2. **Add**:
   ```c
   void Render[Example]() { 
      UI::Text('All the altered nadeo [Example] alterations');

      RenderS_EXAMPLE();
   }
   ```
3. **Add**:
   Also, update `alterationNames` and `alterationFuncs`.


(there is probably more but I cannot be bothered to write it all out rn, will do it later, maybe when the next category is added I guess xdd)




# QuickAddingANewDiscovery

## Files to Update

### Initialize Setting
1. **File**: `/src/Settings/InitAllSettings.as`
2. **Add**: 
   ```c
   [Setting category="Alteration" name="EXAMPLE Discovery"]
   bool IsUsing_AllEXAMPLEDiscovery = false;
   ```
   
### Enable/Disable Setting
Add the discovery too `DeselectDiscoveryCampaigns` and `SelectDiscoveryCampaigns`.

### Update UI
1. **File**: `/src/InGame/Render/SettingsUI.as`
2. **Add**: 
   Got to `RenderDiscoveryCampaigns()` and add:
   ```c
   void RenderS_EXAMPLEDiscovery() { IsUsing_AllEXAMPLEDiscovery = UI::Checkbox("EXAMPLE Discovery", IsUsing_AllEXAMPLEDiscovery); }
   ```

### MatchesAlterationSettings
1. **File**: `/src/InGame/LoadMaps/GetMapUrl/GetMapWithStorageObject.as`
2. **Add**: 
   ```c
   if (IsUsing_AllEXAMPLEDiscovery && season == "allEZAMPLEdiscovery") return true;
   ```
   To: `MatchesSeasonalSettings()`
   
### Exports
1. **File**: `\src\Exports\Export_Impl.as`
2. **Add**: 
   Add this to GetUserSettings
   ```c
   settings["Seasons"]["Discovery"]["EXAMPLE"] = IsUsing_AllEXAMPLEDiscovery;
   ```
   And add this to SetAlteration
   ```c
   else if (t_season.ToLower() == "example discovery") { IsUsing_AllEXAMPLEDiscovery = t_shouldUse; }
   ```
   Update `SetAlteration` function accordingly.