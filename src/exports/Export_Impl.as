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
    byAlteration["[Rally]"] = IsUsing_Rally_;
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

string SetOnlyWinterMaps(bool value) {
    return "Sorry this currently isn't implemented";
}
string SetOnlySpringMaps(bool value) {
    return "Sorry this currently isn't implemented";
}
string SetOnlySummerMaps(bool value) {
    return "Sorry this currently isn't implemented";
}
string SetOnlyFallMaps(bool value) {
    return "Sorry this currently isn't implemented";
}

bool SetSpring2020Maps(bool value) { if (value) { IsUsing_Spring2020Maps = true; } else if (!value) { IsUsing_Spring2020Maps = false; } else {return IsUsing_Spring2020Maps;} }
bool SetSummer2020Maps(bool value) { if (value) { IsUsing_Summer2020Maps = true; } else if (!value) { IsUsing_Summer2020Maps = false; } else {return IsUsing_Summer2020Maps;} }
bool SetFall2020Maps(bool value)   { if (value) { IsUsing_Fall2020Maps = true; }   else if (!value) { IsUsing_Fall2020Maps = false; }   else {return IsUsing_Fall2020Maps;} }
bool SetWinter2021Maps(bool value) { if (value) { IsUsing_Winter2021Maps = true; } else if (!value) { IsUsing_Winter2021Maps = false; } else {return IsUsing_Winter2021Maps;} }
bool SetSpring2021Maps(bool value) { if (value) { IsUsing_Spring2021Maps = true; } else if (!value) { IsUsing_Spring2021Maps = false; } else {return IsUsing_Spring2021Maps;} }
bool SetSummer2021Maps(bool value) { if (value) { IsUsing_Summer2021Maps = true; } else if (!value) { IsUsing_Summer2021Maps = false; } else {return IsUsing_Summer2021Maps;} }
bool SetFall2021Maps(bool value)   { if (value) { IsUsing_Fall2021Maps = true; }   else if (!value) { IsUsing_Fall2021Maps = false; }   else {return IsUsing_Fall2021Maps;} }
bool SetWinter2022Maps(bool value) { if (value) { IsUsing_Winter2022Maps = true; } else if (!value) { IsUsing_Winter2022Maps = false; } else {return IsUsing_Winter2022Maps;} }
bool SetSpring2022Maps(bool value) { if (value) { IsUsing_Spring2022Maps = true; } else if (!value) { IsUsing_Spring2022Maps = false; } else {return IsUsing_Spring2022Maps;} }
bool SetSummer2022Maps(bool value) { if (value) { IsUsing_Summer2022Maps = true; } else if (!value) { IsUsing_Summer2022Maps = false; } else {return IsUsing_Summer2022Maps;} }
bool SetFall2022Maps(bool value)   { if (value) { IsUsing_Fall2022Maps = true; }   else if (!value) { IsUsing_Fall2022Maps = false; }   else {return IsUsing_Fall2022Maps;} }
bool SetWinter2023Maps(bool value) { if (value) { IsUsing_Winter2023Maps = true; } else if (!value) { IsUsing_Winter2023Maps = false; } else {return IsUsing_Winter2023Maps;} }
bool SetSpring2023Maps(bool value) { if (value) { IsUsing_Spring2023Maps = true; } else if (!value) { IsUsing_Spring2023Maps = false; } else {return IsUsing_Spring2023Maps;} }
bool SetSummer2023Maps(bool value) { if (value) { IsUsing_Summer2023Maps = true; } else if (!value) { IsUsing_Summer2023Maps = false; } else {return IsUsing_Summer2023Maps;} }
bool SetFall2023Maps(bool value)   { if (value) { IsUsing_Fall2023Maps = true; }   else if (!value) { IsUsing_Fall2023Maps = false; }   else {return IsUsing_Fall2023Maps;} }
bool SetWinter2024Maps(bool value) { if (value) { IsUsing_Winter2024Maps = true; } else if (!value) { IsUsing_Winter2024Maps = false; } else {return IsUsing_Winter2024Maps;} }
bool SetSpring2024Maps(bool value) { if (value) { IsUsing_Spring2024Maps = true; } else if (!value) { IsUsing_Spring2024Maps = false; } else {return IsUsing_Spring2024Maps;} }
bool SetSummer2024Maps(bool value) { if (value) { IsUsing_Summer2024Maps = true; } else if (!value) { IsUsing_Summer2024Maps = false; } else {return IsUsing_Summer2024Maps;} }
bool SetFall2024Maps(bool value)   { if (value) { IsUsing_Fall2024Maps = true; }   else if (!value) { IsUsing_Fall2024Maps = false; }   else {return IsUsing_Fall2024Maps;} }
bool SetWinter2025Maps(bool value) { if (value) { IsUsing_Winter2025Maps = true; } else if (!value) { IsUsing_Winter2025Maps = false; } else {return IsUsing_Winter2025Maps;} }
bool SetSpring2025Maps(bool value) { if (value) { IsUsing_Spring2025Maps = true; } else if (!value) { IsUsing_Spring2025Maps = false; } else {return IsUsing_Spring2025Maps;} }

bool SetSNOW(bool value)                   { if (value) { IsUsing_Snow_ = true; }                        else if (!value) { IsUsing_Snow_ = false; }                        else {return IsUsing_Snow_;} }
bool SetSNOW_Carswitch(bool value)         { if (value) { IsUsing_Snow_Carswitch = true; }               else if (!value) { IsUsing_Snow_Carswitch = false; }               else {return IsUsing_Snow_Carswitch;} }
bool SetSNOW_Checkpointless(bool value)    { if (value) { IsUsing_Snow_Checkpointless = true; }          else if (!value) { IsUsing_Snow_Checkpointless = false; }          else {return IsUsing_Snow_Checkpointless;} }
bool SetSNOW_Icy(bool value)               { if (value) { IsUsing_Snow_Icy = true; }                     else if (!value) { IsUsing_Snow_Icy = false; }                     else {return IsUsing_Snow_Icy;} }
bool SetSNOW_Underwater(bool value)        { if (value) { IsUsing_Snow_Underwater = true; }              else if (!value) { IsUsing_Snow_Underwater = false; }              else {return IsUsing_Snow_Underwater;} }
bool SetSNOW_Wood(bool value)              { if (value) { IsUsing_Snow_Wood = true; }                    else if (!value) { IsUsing_Snow_Wood = false; }                    else {return IsUsing_Snow_Wood;} }

bool SetSTADIUM(bool value)                { if (value) { IsUsing_Stadium_ = true; }                     else if (!value) { IsUsing_Stadium_ = false; }                     else {return IsUsing_Stadium_;} }

bool SetRALLY(bool value)                  { if (value) { IsUsing_Rally_ = true; }                       else if (!value) { IsUsing_Rally_ = false; }                       else {return IsUsing_Rally_;} }

bool Set1Back(bool value)                  { if (value) { IsUsing_1Back = true; }                        else if (!value) { IsUsing_1Back = false; }                        else {return IsUsing_1Back;} }
bool Set1Down(bool value)                  { if (value) { IsUsing_1Down = true; }                        else if (!value) { IsUsing_1Down = false; }                        else {return IsUsing_1Down;} }
bool Set1Left(bool value)                  { if (value) { IsUsing_1Left = true; }                        else if (!value) { IsUsing_1Left = false; }                        else {return IsUsing_1Left;} }
bool Set1Right(bool value)                 { if (value) { IsUsing_1Right = true; }                       else if (!value) { IsUsing_1Right = false; }                       else {return IsUsing_1Right;} }
bool Set1Up(bool value)                    { if (value) { IsUsing_1Up = true; }                          else if (!value) { IsUsing_1Up = false; }                          else {return IsUsing_1Up;} }
bool Set2D(bool value)                     { if (value) { IsUsing_2D = true; }                           else if (!value) { IsUsing_2D = false; }                           else {return IsUsing_2D;} }
bool Set2Up(bool value)                    { if (value) { IsUsing_2Up = true; }                          else if (!value) { IsUsing_2Up = false; }                          else {return IsUsing_2Up;} }
bool SetA08(bool value)                    { if (value) { IsUsing_A08 = true; }                          else if (!value) { IsUsing_A08 = false; }                          else {return IsUsing_A08;} }
bool SetAntibooster(bool value)            { if (value) { IsUsing_Antibooster = true; }                  else if (!value) { IsUsing_Antibooster = false; }                  else {return IsUsing_Antibooster;} }
bool SetBoss(bool value)                   { if (value) { IsUsing_BOSS = true; }                         else if (!value) { IsUsing_BOSS = false; }                         else {return IsUsing_BOSS;} }
bool SetBackwards(bool value)              { if (value) { IsUsing_Backwards = true; }                    else if (!value) { IsUsing_Backwards = false; }                    else {return IsUsing_Backwards;} }
bool SetBetter_Mixed(bool value)           { if (value) { IsUsing_Better_Mixed = true; }                 else if (!value) { IsUsing_Better_Mixed = false; }                 else {return IsUsing_Better_Mixed;} }
bool SetBetter_Reverse(bool value)         { if (value) { IsUsing_Better_Reverse = true; }               else if (!value) { IsUsing_Better_Reverse = false; }               else {return IsUsing_Better_Reverse;} }
bool SetBlind(bool value)                  { if (value) { IsUsing_Blind = true; }                        else if (!value) { IsUsing_Blind = false; }                        else {return IsUsing_Blind;} }
bool SetBobsleigh(bool value)              { if (value) { IsUsing_Bobsleigh = true; }                    else if (!value) { IsUsing_Bobsleigh = false; }                    else {return IsUsing_Bobsleigh;} }
bool SetThereAndBack(bool value)           { if (value) { IsUsing_Boomerang_There_and_Back = true; }     else if (!value) { IsUsing_Boomerang_There_and_Back = false; }     else {return IsUsing_Boomerang_There_and_Back;} }
bool SetBoosterless(bool value)            { if (value) { IsUsing_Boosterless = true; }                  else if (!value) { IsUsing_Boosterless = false; }                  else {return IsUsing_Boosterless;} }
bool SetBroken(bool value)                 { if (value) { IsUsing_Broken = true; }                       else if (!value) { IsUsing_Broken = false; }                       else {return IsUsing_Broken;} }
bool SetBumper(bool value)                 { if (value) { IsUsing_Bumper = true; }                       else if (!value) { IsUsing_Bumper = false; }                       else {return IsUsing_Bumper;} }
bool SetCP1Kept(bool value)                { if (value) { IsUsing_CP1_Kept = true; }                     else if (!value) { IsUsing_CP1_Kept = false; }                     else {return IsUsing_CP1_Kept;} }
bool SetCP1IsEnd(bool value)               { if (value) { IsUsing_CP1_is_End = true; }                   else if (!value) { IsUsing_CP1_is_End = false; }                   else {return IsUsing_CP1_is_End;} }
bool SetCPLink(bool value)                 { if (value) { IsUsing_CPLink = true; }                       else if (!value) { IsUsing_CPLink = false; }                       else {return IsUsing_CPLink;} }
bool SetCPBoost(bool value)                { if (value) { IsUsing_CP_Boost = true; }                     else if (!value) { IsUsing_CP_Boost = false; }                     else {return IsUsing_CP_Boost;} }
bool SetCPfull(bool value)                 { if (value) { IsUsing_CPfull = true; }                       else if (!value) { IsUsing_CPfull = false; }                       else {return IsUsing_CPfull;} }
bool SetCheckpoin_t(bool value)            { if (value) { IsUsing_Checkpoin_t = true; }                  else if (!value) { IsUsing_Checkpoin_t = false; }                  else {return IsUsing_Checkpoin_t;} }
bool SetCheckpointless(bool value)         { if (value) { IsUsing_Checkpointless = true; }               else if (!value) { IsUsing_Checkpointless = false; }               else {return IsUsing_Checkpointless;} }
bool SetCheckpointless_Reverse(bool value) { if (value) { IsUsing_Checkpointless_Reverse = true; }       else if (!value) { IsUsing_Checkpointless_Reverse = false; }       else {return IsUsing_Checkpointless_Reverse;} }
bool SetCleaned(bool value)                { if (value) { IsUsing_Cleaned = true; }                      else if (!value) { IsUsing_Cleaned = false; }                      else {return IsUsing_Cleaned;} }
bool SetColorsCombined(bool value)         { if (value) { IsUsing_Colors_Combined = true; }              else if (!value) { IsUsing_Colors_Combined = false; }              else {return IsUsing_Colors_Combined;} }
bool SetCruise(bool value)                 { if (value) { IsUsing_Cruise = true; }                       else if (!value) { IsUsing_Cruise = false; }                       else {return IsUsing_Cruise;} }
bool SetDirt(bool value)                   { if (value) { IsUsing_Dirt = true; }                         else if (!value) { IsUsing_Dirt = false; }                         else {return IsUsing_Dirt;} }
bool SetEarthquake(bool value)             { if (value) { IsUsing_Earthquake = true; }                   else if (!value) { IsUsing_Earthquake = false; }                   else {return IsUsing_Earthquake;} }
bool SetEffectless(bool value)             { if (value) { IsUsing_Effectless = true; }                   else if (!value) { IsUsing_Effectless = false; }                   else {return IsUsing_Effectless;} }
bool SetEgocentrism(bool value)            { if (value) { IsUsing_Egocentrism = true; }                  else if (!value) { IsUsing_Egocentrism = false; }                  else {return IsUsing_Egocentrism;} }
bool SetFast(bool value)                   { if (value) { IsUsing_Fast = true; }                         else if (!value) { IsUsing_Fast = false; }                         else {return IsUsing_Fast;} }
bool SetFastMagnet(bool value)             { if (value) { IsUsing_Fast_Magnet = true; }                  else if (!value) { IsUsing_Fast_Magnet = false; }                  else {return IsUsing_Fast_Magnet;} }
bool SetFlipped(bool value)                { if (value) { IsUsing_Flipped = true; }                      else if (!value) { IsUsing_Flipped = false; }                      else {return IsUsing_Flipped;} }
bool SetFlooded(bool value)                { if (value) { IsUsing_Flooded = true; }                      else if (!value) { IsUsing_Flooded = false; }                      else {return IsUsing_Flooded;} }
bool SetFloorFin(bool value)               { if (value) { IsUsing_Floor_Fin = true; }                    else if (!value) { IsUsing_Floor_Fin = false; }                    else {return IsUsing_Floor_Fin;} }
bool SetFragile(bool value)                { if (value) { IsUsing_Fragile = true; }                      else if (!value) { IsUsing_Fragile = false; }                      else {return IsUsing_Fragile;} }
bool SetFreewheel(bool value)              { if (value) { IsUsing_Freewheel = true; }                    else if (!value) { IsUsing_Freewheel = false; }                    else {return IsUsing_Freewheel;} }
bool SetGlider(bool value)                 { if (value) { IsUsing_Glider = true; }                       else if (!value) { IsUsing_Glider = false; }                       else {return IsUsing_Glider;} }
bool SetGotRotated_CPsRotated(bool value)  { if (value) { IsUsing_Got_Rotated_CPs_Rotated_90__ = true; } else if (!value) { IsUsing_Got_Rotated_CPs_Rotated_90__ = false; } else {return IsUsing_Got_Rotated_CPs_Rotated_90__;} }
bool SetGrass(bool value)                  { if (value) { IsUsing_Grass = true; }                        else if (!value) { IsUsing_Grass = false; }                        else {return IsUsing_Grass;} }
bool SetHard(bool value)                   { if (value) { IsUsing_Hard = true; }                         else if (!value) { IsUsing_Hard = false; }                         else {return IsUsing_Hard;} }
bool SetHoles(bool value)                  { if (value) { IsUsing_Holes = true; }                        else if (!value) { IsUsing_Holes = false; }                        else {return IsUsing_Holes;} }
bool SetIce(bool value)                    { if (value) { IsUsing_Ice = true; }                          else if (!value) { IsUsing_Ice = false; }                          else {return IsUsing_Ice;} }
bool SetIce_Reverse(bool value)            { if (value) { IsUsing_Ice_Reverse = true; }                  else if (!value) { IsUsing_Ice_Reverse = false; }                  else {return IsUsing_Ice_Reverse;} }
bool SetIce_Reverse_Reactor(bool value)    { if (value) { IsUsing_Ice_Reverse_Reactor = true; }          else if (!value) { IsUsing_Ice_Reverse_Reactor = false; }          else {return IsUsing_Ice_Reverse_Reactor;} }
bool SetIce_Short(bool value)              { if (value) { IsUsing_Ice_Short = true; }                    else if (!value) { IsUsing_Ice_Short = false; }                    else {return IsUsing_Ice_Short;} }
bool SetIcy_Reactor(bool value)            { if (value) { IsUsing_Icy_Reactor = true; }                  else if (!value) { IsUsing_Icy_Reactor = false; }                  else {return IsUsing_Icy_Reactor;} }
bool SetInclined(bool value)               { if (value) { IsUsing_Inclined = true; }                     else if (!value) { IsUsing_Inclined = false; }                     else {return IsUsing_Inclined;} }
bool SetLunatic(bool value)                { if (value) { IsUsing_Lunatic = true; }                      else if (!value) { IsUsing_Lunatic = false; }                      else {return IsUsing_Lunatic;} }
bool SetMagnet(bool value)                 { if (value) { IsUsing_Magnet = true; }                       else if (!value) { IsUsing_Magnet = false; }                       else {return IsUsing_Magnet;} }
bool SetMagnet_Reverse(bool value)         { if (value) { IsUsing_Magnet_Reverse = true; }               else if (!value) { IsUsing_Magnet_Reverse = false; }               else {return IsUsing_Magnet_Reverse;} }
bool SetManslaughter(bool value)           { if (value) { IsUsing_Manslaughter = true; }                 else if (!value) { IsUsing_Manslaughter = false; }                 else {return IsUsing_Manslaughter;} }
bool SetMiniRPG(bool value)                { if (value) { IsUsing_Mini_RPG = true; }                     else if (!value) { IsUsing_Mini_RPG = false; }                     else {return IsUsing_Mini_RPG;} }
bool SetMirrored(bool value)               { if (value) { IsUsing_Mirrored = true; }                     else if (!value) { IsUsing_Mirrored = false; }                     else {return IsUsing_Mirrored;} }
bool SetMixed(bool value)                  { if (value) { IsUsing_Mixed = true; }                        else if (!value) { IsUsing_Mixed = false; }                        else {return IsUsing_Mixed;} }
bool SetNgolo_Cacti(bool value)            { if (value) { IsUsing_Ngolo_Cacti = true; }                  else if (!value) { IsUsing_Ngolo_Cacti = false; }                  else {return IsUsing_Ngolo_Cacti;} }
bool SetNoSteer(bool value)                { if (value) { IsUsing_No_Steer = true; }                     else if (!value) { IsUsing_No_Steer = false; }                     else {return IsUsing_No_Steer;} }
bool SetNoBrakes(bool value)               { if (value) { IsUsing_No_brakes = true; }                    else if (!value) { IsUsing_No_brakes = false; }                    else {return IsUsing_No_brakes;} }
bool SetNoCut(bool value)                  { if (value) { IsUsing_No_cut = true; }                       else if (!value) { IsUsing_No_cut = false; }                       else {return IsUsing_No_cut;} }
bool SetNoGrip(bool value)                 { if (value) { IsUsing_No_grip = true; }                      else if (!value) { IsUsing_No_grip = false; }                      else {return IsUsing_No_grip;} }
bool SetNoGear5(bool value)                { if (value) { IsUsing_No_gear_5 = true; }                    else if (!value) { IsUsing_No_gear_5 = false; }                    else {return IsUsing_No_gear_5;} }
bool SetPenalty(bool value)                { if (value) { IsUsing_Penalty = true; }                      else if (!value) { IsUsing_Penalty = false; }                      else {return IsUsing_Penalty;} }
bool SetPipe(bool value)                   { if (value) { IsUsing_Pipe = true; }                         else if (!value) { IsUsing_Pipe = false; }                         else {return IsUsing_Pipe;} }
bool SetPlastic(bool value)                { if (value) { IsUsing_Plastic = true; }                      else if (!value) { IsUsing_Plastic = false; }                      else {return IsUsing_Plastic;} }
bool SetPlastic_Reverse(bool value)        { if (value) { IsUsing_Plastic_Reverse = true; }              else if (!value) { IsUsing_Plastic_Reverse = false; }              else {return IsUsing_Plastic_Reverse;} }
bool SetPlatform(bool value)               { if (value) { IsUsing_Platform = true; }                     else if (!value) { IsUsing_Platform = false; }                     else {return IsUsing_Platform;} }
bool SetPodium(bool value)                 { if (value) { IsUsing_Podium = true; }                       else if (!value) { IsUsing_Podium = false; }                       else {return IsUsing_Podium;} }
bool SetPoolHunters(bool value)            { if (value) { IsUsing_Pool_Hunters = true; }                 else if (!value) { IsUsing_Pool_Hunters = false; }                 else {return IsUsing_Pool_Hunters;} }
bool SetPuzzle(bool value)                 { if (value) { IsUsing_Puzzle = true; }                       else if (!value) { IsUsing_Puzzle = false; }                       else {return IsUsing_Puzzle;} }
bool SetRandom(bool value)                 { if (value) { IsUsing_Random = true; }                       else if (!value) { IsUsing_Random = false; }                       else {return IsUsing_Random;} }
bool SetRandomDankness(bool value)         { if (value) { IsUsing_Random_Dankness = true; }              else if (!value) { IsUsing_Random_Dankness = false; }              else {return IsUsing_Random_Dankness;} }
bool SetRandomEffects(bool value)          { if (value) { IsUsing_Random_Effects = true; }               else if (!value) { IsUsing_Random_Effects = false; }               else {return IsUsing_Random_Effects;} }
bool SetReactor(bool value)                { if (value) { IsUsing_Reactor = true; }                      else if (!value) { IsUsing_Reactor = false; }                      else {return IsUsing_Reactor;} }
bool SetReactorDown(bool value)            { if (value) { IsUsing_Reactor_Down = true; }                 else if (!value) { IsUsing_Reactor_Down = false; }                 else {return IsUsing_Reactor_Down;} }
bool SetReverse(bool value)                { if (value) { IsUsing_Reverse = true; }                      else if (!value) { IsUsing_Reverse = false; }                      else {return IsUsing_Reverse;} }
bool SetRingCP(bool value)                 { if (value) { IsUsing_Ring_CP = true; }                      else if (!value) { IsUsing_Ring_CP = false; }                      else {return IsUsing_Ring_CP;} }
bool SetRoad(bool value)                   { if (value) { IsUsing_Road = true; }                         else if (!value) { IsUsing_Road = false; }                         else {return IsUsing_Road;} }
bool SetRoad_Dirt(bool value)              { if (value) { IsUsing_Road_Dirt = true; }                    else if (!value) { IsUsing_Road_Dirt = false; }                    else {return IsUsing_Road_Dirt;} }
bool SetRoofing(bool value)                { if (value) { IsUsing_Roofing = true; }                      else if (!value) { IsUsing_Roofing = false; }                      else {return IsUsing_Roofing;} }
bool SetSausage(bool value)                { if (value) { IsUsing_Sausage = true; }                      else if (!value) { IsUsing_Sausage = false; }                      else {return IsUsing_Sausage;} }
bool SetScubaDiving(bool value)            { if (value) { IsUsing_Scuba_Diving = true; }                 else if (!value) { IsUsing_Scuba_Diving = false; }                 else {return IsUsing_Scuba_Diving;} }
bool SetSectionsjoined(bool value)         { if (value) { IsUsing_Sections_joined = true; }              else if (!value) { IsUsing_Sections_joined = false; }              else {return IsUsing_Sections_joined;} }
bool SetSelectDEL(bool value)              { if (value) { IsUsing_Select_DEL = true; }                   else if (!value) { IsUsing_Select_DEL = false; }                   else {return IsUsing_Select_DEL;} }
bool SetShort(bool value)                  { if (value) { IsUsing_Short = true; }                        else if (!value) { IsUsing_Short = false; }                        else {return IsUsing_Short;} }
bool SetSkyIsTheFinish(bool value)         { if (value) { IsUsing_Sky_is_the_Finish = true; }            else if (!value) { IsUsing_Sky_is_the_Finish = false; }            else {return IsUsing_Sky_is_the_Finish;} }
bool SetSkyIsTheFinishReverse(bool value)  { if (value) { IsUsing_Sky_is_the_Finish_Reverse = true; }    else if (!value) { IsUsing_Sky_is_the_Finish_Reverse = false; }    else {return IsUsing_Sky_is_the_Finish_Reverse;} }
bool SetSlowmo(bool value)                 { if (value) { IsUsing_Slowmo = true; }                       else if (!value) { IsUsing_Slowmo = false; }                       else {return IsUsing_Slowmo;} }
bool SetSpeedlimit(bool value)             { if (value) { IsUsing_Speedlimit = true; }                   else if (!value) { IsUsing_Speedlimit = false; }                   else {return IsUsing_Speedlimit;} }
bool SetStaircase(bool value)              { if (value) { IsUsing_Staircase = true; }                    else if (!value) { IsUsing_Staircase = false; }                    else {return IsUsing_Staircase;} }
bool SetStart1Down(bool value)             { if (value) { IsUsing_Start_1_Down = true; }                 else if (!value) { IsUsing_Start_1_Down = false; }                 else {return IsUsing_Start_1_Down;} }
bool SetStraightToTheFinish(bool value)    { if (value) { IsUsing_Straight_to_the_Finish = true; }       else if (!value) { IsUsing_Straight_to_the_Finish = false; }       else {return IsUsing_Straight_to_the_Finish;} }
bool SetSupersized(bool value)             { if (value) { IsUsing_Supersized = true; }                   else if (!value) { IsUsing_Supersized = false; }                   else {return IsUsing_Supersized;} }
bool SetSurfaceless(bool value)            { if (value) { IsUsing_Surfaceless = true; }                  else if (!value) { IsUsing_Surfaceless = false; }                  else {return IsUsing_Surfaceless;} }
bool Set_sw2u1l_cpu_f2d1r(bool value)      { if (value) { IsUsing_sw2u1l_cpu_f2d1r = true; }             else if (!value) { IsUsing_sw2u1l_cpu_f2d1r = false; }             else {return IsUsing_sw2u1l_cpu_f2d1r;} }
bool SetSymmetrical(bool value)            { if (value) { IsUsing_Symmetrical = true; }                  else if (!value) { IsUsing_Symmetrical = false; }                  else {return IsUsing_Symmetrical;} }
bool SetTMGL_Easy(bool value)              { if (value) { IsUsing_TMGL_Easy = true; }                    else if (!value) { IsUsing_TMGL_Easy = false; }                    else {return IsUsing_TMGL_Easy;} }
bool SetTilted(bool value)                 { if (value) { IsUsing_Tilted = true; }                       else if (!value) { IsUsing_Tilted = false; }                       else {return IsUsing_Tilted;} }
bool SetUnderwater(bool value)             { if (value) { IsUsing_Underwater = true; }                   else if (!value) { IsUsing_Underwater = false; }                   else {return IsUsing_Underwater;} }
bool SetUnderwater_Reverse(bool value)     { if (value) { IsUsing_Underwater_Reverse = true; }           else if (!value) { IsUsing_Underwater_Reverse = false; }           else {return IsUsing_Underwater_Reverse;} }
bool SetWalmartMini(bool value)            { if (value) { IsUsing_Walmart_Mini = true; }                 else if (!value) { IsUsing_Walmart_Mini = false; }                 else {return IsUsing_Walmart_Mini;} }
bool SetWetIcyWood(bool value)             { if (value) { IsUsing_Wet_Icy_Wood = true; }                 else if (!value) { IsUsing_Wet_Icy_Wood = false; }                 else {return IsUsing_Wet_Icy_Wood;} }
bool SetWetWheels(bool value)              { if (value) { IsUsing_Wet_Wheels = true; }                   else if (!value) { IsUsing_Wet_Wheels = false; }                   else {return IsUsing_Wet_Wheels;} }
bool SetWetWood(bool value)                { if (value) { IsUsing_Wet_Wood = true; }                     else if (!value) { IsUsing_Wet_Wood = false; }                     else {return IsUsing_Wet_Wood;} }
bool SetWood(bool value)                   { if (value) { IsUsing_Wood = true; }                         else if (!value) { IsUsing_Wood = false; }                         else {return IsUsing_Wood;} }
bool SetWornTires(bool value)              { if (value) { IsUsing_Worn_Tires = true; }                   else if (!value) { IsUsing_Worn_Tires = false; }                   else {return IsUsing_Worn_Tires;} }
bool SetXX_But(bool value)                 { if (value) { IsUsing_XX_But = true; }                       else if (!value) { IsUsing_XX_But = false; }                       else {return IsUsing_XX_But;} }
bool SetYEET(bool value)                   { if (value) { IsUsing_YEET = true; }                         else if (!value) { IsUsing_YEET = false; }                         else {return IsUsing_YEET;} }
bool SetYEET_Down(bool value)              { if (value) { IsUsing_YEET_Down = true; }                    else if (!value) { IsUsing_YEET_Down = false; }                    else {return IsUsing_YEET_Down;} }
bool SetYEET_Puzzle(bool value)            { if (value) { IsUsing_YEET_Puzzle = true; }                  else if (!value) { IsUsing_YEET_Puzzle = false; }                  else {return IsUsing_YEET_Puzzle;} }
bool SetYEET_Random_Puzzle(bool value)     { if (value) { IsUsing_YEET_Random_Puzzle = true; }           else if (!value) { IsUsing_YEET_Random_Puzzle = false; }           else {return IsUsing_YEET_Random_Puzzle;} }
bool SetYEET_Reverse(bool value)           { if (value) { IsUsing_YEET_Reverse = true; }                 else if (!value) { IsUsing_YEET_Reverse = false; }                 else {return IsUsing_YEET_Reverse;} }
bool SetYeet_Max_Up(bool value)            { if (value) { IsUsing_Yeet_Max_Up = true; }                  else if (!value) { IsUsing_Yeet_Max_Up = false; }                  else {return IsUsing_Yeet_Max_Up;} }
bool SetYEP_Tree_Puzzle(bool value)        { if (value) { IsUsing_YEP_Tree_Puzzle = true; }              else if (!value) { IsUsing_YEP_Tree_Puzzle = false; }              else {return IsUsing_YEP_Tree_Puzzle;} }

bool SetAllOfficialCompetitions(bool value)        { if (value) { IsUsing_AllOfficialCompetitions = true; }  else if (!value) { IsUsing_AllOfficialCompetitions = false; }  else {return IsUsing_AllOfficialCompetitions;} }
bool SetAllAlteredOfficialCompetitions(bool value) { if (value) { IsUsing__AllOfficialCompetitions = true; } else if (!value) { IsUsing__AllOfficialCompetitions = false; } else {return IsUsing__AllOfficialCompetitions;} } 
bool SetAllSnowDiscovery(bool value)               { if (value) { IsUsing_AllSnowDiscovery = true; }         else if (!value) { IsUsing_AllSnowDiscovery = false; }         else {return IsUsing_AllSnowDiscovery;} }
bool SetAllRallyDiscovery(bool value)              { if (value) { IsUsing_AllRallyDiscovery = true; }        else if (!value) { IsUsing_AllRallyDiscovery = false; }        else {return IsUsing_AllRallyDiscovery;} }
bool SetMapIsNotObtainable(bool value)             { if (value) { IsUsing_MapIsNotObtainable = true; }       else if (!value) { IsUsing_MapIsNotObtainable = false; }       else {return IsUsing_MapIsNotObtainable;} }
bool SetOfficialNadeo(bool value)                  { if (value) { IsUsing_OfficialNadeo = true; }            else if (!value) { IsUsing_OfficialNadeo = false; }            else {return IsUsing_OfficialNadeo;} }
bool SetAllTOTD(bool value)                        { if (value) { IsUsing_AllTOTD = true; }                  else if (!value) { IsUsing_AllTOTD = false; }                  else {return IsUsing_AllTOTD;} }
