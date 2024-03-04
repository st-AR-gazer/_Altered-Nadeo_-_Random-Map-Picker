// string GetARandomAltMapUid() {
//     string uid = GetRandomUID();
//     return uid;
// }

Json::Value GetUserSettings() {
    Json::Value settings;

    Json::Value bySeason;
    bySeason["Only Winter Maps"] = IsUsing_OnlyWinterMaps;
    bySeason["Only Spring Maps"] = IsUsing_OnlySpringMaps;
    bySeason["Only Summer Maps"] = IsUsing_OnlySummerMaps;
    bySeason["Only Fall Maps"] = IsUsing_OnlyFallMaps;
    // Season Specific
    bySeason["Only Spring 2020 Maps"] = IsUsing_Spring2020Maps;
    bySeason["Only Summer 2020 Maps"] = IsUsing_Summer2020Maps;
    bySeason["Only Fall 2020 Maps"] = IsUsing_Winter2021Maps;
    bySeason["Only Winter 2021 Maps"] = IsUsing_Winter2021Maps;
    bySeason["Only Spring 2021 Maps"] = IsUsing_Summer2021Maps;
    bySeason["Only Summer 2021 Maps"] = IsUsing_Summer2021Maps;
    bySeason["Only Fall 2021 Maps"] = IsUsing_Fall2021Maps;
    bySeason["Only Winter 2022 Maps"] = IsUsing_Winter2022Maps;
    bySeason["Only Spring 2022 Maps"] = IsUsing_Spring2022Maps;
    bySeason["Only Summer 2022 Maps"] = IsUsing_Summer2022Maps;
    bySeason["Only Fall 2022 Maps"] = IsUsing_Fall2022Maps;
    bySeason["Only Winter 2023 Maps"] = IsUsing_Winter2023Maps;
    bySeason["Only Spring 2023 Maps"] = IsUsing_Spring2023Maps;
    bySeason["Only Summer 2023 Maps"] = IsUsing_Summer2023Maps;
    bySeason["Only Fall 2023 Maps"] = IsUsing_Fall2023Maps;
    bySeason["Only Winter 2024 Maps"] = IsUsing_Winter2024Maps;
    bySeason["Only Spring 2024 Maps"] = IsUsing_Spring2024Maps;
    bySeason["Only Summer 2024 Maps"] = IsUsing_Summer2024Maps;
    bySeason["Only Fall 2024 Maps"] = IsUsing_Fall2024Maps;
    bySeason["Only Winter 2025 Maps"] = IsUsing_Winter2025Maps;
    bySeason["Only Spring 2025 Maps"] = IsUsing_Spring2025Maps;

    // ByAlteration settings
    Json::Value byAlteration;
    byAlteration["[Snow]"] = IsUsing_Snow_;
    byAlteration["[Snow] Carswitch"] = IsUsing_Snow_Carswitch;
    byAlteration["[Snow] Checkpointless"] = IsUsing_Snow_Checkpointless;
    byAlteration["[Snow] Icy"] = IsUsing_Snow_Icy;
    byAlteration["[Snow] Underwater"] = IsUsing_Snow_Underwater;
    byAlteration["[Snow] Wood"] = IsUsing_Snow_Wood;
    byAlteration["[Stadium]"] = IsUsing_Stadium_;
    byAlteration["1 Back"] = IsUsing_1Back;
    byAlteration["1 Down"] = IsUsing_1Down;
    byAlteration["1 Left"] = IsUsing_1Left;
    byAlteration["1 Right"] = IsUsing_1Right;
    byAlteration["1 Up"] = IsUsing_1Up;
    byAlteration["2D"] = IsUsing_2D;
    byAlteration["2 Up"] = IsUsing_2Up;
    byAlteration["A08"] = IsUsing_A08;
    byAlteration["Antibooster"] = IsUsing_Antibooster;
    byAlteration["BOSS"] = IsUsing_BOSS;
    byAlteration["Backwards"] = IsUsing_Backwards;
    byAlteration["Better Mixed"] = IsUsing_Better_Mixed;
    byAlteration["Better Reverse"] = IsUsing_Better_Reverse;
    byAlteration["Blind"] = IsUsing_Blind;
    byAlteration["Bobsleigh"] = IsUsing_Bobsleigh;
    byAlteration["Boomerang / There'N'Back"] = IsUsing_Boomerang_There_and_Back;
    byAlteration["Boosterless"] = IsUsing_Boosterless;
    byAlteration["Broken"] = IsUsing_Broken;
    byAlteration["Bumper"] = IsUsing_Bumper;
    byAlteration["CP1 Kept"] = IsUsing_CP1_Kept;
    byAlteration["CP1 is End"] = IsUsing_CP1_is_End;
    byAlteration["CPLink"] = IsUsing_CPLink;
    byAlteration["CP Boost Swap"] = IsUsing_CP_Boost;
    byAlteration["CPfull"] = IsUsing_CPfull;
    byAlteration["Checkpoin't"] = IsUsing_Checkpoin_t;
    byAlteration["Checkpointless"] = IsUsing_Checkpointless;
    byAlteration["Checkpointless Reverse"] = IsUsing_Checkpointless_Reverse;
    byAlteration["Cleaned"] = IsUsing_Cleaned;
    byAlteration["Colors Combined"] = IsUsing_Colors_Combined;
    byAlteration["Cruise"] = IsUsing_Cruise;
    byAlteration["Dirt"] = IsUsing_Dirt;
    byAlteration["Earthquake"] = IsUsing_Earthquake;
    byAlteration["Effectless"] = IsUsing_Effectless;
    byAlteration["Egocentrism"] = IsUsing_Egocentrism;
    byAlteration["Fast"] = IsUsing_Fast;
    byAlteration["Fast Magnet"] = IsUsing_Fast_Magnet;
    byAlteration["Flipped"] = IsUsing_Flipped;
    byAlteration["Flooded"] = IsUsing_Flooded;
    byAlteration["Floor Fin"] = IsUsing_Floor_Fin;
    byAlteration["Fragile"] = IsUsing_Fragile;
    byAlteration["Freewheel"] = IsUsing_Freewheel;
    byAlteration["Glider"] = IsUsing_Glider;
    byAlteration["Got Rotated / CPs Rotated 90°"] = IsUsing_Got_Rotated_CPs_Rotated_90__;
    byAlteration["Grass"] = IsUsing_Grass;
    byAlteration["Hard"] = IsUsing_Hard;
    byAlteration["Holes"] = IsUsing_Holes;
    byAlteration["Ice"] = IsUsing_Ice;
    byAlteration["Ice Reverse"] = IsUsing_Ice_Reverse;
    byAlteration["Ice Reverse Reactor"] = IsUsing_Ice_Reverse_Reactor;
    byAlteration["Ice Short"] = IsUsing_Ice_Short;
    byAlteration["Icy Reactor"] = IsUsing_Icy_Reactor;
    byAlteration["Inclined"] = IsUsing_Inclined;
    byAlteration["Lunatic"] = IsUsing_Lunatic;
    byAlteration["Magnet"] = IsUsing_Magnet;
    byAlteration["Magnet Reverse"] = IsUsing_Magnet_Reverse;
    byAlteration["Manslaughter"] = IsUsing_Manslaughter;
    byAlteration["Mini RPG"] = IsUsing_Mini_RPG;
    byAlteration["Mirrored"] = IsUsing_Mirrored;
    byAlteration["Mixed"] = IsUsing_Mixed;
    byAlteration["Ngolo / Cacti"] = IsUsing_Ngolo_Cacti;
    byAlteration["No-Steer"] = IsUsing_No_Steer;
    byAlteration["No-brakes"] = IsUsing_No_brakes;
    byAlteration["No-cut"] = IsUsing_No_cut;
    byAlteration["No-grip"] = IsUsing_No_grip;
    byAlteration["No gear 5"] = IsUsing_No_gear_5;
    byAlteration["Penalty"] = IsUsing_Penalty;
    byAlteration["Pipe"] = IsUsing_Pipe;
    byAlteration["Plastic"] = IsUsing_Plastic;
    byAlteration["Plastic Reverse"] = IsUsing_Plastic_Reverse;
    byAlteration["Platform"] = IsUsing_Platform;
    byAlteration["Podium"] = IsUsing_Podium;
    byAlteration["Pool Hunters"] = IsUsing_Pool_Hunters;
    byAlteration["Puzzle"] = IsUsing_Puzzle;
    byAlteration["Random"] = IsUsing_Random;
    byAlteration["Random Dankness"] = IsUsing_Random_Dankness;
    byAlteration["Random Effects"] = IsUsing_Random_Effects;
    byAlteration["Reactor"] = IsUsing_Reactor;
    byAlteration["Reactor Down"] = IsUsing_Reactor_Down;
    byAlteration["Reverse"] = IsUsing_Reverse;
    byAlteration["Ring CP"] = IsUsing_Ring_CP;
    byAlteration["Road"] = IsUsing_Road;
    byAlteration["Road Dirt"] = IsUsing_Road_Dirt;
    byAlteration["Roofing"] = IsUsing_Roofing;
    byAlteration["Sausage"] = IsUsing_Sausage;
    byAlteration["Scuba Diving"] = IsUsing_Scuba_Diving;
    byAlteration["Sections-joined"] = IsUsing_Sections_joined;
    byAlteration["Select DEL"] = IsUsing_Select_DEL;
    byAlteration["Short"] = IsUsing_Short;
    byAlteration["Sky is the Finish"] = IsUsing_Sky_is_the_Finish;
    byAlteration["Sky is the Finish Reverse"] = IsUsing_Sky_is_the_Finish_Reverse;
    byAlteration["Slowmo"] = IsUsing_Slowmo;
    byAlteration["Speedlimit"] = IsUsing_Speedlimit;
    byAlteration["Staircase"] = IsUsing_Staircase;
    byAlteration["Start 1-Down"] = IsUsing_Start_1_Down;
    byAlteration["Straight to the Finish"] = IsUsing_Straight_to_the_Finish;
    byAlteration["Supersized"] = IsUsing_Supersized;
    byAlteration["Surfaceless"] = IsUsing_Surfaceless;
    byAlteration["Symmetrical"] = IsUsing_Symmetrical;
    byAlteration["TMGL Easy"] = IsUsing_TMGL_Easy;
    byAlteration["Tilted"] = IsUsing_Tilted;
    byAlteration["Underwater"] = IsUsing_Underwater;
    byAlteration["Underwater Reverse"] = IsUsing_Underwater_Reverse;
    byAlteration["Walmart Mini"] = IsUsing_Walmart_Mini;
    byAlteration["Wet Icy Wood"] = IsUsing_Wet_Icy_Wood;
    byAlteration["Wet Wheels"] = IsUsing_Wet_Wheels;
    byAlteration["Wet Wood"] = IsUsing_Wet_Wood;
    byAlteration["Wood"] = IsUsing_Wood;
    byAlteration["Worn Tires"] = IsUsing_Worn_Tires;
    byAlteration["XX-But"] = IsUsing_XX_But;
    byAlteration["YEET"] = IsUsing_YEET;
    byAlteration["YEET Down"] = IsUsing_YEET_Down;
    byAlteration["YEET Puzzle"] = IsUsing_YEET_Puzzle;
    byAlteration["YEET Random Puzzle"] = IsUsing_YEET_Random_Puzzle;
    byAlteration["YEET Reverse"] = IsUsing_YEET_Reverse;
    byAlteration["Yeet Max-Up"] = IsUsing_Yeet_Max_Up;
    byAlteration["YEP Tree Puzzle"] = IsUsing_YEP_Tree_Puzzle;
    byAlteration["sw2u1l-cpu-f2d1r"] = IsUsing_sw2u1l_cpu_f2d1r;


    // ByOther settings
    Json::Value byOther;
    byOther["All Official Competitions"] = IsUsing_AllOfficialCompetitions;
    byOther["Map Is Not Obtainable"] = IsUsing_MapIsNotObtainable;
    byOther["All official campaigns"] = IsUsing_OfficialNadeo;
    byOther["All TOTDs"] = IsUsing_AllTOTD;

    byOther["All Official Competitions (Other)"] = IsUsing__AllOfficialCompetitions;
    
    byOther["All Snow Discovery"] = IsUsing_AllSnowDiscovery;
    byOther["All Rally Discovery"] = IsUsing_AllRallyDiscovery;


    // Add categories to settings object
    settings["BySeason"] = bySeason;
    settings["ByAlteration"] = byAlteration;
    settings["ByOther"] = byOther;

    return settings;
}

void SetOnlyWinterMaps(bool value) {
    
}
void SetOnlySpringMaps(bool value) {
    
}
void SetOnlySummerMaps(bool value) {
    
}
void SetOnlyFallMaps(bool value) {
    
}

void SetSpring2020Maps(bool value) { if (value) { IsUsing_Spring2020Maps = true; } else { IsUsing_Spring2020Maps = false; } else {return;} }
void SetSummer2020Maps(bool value) { if (value) { IsUsing_Summer2020Maps = true; } else { IsUsing_Summer2020Maps = false; } else {return;} }
void SetFall2020Maps(bool value)   { if (value) { IsUsing_Fall2020Maps = true; }   else { IsUsing_Fall2020Maps = false; }   else {return;} }
void SetWinter2021Maps(bool value) { if (value) { IsUsing_Winter2021Maps = true; } else { IsUsing_Winter2021Maps = false; } else {return;} }
void SetSpring2021Maps(bool value) { if (value) { IsUsing_Spring2021Maps = true; } else { IsUsing_Spring2021Maps = false; } else {return;} }
void SetSummer2021Maps(bool value) { if (value) { IsUsing_Summer2021Maps = true; } else { IsUsing_Summer2021Maps = false; } else {return;} }
void SetFall2021Maps(bool value)   { if (value) { IsUsing_Fall2021Maps = true; }   else { IsUsing_Fall2021Maps = false; }   else {return;} }
void SetWinter2022Maps(bool value) { if (value) { IsUsing_Winter2022Maps = true; } else { IsUsing_Winter2022Maps = false; } else {return;} }
void SetSpring2022Maps(bool value) { if (value) { IsUsing_Spring2022Maps = true; } else { IsUsing_Spring2022Maps = false; } else {return;} }
void SetSummer2022Maps(bool value) { if (value) { IsUsing_Summer2022Maps = true; } else { IsUsing_Summer2022Maps = false; } else {return;} }
void SetFall2022Maps(bool value)   { if (value) { IsUsing_Fall2022Maps = true; }   else { IsUsing_Fall2022Maps = false; }   else {return;} }
void SetWinter2023Maps(bool value) { if (value) { IsUsing_Winter2023Maps = true; } else { IsUsing_Winter2023Maps = false; } else {return;} }
void SetSpring2023Maps(bool value) { if (value) { IsUsing_Spring2023Maps = true; } else { IsUsing_Spring2023Maps = false; } else {return;} }
void SetSummer2023Maps(bool value) { if (value) { IsUsing_Summer2023Maps = true; } else { IsUsing_Summer2023Maps = false; } else {return;} }
void SetFall2023Maps(bool value)   { if (value) { IsUsing_Fall2023Maps = true; }   else { IsUsing_Fall2023Maps = false; }   else {return;} }
void SetWinter2024Maps(bool value) { if (value) { IsUsing_Winter2024Maps = true; } else { IsUsing_Winter2024Maps = false; } else {return;} }
void SetSpring2024Maps(bool value) { if (value) { IsUsing_Spring2024Maps = true; } else { IsUsing_Spring2024Maps = false; } else {return;} }
void SetSummer2024Maps(bool value) { if (value) { IsUsing_Summer2024Maps = true; } else { IsUsing_Summer2024Maps = false; } else {return;} }
void SetFall2024Maps(bool value)   { if (value) { IsUsing_Fall2024Maps = true; }   else { IsUsing_Fall2024Maps = false; }   else {return;} }
void SetWinter2025Maps(bool value) { if (value) { IsUsing_Winter2025Maps = true; } else { IsUsing_Winter2025Maps = false; } else {return;} }
void SetSpring2025Maps(bool value) { if (value) { IsUsing_Spring2025Maps = true; } else { IsUsing_Spring2025Maps = false; } else {return;} }

void SetSNOW(bool value)                   { if (value) { IsUsing_Snow_ = true; }                        if else (!value) { IsUsing_Snow_ = false; }                        else {return;} }
void SetSNOW_Carswitch(bool value)         { if (value) { IsUsing_Snow_Carswitch = true; }               if else (!value) { IsUsing_Snow_Carswitch = false; }               else {return;} }
void SetSNOW_Checkpointless(bool value)    { if (value) { IsUsing_Snow_Checkpointless = true; }          if else (!value) { IsUsing_Snow_Checkpointless = false; }          else {return;} }
void SetSNOW_Icy(bool value)               { if (value) { IsUsing_Snow_Icy = true; }                     if else (!value) { IsUsing_Snow_Icy = false; }                     else {return;} }
void SetSNOW_Underwater(bool value)        { if (value) { IsUsing_Snow_Underwater = true; }              if else (!value) { IsUsing_Snow_Underwater = false; }              else {return;} }
void SetSNOW_Wood(bool value)              { if (value) { IsUsing_Snow_Wood = true; }                    if else (!value) { IsUsing_Snow_Wood = false; }                    else {return;} }

void SetSTADIUM(bool value)                { if (value) { IsUsing_Stadium_ = true; }                     if else (!value) { IsUsing_Stadium_ = false; }                     else {return;} }

void SetRALLY(bool value)                  { if (value) { IsUsing_Rally_ = true; }                       if else (!value) { IsUsing_Rally_ = false; }                       else {return;} }

void Set1Back(bool value)                  { if (value) { IsUsing_1Back = true; }                        if else (!value) { IsUsing_1Back = false; }                        else {return;} }
void Set1Down(bool value)                  { if (value) { IsUsing_1Down = true; }                        if else (!value) { IsUsing_1Down = false; }                        else {return;} }
void Set1Left(bool value)                  { if (value) { IsUsing_1Left = true; }                        if else (!value) { IsUsing_1Left = false; }                        else {return;} }
void Set1Right(bool value)                 { if (value) { IsUsing_1Right = true; }                       if else (!value) { IsUsing_1Right = false; }                       else {return;} }
void Set1Up(bool value)                    { if (value) { IsUsing_1Up = true; }                          if else (!value) { IsUsing_1Up = false; }                          else {return;} }
void Set2D(bool value)                     { if (value) { IsUsing_2D = true; }                           if else (!value) { IsUsing_2D = false; }                           else {return;} }
void Set2Up(bool value)                    { if (value) { IsUsing_2Up = true; }                          if else (!value) { IsUsing_2Up = false; }                          else {return;} }
void SetA08(bool value)                    { if (value) { IsUsing_A08 = true; }                          if else (!value) { IsUsing_A08 = false; }                          else {return;} }
void SetAntibooster(bool value)            { if (value) { IsUsing_Antibooster = true; }                  if else (!value) { IsUsing_Antibooster = false; }                  else {return;} }
void SetBoss(bool value)                   { if (value) { IsUsing_BOSS = true; }                         if else (!value) { IsUsing_BOSS = false; }                         else {return;} }
void SetBackwards(bool value)              { if (value) { IsUsing_Backwards = true; }                    if else (!value) { IsUsing_Backwards = false; }                    else {return;} }
void SetBetter_Mixed(bool value)           { if (value) { IsUsing_Better_Mixed = true; }                 if else (!value) { IsUsing_Better_Mixed = false; }                 else {return;} }
void SetBetter_Reverse(bool value)         { if (value) { IsUsing_Better_Reverse = true; }               if else (!value) { IsUsing_Better_Reverse = false; }               else {return;} }
void SetBlind(bool value)                  { if (value) { IsUsing_Blind = true; }                        if else (!value) { IsUsing_Blind = false; }                        else {return;} }
void SetBobsleigh(bool value)              { if (value) { IsUsing_Bobsleigh = true; }                    if else (!value) { IsUsing_Bobsleigh = false; }                    else {return;} }
void SetThereAndBack(bool value)           { if (value) { IsUsing_Boomerang_There_and_Back = true; }     if else (!value) { IsUsing_Boomerang_There_and_Back = false; }     else {return;} }
void SetBoosterless(bool value)            { if (value) { IsUsing_Boosterless = true; }                  if else (!value) { IsUsing_Boosterless = false; }                  else {return;} }
void SetBroken(bool value)                 { if (value) { IsUsing_Broken = true; }                       if else (!value) { IsUsing_Broken = false; }                       else {return;} }
void SetBumper(bool value)                 { if (value) { IsUsing_Bumper = true; }                       if else (!value) { IsUsing_Bumper = false; }                       else {return;} }
void SetCP1Kept(bool value)                { if (value) { IsUsing_CP1_Kept = true; }                     if else (!value) { IsUsing_CP1_Kept = false; }                     else {return;} }
void SetCP1IsEnd(bool value)               { if (value) { IsUsing_CP1_is_End = true; }                   if else (!value) { IsUsing_CP1_is_End = false; }                   else {return;} }
void SetCPLink(bool value)                 { if (value) { IsUsing_CPLink = true; }                       if else (!value) { IsUsing_CPLink = false; }                       else {return;} }
void SetCPBoost(bool value)                { if (value) { IsUsing_CP_Boost = true; }                     if else (!value) { IsUsing_CP_Boost = false; }                     else {return;} }
void SetCPfull(bool value)                 { if (value) { IsUsing_CPfull = true; }                       if else (!value) { IsUsing_CPfull = false; }                       else {return;} }
void SetCheckpoin_t(bool value)            { if (value) { IsUsing_Checkpoin_t = true; }                  if else (!value) { IsUsing_Checkpoin_t = false; }                  else {return;} }
void SetCheckpointless(bool value)         { if (value) { IsUsing_Checkpointless = true; }               if else (!value) { IsUsing_Checkpointless = false; }               else {return;} }
void SetCheckpointless_Reverse(bool value) { if (value) { IsUsing_Checkpointless_Reverse = true; }       if else (!value) { IsUsing_Checkpointless_Reverse = false; }       else {return;} }
void SetCleaned(bool value)                { if (value) { IsUsing_Cleaned = true; }                      if else (!value) { IsUsing_Cleaned = false; }                      else {return;} }
void SetColorsCombined(bool value)         { if (value) { IsUsing_Colors_Combined = true; }              if else (!value) { IsUsing_Colors_Combined = false; }              else {return;} }
void SetCruise(bool value)                 { if (value) { IsUsing_Cruise = true; }                       if else (!value) { IsUsing_Cruise = false; }                       else {return;} }
void SetDirt(bool value)                   { if (value) { IsUsing_Dirt = true; }                         if else (!value) { IsUsing_Dirt = false; }                         else {return;} }
void SetEarthquake(bool value)             { if (value) { IsUsing_Earthquake = true; }                   if else (!value) { IsUsing_Earthquake = false; }                   else {return;} }
void SetEffectless(bool value)             { if (value) { IsUsing_Effectless = true; }                   if else (!value) { IsUsing_Effectless = false; }                   else {return;} } 
void SetEgocentrism(bool value)            { if (value) { IsUsing_Egocentrism = true; }                  if else (!value) { IsUsing_Egocentrism = false; }                  else {return;} }
void SetFast(bool value)                   { if (value) { IsUsing_Fast = true; }                         if else (!value) { IsUsing_Fast = false; }                         else {return;} }
void SetFastMagnet(bool value)             { if (value) { IsUsing_Fast_Magnet = true; }                  if else (!value) { IsUsing_Fast_Magnet = false; }                  else {return;} }
void SetFlipped(bool value)                { if (value) { IsUsing_Flipped = true; }                      if else (!value) { IsUsing_Flipped = false; }                      else {return;} }
void SetFlooded(bool value)                { if (value) { IsUsing_Flooded = true; }                      if else (!value) { IsUsing_Flooded = false; }                      else {return;} }
void SetFloorFin(bool value)               { if (value) { IsUsing_Floor_Fin = true; }                    if else (!value) { IsUsing_Floor_Fin = false; }                    else {return;} }
void SetFragile(bool value)                { if (value) { IsUsing_Fragile = true; }                      if else (!value) { IsUsing_Fragile = false; }                      else {return;} }
void SetFreewheel(bool value)              { if (value) { IsUsing_Freewheel = true; }                    if else (!value) { IsUsing_Freewheel = false; }                    else {return;} }
void SetGlider(bool value)                 { if (value) { IsUsing_Glider = true; }                       if else (!value) { IsUsing_Glider = false; }                       else {return;} }
void SetGotRotated_CPsRotated(bool value)  { if (value) { IsUsing_Got_Rotated_CPs_Rotated_90__ = true; } if else (!value) { IsUsing_Got_Rotated_CPs_Rotated_90__ = false; } else {return;} }
void SetGrass(bool value)                  { if (value) { IsUsing_Grass = true; }                        if else (!value) { IsUsing_Grass = false; }                        else {return;} }
void SetHard(bool value)                   { if (value) { IsUsing_Hard = true; }                         if else (!value) { IsUsing_Hard = false; }                         else {return;} }
void SetHoles(bool value)                  { if (value) { IsUsing_Holes = true; }                        if else (!value) { IsUsing_Holes = false; }                        else {return;} }
void SetIce(bool value)                    { if (value) { IsUsing_Ice = true; }                          if else (!value) { IsUsing_Ice = false; }                          else {return;} }
void SetIce_Reverse(bool value)            { if (value) { IsUsing_Ice_Reverse = true; }                  if else (!value) { IsUsing_Ice_Reverse = false; }                  else {return;} }
void SetIce_Reverse_Reactor(bool value)    { if (value) { IsUsing_Ice_Reverse_Reactor = true; }          if else (!value) { IsUsing_Ice_Reverse_Reactor = false; }          else {return;} }
void SetIce_Short(bool value)              { if (value) { IsUsing_Ice_Short = true; }                    if else (!value) { IsUsing_Ice_Short = false; }                    else {return;} }
void SetIcy_Reactor(bool value)            { if (value) { IsUsing_Icy_Reactor = true; }                  if else (!value) { IsUsing_Icy_Reactor = false; }                  else {return;} }
void SetInclined(bool value)               { if (value) { IsUsing_Inclined = true; }                     if else (!value) { IsUsing_Inclined = false; }                     else {return;} }
void SetLunatic(bool value)                { if (value) { IsUsing_Lunatic = true; }                      if else (!value) { IsUsing_Lunatic = false; }                      else {return;} }
void SetMagnet(bool value)                 { if (value) { IsUsing_Magnet = true; }                       if else (!value) { IsUsing_Magnet = false; }                       else {return;} }
void SetMagnet_Reverse(bool value)         { if (value) { IsUsing_Magnet_Reverse = true; }               if else (!value) { IsUsing_Magnet_Reverse = false; }               else {return;} }
void SetManslaughter(bool value)           { if (value) { IsUsing_Manslaughter = true; }                 if else (!value) { IsUsing_Manslaughter = false; }                 else {return;} }
void SetMiniRPG(bool value)                { if (value) { IsUsing_Mini_RPG = true; }                     if else (!value) { IsUsing_Mini_RPG = false; }                     else {return;} }
void SetMirrored(bool value)               { if (value) { IsUsing_Mirrored = true; }                     if else (!value) { IsUsing_Mirrored = false; }                     else {return;} }
void SetMixed(bool value)                  { if (value) { IsUsing_Mixed = true; }                        if else (!value) { IsUsing_Mixed = false; }                        else {return;} }
void SetNgolo_Cacti(bool value)            { if (value) { IsUsing_Ngolo_Cacti = true; }                  if else (!value) { IsUsing_Ngolo_Cacti = false; }                  else {return;} }
void SetNoSteer(bool value)                { if (value) { IsUsing_No_Steer = true; }                     if else (!value) { IsUsing_No_Steer = false; }                     else {return;} }
void SetNoBrakes(bool value)               { if (value) { IsUsing_No_brakes = true; }                    if else (!value) { IsUsing_No_brakes = false; }                    else {return;} }
void SetNoCut(bool value)                  { if (value) { IsUsing_No_cut = true; }                       if else (!value) { IsUsing_No_cut = false; }                       else {return;} }
void SetNoGrip(bool value)                 { if (value) { IsUsing_No_grip = true; }                      if else (!value) { IsUsing_No_grip = false; }                      else {return;} }
void SetNoGear5(bool value)                { if (value) { IsUsing_No_gear_5 = true; }                    if else (!value) { IsUsing_No_gear_5 = false; }                    else {return;} }
void SetPenalty(bool value)                { if (value) { IsUsing_Penalty = true; }                      if else (!value) { IsUsing_Penalty = false; }                      else {return;} }
void SetPipe(bool value)                   { if (value) { IsUsing_Pipe = true; }                         if else (!value) { IsUsing_Pipe = false; }                         else {return;} }
void SetPlastic(bool value)                { if (value) { IsUsing_Plastic = true; }                      if else (!value) { IsUsing_Plastic = false; }                      else {return;} }
void SetPlastic_Reverse(bool value)        { if (value) { IsUsing_Plastic_Reverse = true; }              if else (!value) { IsUsing_Plastic_Reverse = false; }              else {return;} }
void SetPlatform(bool value)               { if (value) { IsUsing_Platform = true; }                     if else (!value) { IsUsing_Platform = false; }                     else {return;} }
void SetPodium(bool value)                 { if (value) { IsUsing_Podium = true; }                       if else (!value) { IsUsing_Podium = false; }                       else {return;} }
void SetPoolHunters(bool value)            { if (value) { IsUsing_Pool_Hunters = true; }                 if else (!value) { IsUsing_Pool_Hunters = false; }                 else {return;} }
void SetPuzzle(bool value)                 { if (value) { IsUsing_Puzzle = true; }                       if else (!value) { IsUsing_Puzzle = false; }                       else {return;} }
void SetRandom(bool value)                 { if (value) { IsUsing_Random = true; }                       if else (!value) { IsUsing_Random = false; }                       else {return;} }
void SetRandomDankness(bool value)         { if (value) { IsUsing_Random_Dankness = true; }              if else (!value) { IsUsing_Random_Dankness = false; }              else {return;} }
void SetRandomEffects(bool value)          { if (value) { IsUsing_Random_Effects = true; }               if else (!value) { IsUsing_Random_Effects = false; }               else {return;} }
void SetReactor(bool value)                { if (value) { IsUsing_Reactor = true; }                      if else (!value) { IsUsing_Reactor = false; }                      else {return;} }
void SetReactorDown(bool value)            { if (value) { IsUsing_Reactor_Down = true; }                 if else (!value) { IsUsing_Reactor_Down = false; }                 else {return;} }
void SetReverse(bool value)                { if (value) { IsUsing_Reverse = true; }                      if else (!value) { IsUsing_Reverse = false; }                      else {return;} }
void SetRingCP(bool value)                 { if (value) { IsUsing_Ring_CP = true; }                      if else (!value) { IsUsing_Ring_CP = false; }                      else {return;} }
void SetRoad(bool value)                   { if (value) { IsUsing_Road = true; }                         if else (!value) { IsUsing_Road = false; }                         else {return;} }
void SetRoad_Dirt(bool value)              { if (value) { IsUsing_Road_Dirt = true; }                    if else (!value) { IsUsing_Road_Dirt = false; }                    else {return;} } 
void SetRoofing(bool value)                { if (value) { IsUsing_Roofing = true; }                      if else (!value) { IsUsing_Roofing = false; }                      else {return;} }
void SetSausage(bool value)                { if (value) { IsUsing_Sausage = true; }                      if else (!value) { IsUsing_Sausage = false; }                      else {return;} }
void SetScubaDiving(bool value)            { if (value) { IsUsing_Scuba_Diving = true; }                 if else (!value) { IsUsing_Scuba_Diving = false; }                 else {return;} }
void SetSectionsjoined(bool value)         { if (value) { IsUsing_Sections_joined = true; }              if else (!value) { IsUsing_Sections_joined = false; }              else {return;} }
void SetSelectDEL(bool value)              { if (value) { IsUsing_Select_DEL = true; }                   if else (!value) { IsUsing_Select_DEL = false; }                   else {return;} }
void SetShort(bool value)                  { if (value) { IsUsing_Short = true; }                        if else (!value) { IsUsing_Short = false; }                        else {return;} }
void SetSkyIsTheFinish(bool value)         { if (value) { IsUsing_Sky_is_the_Finish = true; }            if else (!value) { IsUsing_Sky_is_the_Finish = false; }            else {return;} }
void SetSkyIsTheFinishReverse(bool value)  { if (value) { IsUsing_Sky_is_the_Finish_Reverse = true; }    if else (!value) { IsUsing_Sky_is_the_Finish_Reverse = false; }    else {return;} }
void SetSlowmo(bool value)                 { if (value) { IsUsing_Slowmo = true; }                       if else (!value) { IsUsing_Slowmo = false; }                       else {return;} }
void SetSpeedlimit(bool value)             { if (value) { IsUsing_Speedlimit = true; }                   if else (!value) { IsUsing_Speedlimit = false; }                   else {return;} }
void SetStaircase(bool value)              { if (value) { IsUsing_Staircase = true; }                    if else (!value) { IsUsing_Staircase = false; }                    else {return;} }
void SetStart1Down(bool value)             { if (value) { IsUsing_Start_1_Down = true; }                 if else (!value) { IsUsing_Start_1_Down = false; }                 else {return;} }
void SetStraightToTheFinish(bool value)    { if (value) { IsUsing_Straight_to_the_Finish = true; }       if else (!value) { IsUsing_Straight_to_the_Finish = false; }       else {return;} }
void SetSupersized(bool value)             { if (value) { IsUsing_Supersized = true; }                   if else (!value) { IsUsing_Supersized = false; }                   else {return;} }
void SetSurfaceless(bool value)            { if (value) { IsUsing_Surfaceless = true; }                  if else (!value) { IsUsing_Surfaceless = false; }                  else {return;} }
void Set_sw2u1l_cpu_f2d1r(bool value)      { if (value) { IsUsing_sw2u1l_cpu_f2d1r = true; }             if else (!value) { IsUsing_sw2u1l_cpu_f2d1r = false; }             else {return;} }
void SetSymmetrical(bool value)            { if (value) { IsUsing_Symmetrical = true; }                  if else (!value) { IsUsing_Symmetrical = false; }                  else {return;} }
void SetTMGL_Easy(bool value)              { if (value) { IsUsing_TMGL_Easy = true; }                    if else (!value) { IsUsing_TMGL_Easy = false; }                    else {return;} }
void SetTilted(bool value)                 { if (value) { IsUsing_Tilted = true; }                       if else (!value) { IsUsing_Tilted = false; }                       else {return;} }
void SetUnderwater(bool value)             { if (value) { IsUsing_Underwater = true; }                   if else (!value) { IsUsing_Underwater = false; }                   else {return;} }
void SetUnderwater_Reverse(bool value)     { if (value) { IsUsing_Underwater_Reverse = true; }           if else (!value) { IsUsing_Underwater_Reverse = false; }           else {return;} }
void SetWalmartMini(bool value)            { if (value) { IsUsing_Walmart_Mini = true; }                 if else (!value) { IsUsing_Walmart_Mini = false; }                 else {return;} }
void SetWetIcyWood(bool value)             { if (value) { IsUsing_Wet_Icy_Wood = true; }                 if else (!value) { IsUsing_Wet_Icy_Wood = false; }                 else {return;} }
void SetWetWheels(bool value)              { if (value) { IsUsing_Wet_Wheels = true; }                   if else (!value) { IsUsing_Wet_Wheels = false; }                   else {return;} }
void SetWetWood(bool value)                { if (value) { IsUsing_Wet_Wood = true; }                     if else (!value) { IsUsing_Wet_Wood = false; }                     else {return;} }
void SetWood(bool value)                   { if (value) { IsUsing_Wood = true; }                         if else (!value) { IsUsing_Wood = false; }                         else {return;} }
void SetWornTires(bool value)              { if (value) { IsUsing_Worn_Tires = true; }                   if else (!value) { IsUsing_Worn_Tires = false; }                   else {return;} }
void SetXX_But(bool value)                 { if (value) { IsUsing_XX_But = true; }                       if else (!value) { IsUsing_XX_But = false; }                       else {return;} }
void SetYEET(bool value)                   { if (value) { IsUsing_YEET = true; }                         if else (!value) { IsUsing_YEET = false; }                         else {return;} }
void SetYEET_Down(bool value)              { if (value) { IsUsing_YEET_Down = true; }                    if else (!value) { IsUsing_YEET_Down = false; }                    else {return;} }
void SetYEET_Puzzle(bool value)            { if (value) { IsUsing_YEET_Puzzle = true; }                  if else (!value) { IsUsing_YEET_Puzzle = false; }                  else {return;} }
void SetYEET_Random_Puzzle(bool value)     { if (value) { IsUsing_YEET_Random_Puzzle = true; }           if else (!value) { IsUsing_YEET_Random_Puzzle = false; }           else {return;} }
void SetYEET_Reverse(bool value)           { if (value) { IsUsing_YEET_Reverse = true; }                 if else (!value) { IsUsing_YEET_Reverse = false; }                 else {return;} }
void SetYeet_Max_Up(bool value)            { if (value) { IsUsing_Yeet_Max_Up = true; }                  if else (!value) { IsUsing_Yeet_Max_Up = false; }                  else {return;} }
void SetYEP_Tree_Puzzle(bool value)        { if (value) { IsUsing_YEP_Tree_Puzzle = true; }              if else (!value) { IsUsing_YEP_Tree_Puzzle = false; }              else {return;} }

void SetAllOfficialCompetitions(bool value)        { if (value) { IsUsing_AllOfficialCompetitions = true; }  if else (!value) { IsUsing_AllOfficialCompetitions = false; }  else {return;} }
void SetAllAlteredOfficialCompetitions(bool value) { if (value) { IsUsing__AllOfficialCompetitions = true; } if else (!value) { IsUsing__AllOfficialCompetitions = false; } else {return;} } 
void SetAllSnowDiscovery(bool value)               { if (value) { IsUsing_AllSnowDiscovery = true; }         if else (!value) { IsUsing_AllSnowDiscovery = false; }         else {return;} }
void SetAllRallyDiscovery(bool value)              { if (value) { IsUsing_AllRallyDiscovery = true; }        if else (!value) { IsUsing_AllRallyDiscovery = false; }        else {return;} }
void SetMapIsNotObtainable(bool value)             { if (value) { IsUsing_MapIsNotObtainable = true; }       if else (!value) { IsUsing_MapIsNotObtainable = false; }       else {return;} }
void SetOfficialNadeo(bool value)                  { if (value) { IsUsing_OfficialNadeo = true; }            if else (!value) { IsUsing_OfficialNadeo = false; }            else {return;} }
void SetAllTOTD(bool value)                        { if (value) { IsUsing_AllTOTD = true; }                  if else (!value) { IsUsing_AllTOTD = false; }                  else {return;} }
