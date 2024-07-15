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
1. **Folder**: `/src/Settings/DisableOrEnable/*`
2. **Files**: `/src/Settings/DisableOrEnable/`
2. **Files**: `/src/Settings/DisableOrEnable/`
2. **Files**: `/src/Settings/DisableOrEnable/`
2. **Files**: `/src/Settings/DisableOrEnable/`

6. **Add**: Function and logic to enable/disable the new setting.

### Update UI
1. **File**: `/src/InGame/Render/SettingsUI.as`
2. **Add**: 
   ```c
   void RenderS_EXAMPLE() { IsUsing_EXAMPLE = UI::Checkbox("Example", IsUsing_EXAMPLE); }
   ```
   Also, update `alterationNames` and `alterationFuncs`.

### MatchesAlterationSettings
1. **File**: `/src/InGame/LoadMaps/GetMapUrl/GetMapWithStorageObject.as`
2. **Add**: 
   ```c
   if (IsUsing_EXAMPLE && map["alteration"] == "EXAMPLE") return true;
   ```
3. **Add**:
   `[Alteration]` to `IsAlterationSettingActive` 

   
### Exports
1. **File**: `\src\Exports\Export_Impl.as`
2. **Add**: 
   ```c
   settings["Alteration"]["Category"]["EXAMPLE"] = IsUsing_EXAMPLE;
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
   Add the new category function to both DissableAll and EnableAll. e.g `Select[CATEGORY]`.

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