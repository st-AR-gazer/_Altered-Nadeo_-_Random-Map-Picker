Json::Value allMaps;

void LoadMapFromStorageObject() {
    string mapUrl = FetchRandomMapUrl();

    if (mapUrl.Length == 0) {
        log("Failed to get map URL from storage objects. URL is: '" + mapUrl + "'", LogLevel::Error, 7, "LoadMapFromStorageObject"); // mapUrl will always be empty xdd
        NotifyWarn("Unable to retrieve the map URL from storage objects. \nThis issue is likely due to the absence of maps matching your specified criteria. Please adjust your selections of alterations and/or seasons to ensure that there are available maps.");

        return;
    }

    PlayMap(mapUrl);
}

void LoadMapsFromConsolidatedFile() {
    string filePath = IO::FromStorageFolder("Data/consolidated_maps.json");
    
    startnew(Coro_SetAllMaps, filePath);
}

void Coro_SetAllMaps(const string &in filePath) {
    // NotifyWarn("Loading maps from the consolidated file, this may take a few moments. Do not select a random map until this process is complete!");
    allMaps = Json::FromFile(filePath);
    log("Loaded " + allMaps.Length + " maps from the consolidated file", LogLevel::Info, 25, "Coro_SetAllMaps");
    // NotifyInfo("Loaded " + allMaps.Length + " maps from the consolidated file");
}

string FetchRandomMapUrl() {
    array<Json::Value@> FilteredMaps;

    if (Time::Now - startTime > 20) {
        yield();
        startTime = Time::Now;
    }

    // Filter out 'season', 'year' and 'alteration' settings, and score settings
    for (uint i = 0; i < allMaps.Length; ++i) {
        Json::Value map = allMaps[i];
        
        if (shoulduseCumulativeSelections) {
            if (MatchesSeasonalSettings(map) && MatchesAlterationSettings(map) && MatchesScoreSettings(map)) {
                FilteredMaps.InsertLast(map);
            }
        } else {
            if ((MatchesSeasonalSettings(map) || MatchesAlterationSettings(map)) && MatchesScoreSettings(map)) {
                FilteredMaps.InsertLast(map);
            }
        }
        if (Time::Now - startTime > 20) {
            yield();
            startTime = Time::Now;
        }
    }


    // Select random from filtered
    if (!FilteredMaps.IsEmpty()) {
        uint randomIndex = Math::Rand(0, FilteredMaps.Length);
        Json::Value@ selectedMap = FilteredMaps[randomIndex];

        if (selectedMap !is null && selectedMap.HasKey("fileUrl") && selectedMap["fileUrl"].GetType() == Json::Type::String) {
            return string(selectedMap["fileUrl"]);
        }
    }

    log("No maps match the selected criteria", LogLevel::Error, 67, "FetchRandomMapUrl");
    return "";
}

bool MatchesSeasonalSettings(Json::Value map) {
    if (!IsSeasonSettingActive()) { return true; }

    string season = map["season"];
    season = season.ToLower();
    string year = map["year"];

    string alteration = map["alteration"];
    alteration = alteration.ToLower();

    if (IsUsing_Spring2020Maps               && season == "spring"  && year == "2020") return true;
    if (IsUsing_Summer2020Maps               && season == "summer"  && year == "2020") return true;
    if (IsUsing_Fall2020Maps                 && season == "fall"    && year == "2020") return true;
    if (IsUsing_Winter2021Maps               && season == "winter"  && year == "2021") return true;
    if (IsUsing_Spring2021Maps               && season == "spring"  && year == "2021") return true;
    if (IsUsing_Summer2021Maps               && season == "summer"  && year == "2021") return true;
    if (IsUsing_Fall2021Maps                 && season == "fall"    && year == "2021") return true;
    if (IsUsing_Winter2022Maps               && season == "winter"  && year == "2022") return true;
    if (IsUsing_Spring2022Maps               && season == "spring"  && year == "2022") return true;
    if (IsUsing_Summer2022Maps               && season == "summer"  && year == "2022") return true;
    if (IsUsing_Fall2022Maps                 && season == "fall"    && year == "2022") return true;
    if (IsUsing_Winter2023Maps               && season == "winter"  && year == "2023") return true;
    if (IsUsing_Spring2023Maps               && season == "spring"  && year == "2023") return true;
    if (IsUsing_Summer2023Maps               && season == "summer"  && year == "2023") return true;
    if (IsUsing_Fall2023Maps                 && season == "fall"    && year == "2023") return true;
    if (IsUsing_Winter2024Maps               && season == "winter"  && year == "2024") return true;
    if (IsUsing_Spring2024Maps               && season == "spring"  && year == "2024") return true;
    if (IsUsing_Summer2024Maps               && season == "summer"  && year == "2024") return true;
    if (IsUsing_Fall2024Maps                 && season == "fall"    && year == "2024") return true;
    if (IsUsing_Winter2025Maps               && season == "winter"  && year == "2025") return true;
    if (IsUsing_Spring2025Maps               && season == "spring"  && year == "2025") return true;
    if (IsUsing_Summer2025Maps               && season == "summer"  && year == "2025") return true;

    if (IsUsing_AllSnowDiscovery             && season == "allsnowdiscovery") return true;
    if (IsUsing_AllRallyDiscovery            && season == "allrallydiscovery") return true;
    if (IsUsing_AllDesertDiscovery           && season == "alldesertdiscovery") return true;

    if (IsUsing__AllOfficialCompetitions     && alteration == "!allofficialcompetitions") return true;
    if (IsUsing_AllOfficialCompetitions      && season == "allofficialcompetitions") return true;

    if (IsUsing_AllTOTD                      && season == "alltotd") return true;

    return false;
}

bool MatchesAlterationSettings(Json::Value map) {
    if (!IsAlterationSettingActive()) { return true; }

    string alteration = map["alteration"];
    alteration = alteration.ToLower();

    if (IsUsing_Dirt                         && alteration == "dirt") return true;
    if (IsUsing_Fast_Magnet                  && alteration == "fast magnet") return true;
    if (IsUsing_Flooded                      && alteration == "flooded") return true;
    if (IsUsing_Grass                        && alteration == "grass") return true;
    if (IsUsing_Ice                          && alteration == "ice") return true;
    if (IsUsing_Magnet                       && alteration == "magnet") return true;
    if (IsUsing_Mixed                        && alteration == "mixed") return true;
    if (IsUsing_Better_Mixed                 && alteration == "better mixed") return true;
    if (IsUsing_Penalty                      && alteration == "penalty") return true;
    if (IsUsing_Plastic                      && alteration == "plastic") return true;
    if (IsUsing_Road                         && alteration == "road") return true;
    if (IsUsing_Wood                         && alteration == "wood") return true;
    if (IsUsing_Bobsleigh                    && alteration == "bobsleigh") return true;
    if (IsUsing_Pipe                         && alteration == "pipe") return true;
    if (IsUsing_Sausage                      && alteration == "sausage") return true;
    if (IsUsing_Underwater                   && alteration == "underwater") return true;

    if (IsUsing_Cruise                       && alteration == "cruise") return true;
    if (IsUsing_Fragile                      && alteration == "fragile") return true;
    if (IsUsing_Full_Fragile                 && alteration == "full fragile") return true;
    if (IsUsing_Freewheel                    && alteration == "freewheel") return true;
    if (IsUsing_Glider                       && alteration == "glider") return true;
    if (IsUsing_No_Brakes                    && alteration == "no brakes") return true;
    if (IsUsing_No_Effects                   && alteration == "no effects") return true;
    if (IsUsing_No_Grip                      && alteration == "no grip") return true;
    if (IsUsing_No_Steer                     && alteration == "no steer") return true;
    if (IsUsing_Random_Dankness              && alteration == "random dankness") return true;
    if (IsUsing_Random_Effects               && alteration == "random effects") return true;
    if (IsUsing_Reactor                      && alteration == "reactor") return true;
    if (IsUsing_Reactor_Down                 && alteration == "reactor down") return true;
    if (IsUsing_Red_Effects                  && alteration == "red effects") return true;
    if (IsUsing_RNG_Booster                  && alteration == "rng booster") return true;
    if (IsUsing_Slowmo                       && alteration == "slowmo") return true;
    if (IsUsing_Wet_Wheels                   && alteration == "wet wheels") return true;
    if (IsUsing_Worn_Tires                   && alteration == "worn tires") return true;

    if (IsUsing_1Down                        && alteration == "1 down") return true;
    if (IsUsing_1Back                        && alteration == "1 back") return true;
    if (IsUsing_1Left                        && alteration == "1 left") return true;
    if (IsUsing_1Right                       && alteration == "1 right") return true;
    if (IsUsing_1Up                          && alteration == "1 up") return true;
    if (IsUsing_2Up                          && alteration == "2 up") return true;
    if (IsUsing_Better_Reverse               && alteration == "better reverse") return true;
    if (IsUsing_CP1_is_End                   && alteration == "cp1 is end") return true;
    if (IsUsing_Floor_Fin                    && alteration == "floor fin") return true;
    if (IsUsing_Inclined                     && alteration == "inclined") return true;
    if (IsUsing_Manslaughter                 && alteration == "manslaughter") return true;
    if (IsUsing_No_Gear_5                    && alteration == "no gear 5") return true;
    if (IsUsing_Podium                       && alteration == "podium") return true;
    if (IsUsing_Puzzle                       && alteration == "puzzle") return true;
    if (IsUsing_Reverse                      && alteration == "reverse") return true;
    if (IsUsing_Roofing                      && alteration == "roofing") return true;
    if (IsUsing_Short                        && alteration == "short") return true;
    if (IsUsing_Sky_is_the_Finish            && alteration == "sky is the finish") return true;
    if (IsUsing_There_and_Back_Boomerang     && alteration == "there and back boomerang") return true;
    if (IsUsing_YEP_Tree_Puzzle              && alteration == "yep tree puzzle") return true;

    if (IsUsing_Stadium_                     && alteration == "[stadium]") return true;
    if (IsUsing_Stadium_Wet_Wood             && alteration == "[stadium] wet wood") return true;
    if (IsUsing_Snow_                        && alteration == "[snow]") return true;
    if (IsUsing_Snow_Carswitch               && alteration == "[snow] carswitch") return true;
    if (IsUsing_Snow_Checkpointless          && alteration == "[snow] checkpointless") return true;
    if (IsUsing_Snow_Icy                     && alteration == "[snow] icy") return true;
    if (IsUsing_Snow_Underwater              && alteration == "[snow] underwater") return true;
    if (IsUsing_Snow_Wet_Plastic             && alteration == "[snow] wet-plastic") return true;
    if (IsUsing_Snow_Wood                    && alteration == "[snow] wood") return true;
    if (IsUsing_Rally_                       && alteration == "[rally]") return true;
    if (IsUsing_Rally_Carswitch              && alteration == "[rally] carswitch") return true;
    if (IsUsing_Rally_CP1_is_End             && alteration == "[rally] cp1 is end") return true;
    if (IsUsing_Rally_Underwater             && alteration == "[rally] underwater") return true;
    if (IsUsing_Rally_Icy                    && alteration == "[rally] icy") return true;
    if (IsUsing_Desert_                      && alteration == "[desert]") return true;
    if (IsUsing_Desert_Carswitch             && alteration == "[desert] carswitch") return true;
    if (IsUsing_Desert_Underwater            && alteration == "[desert] underwater") return true;

    if (IsUsing_Race_                        && alteration == "[Race]") return true;
    if (IsUsing_Stunt_                       && alteration == "[Stunt]") return true;

    if (IsUsing_Checkpointless_Reverse       && alteration == "checkpointless reverse") return true;
    if (IsUsing_Ice_Reverse                  && alteration == "ice reverse") return true;
    if (IsUsing_Ice_Reverse_Reactor          && alteration == "ice reverse reactor") return true;
    if (IsUsing_Ice_Short                    && alteration == "ice short") return true;
    if (IsUsing_Magnet_Reverse               && alteration == "magnet reverse") return true;
    if (IsUsing_Plastic_Reverse              && alteration == "plastic reverse") return true;
    if (IsUsing_Sky_is_the_Finish_Reverse    && alteration == "sky is the finish reverse") return true;
    if (IsUsing_sw2u1l_cpu_f2d1r             && alteration == "sw2u1l-cpu-f2d1r") return true;
    if (IsUsing_Underwater_Reverse           && alteration == "underwater reverse") return true;
    if (IsUsing_Wet_Plastic                  && alteration == "wet plastic") return true;
    if (IsUsing_Wet_Wood                     && alteration == "wet wood") return true;
    if (IsUsing_Wet_Icy_Wood                 && alteration == "wet icy wood") return true;
    if (IsUsing_Yeet_Max_Up                  && alteration == "yeet max-up") return true;
    if (IsUsing_YEET_Puzzle                  && alteration == "yeet puzzle") return true;
    if (IsUsing_YEET_Random_Puzzle           && alteration == "yeet random puzzle") return true;
    if (IsUsing_YEET_Reverse                 && alteration == "yeet reverse") return true;

    if (IsUsing_XX_But                       && alteration == "xx-but") return true;
    if (IsUsing_Flat_2D                      && alteration == "flat_2d") return true;
    if (IsUsing_A08                          && alteration == "a08") return true;
    if (IsUsing_Antibooster                  && alteration == "antibooster") return true;
    if (IsUsing_Backwards                    && alteration == "backwards") return true;
    if (IsUsing_Boosterless                  && alteration == "boosterless") return true;
    if (IsUsing_BOSS                         && alteration == "boss") return true;
    if (IsUsing_Broken                       && alteration == "broken") return true;
    if (IsUsing_Bumper                       && alteration == "bumper") return true;
    if (IsUsing_Ngolo_Cacti                  && alteration == "ngolo_cacti") return true;
    if (IsUsing_Checkpoin_t                  && alteration == "checkpoin't") return true;
    if (IsUsing_Checkpointless               && alteration == "checkpointless") return true;
    if (IsUsing_Cleaned                      && alteration == "cleaned") return true;
    if (IsUsing_Colours_Combined             && alteration == "colours combined") return true;
    if (IsUsing_CP_Boost                     && alteration == "cp_boost") return true;
    if (IsUsing_CP1_Kept                     && alteration == "cp1 kept") return true;
    if (IsUsing_CPfull                       && alteration == "cpfull") return true;
    if (IsUsing_CPLink                       && alteration == "cpLink") return true;
    if (IsUsing_Earthquake                   && alteration == "earthquake") return true;
    if (IsUsing_Fast                         && alteration == "fast") return true;
    if (IsUsing_Flipped                      && alteration == "flipped") return true;
    if (IsUsing_Got_Rotated_CPs_Rotated_90__ && alteration == "got rotated_cps rotated 90°") return true;
    if (IsUsing_Ground_Clippers              && alteration == "ground clippers") return true;
 // if (IsUsing_Hard                         && alteration == "hard") return true; // NOTE TO SELF: It DOES find hard even though the log says it doesn't // Is actally Lunatic
    if (IsUsing_Holes                        && alteration == "holes") return true;    
    if (IsUsing_Lunatic                      && alteration == "lunatic") return true;
    if (IsUsing_Mini_RPG                     && alteration == "mini rpg") return true;
    if (IsUsing_Mirrored                     && alteration == "mirrored") return true;
    if (IsUsing_No_Items                     && alteration == "no items") return true;
    if (IsUsing_Pool_Hunters                 && alteration == "pool hunters") return true;
    if (IsUsing_Random                       && alteration == "random") return true;
    if (IsUsing_Ring_CP                      && alteration == "ring cp") return true;
    if (IsUsing_Sections_joined              && alteration == "sections joined") return true;
    if (IsUsing_Select_DEL                   && alteration == "select del") return true;
    if (IsUsing_Speedlimit                   && alteration == "speedlimit") return true;
    if (IsUsing_Start_1_Down                 && alteration == "start 1-down") return true;
    if (IsUsing_Supersized                   && alteration == "supersized") return true;
    if (IsUsing_Straight_to_the_Finish       && alteration == "straight to the finish") return true;
    if (IsUsing_Stunt                        && alteration == "stunt") return true;
    if (IsUsing_Symmetrical                  && alteration == "symmetrical") return true;
    if (IsUsing_Tilted                       && alteration == "tilted") return true;
    if (IsUsing_YEET                         && alteration == "yeet") return true;
    if (IsUsing_YEET_Down                    && alteration == "yeet down") return true;

 // if (IsUsing_Trainig                      && (map["alteration"] + "").ToLower() == "") return true; // This is in 'season' not 'alteration'
    if (IsUsing_TMGL_Easy                    && alteration == "tmgl easy") return true;
 // if (IsUsing__AllOfficialCompetitions     && (map["alteration"] + "").ToLower() == "") return true; // This is in 'season' not 'alteration'
    if (IsUsing_AllOfficialCompetitions      && alteration == "!allofficialcompetitions") return true;
    if (IsUsing_OfficialNadeo                && alteration == "!officialnadeo") return true;
 // if (IsUsing_AllTOTD                      && (map["alteration"] + "").ToLower() == "") return true; // This is in 'season' not 'alteration'


    return false;
}


bool MatchesScoreSettings(const Json::Value& map) {
    int authorScore = map["authorScore"];
    int goldScore = map["goldScore"];
    int silverScore = map["silverScore"];
    int bronzeScore = map["bronzeScore"];

    if ((authorScore < IsUsing_authorScoreMin) || (IsUsing_authorScoreMax != -1  && authorScore > IsUsing_authorScoreMax)) return false;
    if ((goldScore < IsUsing_goldScoreMin) || (IsUsing_goldScoreMax != -1        && goldScore > IsUsing_goldScoreMax))     return false;
    if ((silverScore < IsUsing_silverScoreMin) || (IsUsing_silverScoreMax != -1  && silverScore > IsUsing_silverScoreMax)) return false;
    if ((bronzeScore < IsUsing_bronzeScoreMin) || (IsUsing_bronzeScoreMax != -1  && bronzeScore > IsUsing_bronzeScoreMax)) return false;

    return true;
}


bool IsSeasonSettingActive() {
    return IsUsing_Spring2020Maps || IsUsing_Summer2020Maps || IsUsing_Fall2020Maps || 
        IsUsing_Winter2021Maps || IsUsing_Spring2021Maps || IsUsing_Summer2021Maps || IsUsing_Fall2021Maps || 
        IsUsing_Winter2022Maps || IsUsing_Spring2022Maps || IsUsing_Summer2022Maps || IsUsing_Fall2022Maps || 
        IsUsing_Winter2023Maps || IsUsing_Spring2023Maps || IsUsing_Summer2023Maps || IsUsing_Fall2023Maps || 
        IsUsing_Winter2024Maps || IsUsing_Spring2024Maps || IsUsing_Summer2024Maps || IsUsing_Fall2024Maps || 
        IsUsing_Winter2025Maps || IsUsing_Spring2025Maps || IsUsing_Summer2025Maps || 
        
        IsUsing_AllSnowDiscovery || IsUsing_AllRallyDiscovery || IsUsing_AllDesertDiscovery || 
        IsUsing__AllOfficialCompetitions || IsUsing_AllOfficialCompetitions || IsUsing_AllTOTD;
}

bool IsAlterationSettingActive() {
    return 
        IsUsing_Dirt || IsUsing_Fast_Magnet || IsUsing_Flooded || IsUsing_Grass || IsUsing_Ice || IsUsing_Magnet || IsUsing_Mixed || 
        IsUsing_Better_Mixed || IsUsing_Penalty || IsUsing_Plastic || IsUsing_Road || IsUsing_Wood || IsUsing_Bobsleigh || IsUsing_Pipe || 
        IsUsing_Sausage || IsUsing_Underwater || 
        
        IsUsing_Cruise || IsUsing_Fragile || IsUsing_Full_Fragile || IsUsing_Freewheel || IsUsing_Glider || IsUsing_No_Brakes || 
        IsUsing_No_Effects || IsUsing_No_Grip || IsUsing_No_Steer || IsUsing_Random_Dankness || IsUsing_Random_Effects || IsUsing_Reactor || 
        IsUsing_Reactor_Down || IsUsing_Red_Effects || IsUsing_Slowmo || IsUsing_Wet_Wheels || IsUsing_Worn_Tires || 
        
        IsUsing_1Down || IsUsing_1Back || IsUsing_1Left || IsUsing_1Right || IsUsing_1Up || IsUsing_2Up || IsUsing_Better_Reverse || 
        IsUsing_CP1_is_End || IsUsing_Floor_Fin || IsUsing_Inclined || IsUsing_Manslaughter || IsUsing_No_Gear_5 || IsUsing_Podium || 
        IsUsing_Puzzle || IsUsing_Reverse || IsUsing_Roofing || IsUsing_Short || IsUsing_Sky_is_the_Finish || IsUsing_There_and_Back_Boomerang || 
        IsUsing_YEP_Tree_Puzzle || 
        
        IsUsing_Stadium_ || IsUsing_Stadium_Wet_Wood || IsUsing_Snow_ || IsUsing_Snow_Carswitch || IsUsing_Snow_Checkpointless || 
        IsUsing_Snow_Icy || IsUsing_Snow_Underwater || IsUsing_Snow_Wet_Plastic || IsUsing_Snow_Wood || IsUsing_Rally_ || IsUsing_Rally_Carswitch || 
        IsUsing_Rally_CP1_is_End || IsUsing_Rally_Underwater || IsUsing_Rally_Icy || 

        IsUsing_Race_ || IsUsing_Stunt_ ||
        
        IsUsing_Checkpointless_Reverse || IsUsing_Ice_Reverse || IsUsing_Ice_Reverse_Reactor || IsUsing_Ice_Short || IsUsing_Magnet_Reverse || 
        IsUsing_Plastic_Reverse || IsUsing_Sky_is_the_Finish_Reverse || IsUsing_sw2u1l_cpu_f2d1r || IsUsing_Underwater_Reverse || 
        IsUsing_Wet_Plastic || IsUsing_Wet_Wood || IsUsing_Wet_Icy_Wood || IsUsing_Yeet_Max_Up || IsUsing_YEET_Puzzle || 
        IsUsing_YEET_Random_Puzzle || IsUsing_YEET_Reverse || 
        
        IsUsing_XX_But || IsUsing_Flat_2D || IsUsing_A08 || IsUsing_Antibooster || IsUsing_Backwards || IsUsing_Boosterless || IsUsing_BOSS || 
        IsUsing_Broken || IsUsing_Bumper || IsUsing_Ngolo_Cacti || IsUsing_Checkpoin_t || IsUsing_Cleaned || IsUsing_Colours_Combined || 
        IsUsing_CP_Boost || IsUsing_CP1_Kept || IsUsing_CPfull || IsUsing_Checkpointless || IsUsing_CPLink || IsUsing_Earthquake || IsUsing_Fast || 
        IsUsing_Flipped || IsUsing_Got_Rotated_CPs_Rotated_90__ || IsUsing_Ground_Clippers || /*IsUsing_Hard ||  // Is actally Lunatic */IsUsing_Holes || IsUsing_Lunatic || IsUsing_Mini_RPG || IsUsing_Mirrored || 
        IsUsing_No_Items || IsUsing_Pool_Hunters || IsUsing_Random || IsUsing_Ring_CP || IsUsing_Sections_joined || IsUsing_Select_DEL || IsUsing_Speedlimit || 
        IsUsing_Start_1_Down || IsUsing_Supersized || IsUsing_Straight_to_the_Finish || IsUsing_Stunt || IsUsing_Symmetrical || IsUsing_Tilted || IsUsing_YEET || 
        IsUsing_YEET_Down || 
        
        IsUsing_TMGL_Easy || IsUsing_AllOfficialCompetitions || IsUsing_OfficialNadeo;
}
