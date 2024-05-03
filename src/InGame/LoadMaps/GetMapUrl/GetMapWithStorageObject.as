Json::Value allMaps;

void LoadMapFromStorageObject() {
    string mapUrl = FetchRandomMapUrl();

    if (mapUrl.Length == 0) {
        log("Failed to get map URL from storage objects. URL is: '" + mapUrl + "'", LogLevel::Error, 7); // mapUrl will always be empty xdd
        NotifyWarn("Unable to retrieve the map URL from storage objects. \nThis issue is likely due to the absence of maps matching your specified criteria. Please adjust your selections of alterations and/or seasons to ensure that there are available maps.");

        return;
    }

    PlayMap(mapUrl);
}

void LoadMapsFromConsolidatedFile() {
    string filePath = IO::FromStorageFolder("Data/consolidated_maps.json");
    
    allMaps = Json::FromFile(filePath);
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

    log("No maps match the selected criteria", LogLevel::Error, 60);
    return "";
}

bool MatchesSeasonalSettings(Json::Value map) {
    if (!IsSeasonSettingActive()) {return true;}
    
    if (IsUsing_Spring2020Maps && (map["season"] == "Spring" || map["season"] == "spring") && map["year"] == "2020") return true;
    if (IsUsing_Summer2020Maps && (map["season"] == "Summer" || map["season"] == "summer") && map["year"] == "2020") return true;
    if (IsUsing_Fall2020Maps   && (map["season"] == "Fall"   || map["season"] == "fall")   && map["year"] == "2020") return true;
    if (IsUsing_Winter2021Maps && (map["season"] == "Winter" || map["season"] == "winter") && map["year"] == "2021") return true;
    if (IsUsing_Spring2021Maps && (map["season"] == "Spring" || map["season"] == "spring") && map["year"] == "2021") return true;
    if (IsUsing_Summer2021Maps && (map["season"] == "Summer" || map["season"] == "summer") && map["year"] == "2021") return true;
    if (IsUsing_Fall2021Maps   && (map["season"] == "Fall"   || map["season"] == "fall")   && map["year"] == "2021") return true;
    if (IsUsing_Winter2022Maps && (map["season"] == "Winter" || map["season"] == "winter") && map["year"] == "2022") return true;
    if (IsUsing_Spring2022Maps && (map["season"] == "Spring" || map["season"] == "spring") && map["year"] == "2022") return true;
    if (IsUsing_Summer2022Maps && (map["season"] == "Summer" || map["season"] == "summer") && map["year"] == "2022") return true;
    if (IsUsing_Fall2022Maps   && (map["season"] == "Fall"   || map["season"] == "fall")   && map["year"] == "2022") return true;
    if (IsUsing_Winter2023Maps && (map["season"] == "Winter" || map["season"] == "winter") && map["year"] == "2023") return true;
    if (IsUsing_Spring2023Maps && (map["season"] == "Spring" || map["season"] == "spring") && map["year"] == "2023") return true;
    if (IsUsing_Summer2023Maps && (map["season"] == "Summer" || map["season"] == "summer") && map["year"] == "2023") return true;
    if (IsUsing_Fall2023Maps   && (map["season"] == "Fall"   || map["season"] == "fall")   && map["year"] == "2023") return true;
    if (IsUsing_Winter2024Maps && (map["season"] == "Winter" || map["season"] == "winter") && map["year"] == "2024") return true;
    if (IsUsing_Spring2024Maps && (map["season"] == "Spring" || map["season"] == "spring") && map["year"] == "2024") return true;
    if (IsUsing_Summer2024Maps && (map["season"] == "Summer" || map["season"] == "summer") && map["year"] == "2024") return true;
    if (IsUsing_Fall2024Maps   && (map["season"] == "Fall"   || map["season"] == "fall")   && map["year"] == "2024") return true;
    if (IsUsing_Winter2025Maps && (map["season"] == "Winter" || map["season"] == "winter") && map["year"] == "2025") return true;
    if (IsUsing_Spring2025Maps && (map["season"] == "Spring" || map["season"] == "spring") && map["year"] == "2025") return true;
    if (IsUsing_Summer2025Maps && (map["season"] == "Summer" || map["season"] == "summer") && map["year"] == "2025") return true;

    if (IsUsing_AllSnowDiscovery   && map["season"] == "AllSnowDiscovery")   return true;
    if (IsUsing_AllRallyDiscovery  && map["season"] == "AllRallyDiscovery")  return true;
    if (IsUsing_AllDesertDiscovery && map["season"] == "AllDesertDiscovery") return true;

    if (IsUsing__AllOfficialCompetitions && map["alteration"] == "!AllOfficialCompetitions") return true;
    if (IsUsing_AllOfficialCompetitions  && map["season"] == "AllOfficialCompetitions")  return true;

    if (IsUsing_AllTOTD && map["season"] == "AllTOTD") return true;

    return false;
}

bool MatchesAlterationSettings(Json::Value map) {
    if (!IsAlterationSettingActive()) {return true;}

    if (IsUsing_Dirt                         && map["alteration"] == "Dirt") return true;
    if (IsUsing_Fast_Magnet                  && map["alteration"] == "Fast Mangnet") return true;
    if (IsUsing_Flooded                      && map["alteration"] == "Flooded") return true;
    if (IsUsing_Grass                        && map["alteration"] == "Grass") return true;
    if (IsUsing_Ice                          && map["alteration"] == "Ice") return true;
    if (IsUsing_Magnet                       && map["alteration"] == "Magnet") return true;
    if (IsUsing_Mixed                        && map["alteration"] == "Mixed") return true;
    if (IsUsing_Better_Mixed                 && map["alteration"] == "Better Mixed") return true;
    if (IsUsing_Penalty                      && map["alteration"] == "Penalty") return true;
    if (IsUsing_Plastic                      && map["alteration"] == "Plastic") return true;
    if (IsUsing_Road                         && map["alteration"] == "Road") return true;
    if (IsUsing_Wood                         && map["alteration"] == "Wood") return true;
    if (IsUsing_Bobsleigh                    && map["alteration"] == "Bobsleigh") return true;
    if (IsUsing_Pipe                         && map["alteration"] == "Pipe") return true;
    if (IsUsing_Sausage                      && map["alteration"] == "Sausage") return true;
    if (IsUsing_Underwater                   && map["alteration"] == "Underwater") return true;

    if (IsUsing_Cruise                       && map["alteration"] == "Cruise") return true;
    if (IsUsing_Fragile                      && map["alteration"] == "Fragile") return true;
    if (IsUsing_Full_Fragile                 && map["alteration"] == "Full Fragile") return true;
    if (IsUsing_Freewheel                    && map["alteration"] == "Freewheel") return true;
    if (IsUsing_Glider                       && map["alteration"] == "Glider") return true;
    if (IsUsing_No_Brakes                    && map["alteration"] == "No Brakes") return true;
    if (IsUsing_No_Effects                   && map["alteration"] == "No Effects") return true;
    if (IsUsing_No_Grip                      && map["alteration"] == "No Grip") return true;
    if (IsUsing_No_Steer                     && map["alteration"] == "No Steer") return true;
    if (IsUsing_Random_Dankness              && map["alteration"] == "Random Dankness") return true;
    if (IsUsing_Random_Effects               && map["alteration"] == "Random Effects") return true;
    if (IsUsing_Reactor                      && map["alteration"] == "Reactor") return true;
    if (IsUsing_Reactor_Down                 && map["alteration"] == "Reactor Down") return true;
    if (IsUsing_RNG_Booster                  && map["alteration"] == "RNG Booster") return true;
    if (IsUsing_Slowmo                       && map["alteration"] == "Slowmo") return true;
    if (IsUsing_Wet_Wheels                   && map["alteration"] == "Wet Wheels") return true;
    if (IsUsing_Worn_Tires                   && map["alteration"] == "Worn Tires") return true;

    if (IsUsing_1Down                        && map["alteration"] == "1 Down") return true;
    if (IsUsing_1Back                        && map["alteration"] == "1 Back") return true;
    if (IsUsing_1Left                        && map["alteration"] == "1 Left") return true;
    if (IsUsing_1Right                       && map["alteration"] == "1 Right") return true;
    if (IsUsing_1Up                          && map["alteration"] == "1 Up") return true;
    if (IsUsing_2Up                          && map["alteration"] == "2 Up") return true;
    if (IsUsing_Better_Reverse               && map["alteration"] == "Better Reverse") return true;
    if (IsUsing_CP1_is_End                   && map["alteration"] == "CP1 is End") return true;
    if (IsUsing_Floor_Fin                    && map["alteration"] == "Floor Fin") return true;
    if (IsUsing_Inclined                     && map["alteration"] == "Inclined") return true;
    if (IsUsing_Manslaughter                 && map["alteration"] == "Manslaughter") return true;
    if (IsUsing_No_Gear_5                    && map["alteration"] == "No Gear 5") return true;
    if (IsUsing_Podium                       && map["alteration"] == "Podium") return true;
    if (IsUsing_Puzzle                       && map["alteration"] == "Puzzle") return true;
    if (IsUsing_Reverse                      && map["alteration"] == "Reverse") return true;
    if (IsUsing_Roofing                      && map["alteration"] == "Roofing") return true;
    if (IsUsing_Short                        && map["alteration"] == "Short") return true;
    if (IsUsing_Sky_is_the_Finish            && map["alteration"] == "Sky is the Finish") return true;
    if (IsUsing_There_and_Back_Boomerang     && map["alteration"] == "There and Back_Boomerang") return true;
    if (IsUsing_YEP_Tree_Puzzle              && map["alteration"] == "YEP Tree Puzzle") return true;

    if (IsUsing_Stadium_                     && map["alteration"] == "[Stadium]") return true;
    if (IsUsing_Stadium_Wet_Wood             && map["alteration"] == "[Stadium] Wet Wood") return true;
    if (IsUsing_Snow_                        && map["alteration"] == "[Snow]") return true;
    if (IsUsing_Snow_Carswitch               && map["alteration"] == "[Snow] Carswitch") return true;
    if (IsUsing_Snow_Checkpointless          && map["alteration"] == "[Snow] Checkpointless") return true;
    if (IsUsing_Snow_Icy                     && map["alteration"] == "[Snow] Icy") return true;
    if (IsUsing_Snow_Underwater              && map["alteration"] == "[Snow] Underwater") return true;
    if (IsUsing_Snow_Wet_Plastic             && map["alteration"] == "[Snow] Wet-Plastic") return true;
    if (IsUsing_Snow_Wood                    && map["alteration"] == "[Snow] Wood") return true;
    if (IsUsing_Rally_                       && map["alteration"] == "[Rally]") return true;
    if (IsUsing_Rally_Carswitch              && map["alteration"] == "[Rally] Carswitch") return true;
    if (IsUsing_Rally_CP1_is_End             && map["alteration"] == "[Rally] CP1 is End") return true;
    if (IsUsing_Rally_Underwater             && map["alteration"] == "[Rally] Underwater") return true;
    if (IsUsing_Rally_Icy                    && map["alteration"] == "[Rally] Icy") return true;

    if (IsUsing_Checkpointless_Reverse       && map["alteration"] == "Checkpointless Reverse") return true;
    if (IsUsing_Ice_Reverse                  && map["alteration"] == "Ice Reverse") return true;
    if (IsUsing_Ice_Reverse_Reactor          && map["alteration"] == "Ice Reverse Reactor") return true;
    if (IsUsing_Ice_Short                    && map["alteration"] == "Ice Short") return true;
    if (IsUsing_Magnet_Reverse               && map["alteration"] == "Magnet Reverse") return true;
    if (IsUsing_Plastic_Reverse              && map["alteration"] == "Plastic Reverse") return true;
    if (IsUsing_Sky_is_the_Finish_Reverse    && map["alteration"] == "Sky is the Finish Reverse") return true;
    if (IsUsing_sw2u1l_cpu_f2d1r             && map["alteration"] == "sw2u1l-cpu-f2d1r") return true;
    if (IsUsing_Underwater_Reverse           && map["alteration"] == "Underwater Reverse") return true;
    if (IsUsing_Wet_Plastic                  && map["alteration"] == "Wet Plastic") return true;
    if (IsUsing_Wet_Wood                     && map["alteration"] == "Wet Wood") return true;
    if (IsUsing_Wet_Icy_Wood                 && map["alteration"] == "Wet Icy Wood") return true;
    if (IsUsing_Yeet_Max_Up                  && map["alteration"] == "YEET Max-Up") return true;
    if (IsUsing_YEET_Puzzle                  && map["alteration"] == "YEET Puzzle") return true;
    if (IsUsing_YEET_Random_Puzzle           && map["alteration"] == "YEET Random Puzzle") return true;
    if (IsUsing_YEET_Reverse                 && map["alteration"] == "YEET Reverse") return true;

    if (IsUsing_XX_But                       && map["alteration"] == "XX-But") return true;
    if (IsUsing_Flat_2D                      && map["alteration"] == "Flat_2D") return true;
    if (IsUsing_A08                          && map["alteration"] == "A08") return true;
    if (IsUsing_Antibooster                  && map["alteration"] == "Antibooster") return true;
    if (IsUsing_Backwards                    && map["alteration"] == "Backwards") return true;
    if (IsUsing_Boosterless                  && map["alteration"] == "Boosterless") return true;
    if (IsUsing_BOSS                         && map["alteration"] == "BOSS") return true;
    if (IsUsing_Broken                       && map["alteration"] == "Broken") return true;
    if (IsUsing_Bumper                       && map["alteration"] == "Bumper") return true;
    if (IsUsing_Ngolo_Cacti                  && map["alteration"] == "Ngolo_Cacti") return true;
    if (IsUsing_Checkpoin_t                  && map["alteration"] == "Checkpoin't") return true;
    if (IsUsing_Cleaned                      && map["alteration"] == "Cleaned") return true;
    if (IsUsing_Colours_Combined             && map["alteration"] == "Colours Combined") return true;
    if (IsUsing_CP_Boost                     && map["alteration"] == "CP_Boost") return true;
    if (IsUsing_CP1_Kept                     && map["alteration"] == "CP1 Kept") return true;
    if (IsUsing_CPfull                       && map["alteration"] == "CPfull") return true;
    if (IsUsing_Checkpointless               && map["alteration"] == "Checkpointless") return true;
    if (IsUsing_CPLink                       && map["alteration"] == "CPLink") return true;
    if (IsUsing_Earthquake                   && map["alteration"] == "Earthquake") return true;
    if (IsUsing_Fast                         && map["alteration"] == "Fast") return true;
    if (IsUsing_Flipped                      && map["alteration"] == "Flipped") return true;
    if (IsUsing_Got_Rotated_CPs_Rotated_90__ && map["alteration"] == "Got Rotated_CPs Rotated 90°") return true;
    // if (IsUsing_Hard                         && map["alteration"] == "Hard") return true; // NOTE TO SELF: It DOES find hard even though the log says it doesn't // Is actally Lunatic
    if (IsUsing_Holes                        && map["alteration"] == "Holes") return true;
    if (IsUsing_Lunatic                      && map["alteration"] == "Lunatic") return true;
    if (IsUsing_Mini_RPG                     && map["alteration"] == "Mini RPG") return true;
    if (IsUsing_Mirrored                     && map["alteration"] == "Mirrored") return true;
    if (IsUsing_Pool_Hunters                 && map["alteration"] == "Pool Hunters") return true;
    if (IsUsing_Random                       && map["alteration"] == "Random") return true;
    if (IsUsing_Ring_CP                      && map["alteration"] == "Ring CP") return true;
    if (IsUsing_Sections_joined              && map["alteration"] == "Sections Joined") return true;
    if (IsUsing_Select_DEL                   && map["alteration"] == "Select DEL") return true;
    if (IsUsing_Speedlimit                   && map["alteration"] == "Speedlimit") return true;
    if (IsUsing_Start_1_Down                 && map["alteration"] == "Start 1-Down") return true;
    if (IsUsing_Supersized                   && map["alteration"] == "Supersized") return true;
    if (IsUsing_Straight_to_the_Finish       && map["alteration"] == "Straight to the Finish") return true;
    if (IsUsing_Stunt                        && map["alteration"] == "Stunt") return true;
    if (IsUsing_Symmetrical                  && map["alteration"] == "Symmetrical") return true;
    if (IsUsing_Tilted                       && map["alteration"] == "Tilted") return true;
    if (IsUsing_YEET                         && map["alteration"] == "YEET") return true;
    if (IsUsing_YEET_Down                    && map["alteration"] == "YEET Down") return true;

 // if (IsUsing_Trainig                      && map["alteration"] == "") return true; // This is in 'season' not 'alteration'
    if (IsUsing_TMGL_Easy                    && map["alteration"] == "TMGL Easy") return true;
 // if (IsUsing__AllOfficialCompetitions     && map["alteration"] == "") return true; // This is in 'season' not 'alteration'
    if (IsUsing_AllOfficialCompetitions      && map["alteration"] == "!AllOfficialCompetitions") return true;
    if (IsUsing_OfficialNadeo                && map["alteration"] == "!OfficialNadeo") return true;
 // if (IsUsing_AllTOTD                      && map["alteration"] == "") return true; // This is in 'season' not 'alteration'

    return false;
}

bool MatchesScoreSettings(const Json::Value& map) {
    int authorScore = map["authorScore"];
    int goldScore = map["goldScore"];
    int silverScore = map["silverScore"];
    int bronzeScore = map["bronzeScore"];

    if ((authorScore < IsUsing_authorScoreMin) || (IsUsing_authorScoreMax != -1 && authorScore > IsUsing_authorScoreMax))
        return false;
    if ((goldScore < IsUsing_goldScoreMin) || (IsUsing_goldScoreMax != -1 && goldScore > IsUsing_goldScoreMax))
        return false;
    if ((silverScore < IsUsing_silverScoreMin) || (IsUsing_silverScoreMax != -1 && silverScore > IsUsing_silverScoreMax))
        return false;
    if ((bronzeScore < IsUsing_bronzeScoreMin) || (IsUsing_bronzeScoreMax != -1 && bronzeScore > IsUsing_bronzeScoreMax))
        return false;

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
        IsUsing_Reactor_Down || IsUsing_Slowmo || IsUsing_Wet_Wheels || IsUsing_Worn_Tires || 
        
        IsUsing_1Down || IsUsing_1Back || IsUsing_1Left || IsUsing_1Right || IsUsing_1Up || IsUsing_2Up || IsUsing_Better_Reverse || 
        IsUsing_CP1_is_End || IsUsing_Floor_Fin || IsUsing_Inclined || IsUsing_Manslaughter || IsUsing_No_Gear_5 || IsUsing_Podium || 
        IsUsing_Puzzle || IsUsing_Reverse || IsUsing_Roofing || IsUsing_Short || IsUsing_Sky_is_the_Finish || IsUsing_There_and_Back_Boomerang || 
        IsUsing_YEP_Tree_Puzzle || 
        
        IsUsing_Stadium_ || IsUsing_Stadium_Wet_Wood || IsUsing_Snow_ || IsUsing_Snow_Carswitch || IsUsing_Snow_Checkpointless || 
        IsUsing_Snow_Icy || IsUsing_Snow_Underwater || IsUsing_Snow_Wet_Plastic || IsUsing_Snow_Wood || IsUsing_Rally_ || IsUsing_Rally_Carswitch || 
        IsUsing_Rally_CP1_is_End || IsUsing_Rally_Underwater || IsUsing_Rally_Icy || 
        
        IsUsing_Checkpointless_Reverse || IsUsing_Ice_Reverse || IsUsing_Ice_Reverse_Reactor || IsUsing_Ice_Short || IsUsing_Magnet_Reverse || 
        IsUsing_Plastic_Reverse || IsUsing_Sky_is_the_Finish_Reverse || IsUsing_sw2u1l_cpu_f2d1r || IsUsing_Underwater_Reverse || 
        IsUsing_Wet_Plastic || IsUsing_Wet_Wood || IsUsing_Wet_Icy_Wood || IsUsing_Yeet_Max_Up || IsUsing_YEET_Puzzle || 
        IsUsing_YEET_Random_Puzzle || IsUsing_YEET_Reverse || 
        
        IsUsing_XX_But || IsUsing_Flat_2D || IsUsing_A08 || IsUsing_Antibooster || IsUsing_Backwards || IsUsing_Boosterless || IsUsing_BOSS || 
        IsUsing_Broken || IsUsing_Bumper || IsUsing_Ngolo_Cacti || IsUsing_Checkpoin_t || IsUsing_Cleaned || IsUsing_Colours_Combined || 
        IsUsing_CP_Boost || IsUsing_CP1_Kept || IsUsing_CPfull || IsUsing_Checkpointless || IsUsing_CPLink || IsUsing_Earthquake || IsUsing_Fast || 
        IsUsing_Flipped || IsUsing_Got_Rotated_CPs_Rotated_90__ || /*IsUsing_Hard ||  // Is actally Lunatic */IsUsing_Holes || IsUsing_Lunatic || IsUsing_Mini_RPG || IsUsing_Mirrored || 
        IsUsing_Pool_Hunters || IsUsing_Random || IsUsing_Ring_CP || IsUsing_Sections_joined || IsUsing_Select_DEL || IsUsing_Speedlimit || 
        IsUsing_Start_1_Down || IsUsing_Supersized || IsUsing_Straight_to_the_Finish || IsUsing_Stunt || IsUsing_Symmetrical || IsUsing_Tilted || IsUsing_YEET || 
        IsUsing_YEET_Down || 
        
        IsUsing_TMGL_Easy || IsUsing_AllOfficialCompetitions || IsUsing_OfficialNadeo;
}
