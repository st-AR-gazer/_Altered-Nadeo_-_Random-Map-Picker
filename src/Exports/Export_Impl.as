string GetARandomAltMapUid() {
    string uid = GetRandomUID();
    return uid;
}


Json::Value GetUserSettings() {
    Json::Value settings;

    // Altered Surface
    settings["Alteration"]["Surface"]["Dirt"] = IsUsing_Dirt;
    settings["Alteration"]["Surface"]["Fast Magnet"] = IsUsing_Fast_Magnet;
    settings["Alteration"]["Surface"]["Flooded"] = IsUsing_Flooded;
    settings["Alteration"]["Surface"]["Grass"] = IsUsing_Grass;
    settings["Alteration"]["Surface"]["Ice"] = IsUsing_Ice;
    settings["Alteration"]["Surface"]["Magnet"] = IsUsing_Magnet;
    settings["Alteration"]["Surface"]["Mixed"] = IsUsing_Mixed;
    settings["Alteration"]["Surface"]["Better Mixed"] = IsUsing_Better_Mixed;
    settings["Alteration"]["Surface"]["Penalty"] = IsUsing_Penalty;
    settings["Alteration"]["Surface"]["Plastic"] = IsUsing_Plastic;
    settings["Alteration"]["Surface"]["Road"] = IsUsing_Road;
    settings["Alteration"]["Surface"]["Road Dirt"] = IsUsing_Road_Dirt;
    settings["Alteration"]["Surface"]["Wood"] = IsUsing_Wood;
    settings["Alteration"]["Surface"]["Bobsleigh"] = IsUsing_Bobsleigh;
    settings["Alteration"]["Surface"]["Pipe"] = IsUsing_Pipe;
    settings["Alteration"]["Surface"]["Platform"] = IsUsing_Platform;
    settings["Alteration"]["Surface"]["Sausage"] = IsUsing_Sausage;
    settings["Alteration"]["Surface"]["Surfaceless"] = IsUsing_Surfaceless;
    settings["Alteration"]["Surface"]["Underwater"] = IsUsing_Underwater;

    // Altered Effects
    settings["Alteration"]["Effects"]["Cruise"] = IsUsing_Cruise;
    settings["Alteration"]["Effects"]["Fragile"] = IsUsing_Fragile;
    settings["Alteration"]["Effects"]["Full Fragile"] = IsUsing_Full_Fragile;
    settings["Alteration"]["Effects"]["Freewheel"] = IsUsing_Freewheel;
    settings["Alteration"]["Effects"]["Glider"] = IsUsing_Glider;
    settings["Alteration"]["Effects"]["No Brake"] = IsUsing_No_Brakes;
    settings["Alteration"]["Effects"]["No Effect"] = IsUsing_No_Effects;
    settings["Alteration"]["Effects"]["No Grip"] = IsUsing_No_Grip;
    settings["Alteration"]["Effects"]["No Steering"] = IsUsing_No_Steer;
    settings["Alteration"]["Effects"]["Random Dankness"] = IsUsing_Random_Dankness;
    settings["Alteration"]["Effects"]["Random Effects"] = IsUsing_Random_Effects;
    settings["Alteration"]["Effects"]["Reactor (Up)"] = IsUsing_Reactor;
    settings["Alteration"]["Effects"]["Reactor Down"] = IsUsing_Reactor_Down;
    settings["Alteration"]["Effects"]["Slowmo"] = IsUsing_Slowmo;
    settings["Alteration"]["Effects"]["Wet Wheels"] = IsUsing_Wet_Wheels;
    settings["Alteration"]["Effects"]["Worn Tires"] = IsUsing_Worn_Tires;
    
    // Altered Finish Location
    settings["Alteration"]["Finish Location"]["1 Down"] = IsUsing_1Down;
    settings["Alteration"]["Finish Location"]["1 Back / Forward"] = IsUsing_1Back;
    settings["Alteration"]["Finish Location"]["1 Left"] = IsUsing_1Left;
    settings["Alteration"]["Finish Location"]["1 Right"] = IsUsing_1Right;
    settings["Alteration"]["Finish Location"]["1 Up"] = IsUsing_1Up;
    settings["Alteration"]["Finish Location"]["2 Up"] = IsUsing_2Up;
    settings["Alteration"]["Finish Location"]["Better Reverse / Reverse Magna"] = IsUsing_Better_Reverse;
    settings["Alteration"]["Finish Location"]["CP1 is End"] = IsUsing_CP1_is_End;
    settings["Alteration"]["Finish Location"]["Floor Fin"] = IsUsing_Floor_Fin;
    settings["Alteration"]["Finish Location"]["Mansloughter"] = IsUsing_Manslaughter;
    settings["Alteration"]["Finish Location"]["No Gear 5"] = IsUsing_No_Gear_5;
    settings["Alteration"]["Finish Location"]["Podium"] = IsUsing_Podium;
    settings["Alteration"]["Finish Location"]["Puzzle"] = IsUsing_Puzzle;
    settings["Alteration"]["Finish Location"]["Reverse"] = IsUsing_Reverse;
    settings["Alteration"]["Finish Location"]["Roofing"] = IsUsing_Roofing;
    settings["Alteration"]["Finish Location"]["Short"] = IsUsing_Short;
    settings["Alteration"]["Finish Location"]["Sky is the Finish"] = IsUsing_Sky_is_the_Finish;
    settings["Alteration"]["Finish Location"]["There and Back / Boomerang"] = IsUsing_There_and_Back_Boomerang;
    settings["Alteration"]["Finish Location"]["YEP Tree Puzzle"] = IsUsing_YEP_Tree_Puzzle;
    settings["Alteration"]["Finish Location"]["Inclined"] = IsUsing_Inclined;

    // Altered Environment (Envimix)
    settings["Alteration"]["Environment"]["[Stadium]"] = IsUsing_Stadium_;
    settings["Alteration"]["Environment"]["[Stadium] Wet Wood"] = IsUsing_Stadium_Wet_Wood;
    settings["Alteration"]["Environment"]["[Snow]"] = IsUsing_Snow_;
    settings["Alteration"]["Environment"]["[Snow] Carswitch"] = IsUsing_Snow_Carswitch;
    settings["Alteration"]["Environment"]["[Snow] Checkpointless"] = IsUsing_Snow_Checkpointless;
    settings["Alteration"]["Environment"]["[Snow] Ice"] = IsUsing_Snow_Icy;
    settings["Alteration"]["Environment"]["[Snow] Underwater"] = IsUsing_Snow_Underwater;
    settings["Alteration"]["Environment"]["[Snow] Wet Plastic"] = IsUsing_Snow_Wet_Plastic;
    settings["Alteration"]["Environment"]["[Snow] Wood"] = IsUsing_Snow_Wood;
    settings["Alteration"]["Environment"]["[Rally]"] = IsUsing_Rally_;
    settings["Alteration"]["Environment"]["[Rally] Carswitch"] = IsUsing_Rally_Carswitch;
    settings["Alteration"]["Environment"]["[Rally] CP1 is End"] = IsUsing_Rally_CP1_is_End;
    settings["Alteration"]["Environment"]["[Rally] Underwater"] = IsUsing_Rally_Underwater;
    settings["Alteration"]["Environment"]["[Rally] Ice"] = IsUsing_Rally_Icy;

    // Multi Alterations
    settings["Alteration"]["Multi"]["100% Wet Icy Wood"] = IsUsing_100WetIcyWood;
    settings["Alteration"]["Multi"]["Checkpointless Reverse"] = IsUsing_Checkpointless_Reverse;
    settings["Alteration"]["Multi"]["Ice Reactor"] = IsUsing_Icy_Reactor;
    settings["Alteration"]["Multi"]["Ice Reverse"] = IsUsing_Ice_Reverse;
    settings["Alteration"]["Multi"]["Ice Reverse Reactor"] = IsUsing_Ice_Reverse_Reactor;
    settings["Alteration"]["Multi"]["Ice Short"] = IsUsing_Ice_Short;
    settings["Alteration"]["Multi"]["Magnet Reverse"] = IsUsing_Magnet_Reverse;
    settings["Alteration"]["Multi"]["Plastic Reverse"] = IsUsing_Plastic_Reverse;
    settings["Alteration"]["Multi"]["Sky is the Finish Reverse"] = IsUsing_Sky_is_the_Finish_Reverse;
    settings["Alteration"]["Multi"]["Start Water 2 Up 1 Left Checkpoints Unlinked Finish 2 Down 1 Right"] = IsUsing_sw2u1l_cpu_f2d1r;
    settings["Alteration"]["Multi"]["Underwater Reverse"] = IsUsing_Underwater_Reverse;
    settings["Alteration"]["Multi"]["Wet Plastic"] = IsUsing_Wet_Plastic;
    settings["Alteration"]["Multi"]["Wet Wood"] = IsUsing_Wet_Wood;
    settings["Alteration"]["Multi"]["Wet Icy Wood"] = IsUsing_Wet_Icy_Wood;
    settings["Alteration"]["Multi"]["YEET Max Up"] = IsUsing_Yeet_Max_Up;
    settings["Alteration"]["Multi"]["YEET Puzzle"] = IsUsing_YEET_Puzzle;
    settings["Alteration"]["Multi"]["YEET Random Puzzle"] = IsUsing_YEET_Random_Puzzle;
    settings["Alteration"]["Multi"]["YEET Reverse"] = IsUsing_YEET_Reverse;

    // Other Alterations
    settings["Alteration"]["Other"]["XX-But"] = IsUsing_XX_But;
    settings["Alteration"]["Other"]["Flat / 2D"] = IsUsing_Flat_2D;
    settings["Alteration"]["Other"]["a08"] = IsUsing_A08;
    settings["Alteration"]["Other"]["Altered Camera"] = IsUsing_Altered_Camera;
    settings["Alteration"]["Other"]["Antiboosters"] = IsUsing_Antibooster;
    settings["Alteration"]["Other"]["Backwards"] = IsUsing_Backwards;
    settings["Alteration"]["Other"]["Blind (Altered Camera)"] = IsUsing_Blind;
    settings["Alteration"]["Other"]["Boosterless"] = IsUsing_Boosterless;
    settings["Alteration"]["Other"]["BOSS / Overlayed"] = IsUsing_BOSS;
    settings["Alteration"]["Other"]["Broken"] = IsUsing_Broken;
    settings["Alteration"]["Other"]["Bumper"] = IsUsing_Bumper;
    settings["Alteration"]["Other"]["Checkpoin't"] = IsUsing_Checkpoin_t;
    settings["Alteration"]["Other"]["Cleaned"] = IsUsing_Cleaned;
    settings["Alteration"]["Other"]["Colour Combined"] = IsUsing_Colours_Combined;
    settings["Alteration"]["Other"]["CP/Boost Swap"] = IsUsing_CP_Boost;
    settings["Alteration"]["Other"]["CP1 Kept"] = IsUsing_CP1_Kept;
    settings["Alteration"]["Other"]["CPfull"] = IsUsing_CPfull;
    settings["Alteration"]["Other"]["CPLess"] = IsUsing_Checkpointless;
    settings["Alteration"]["Other"]["CPLink"] = IsUsing_CPLink;
    settings["Alteration"]["Other"]["Got Rotated / CPs Rotated 90°"] = IsUsing_Got_Rotated_CPs_Rotated_90__;
    settings["Alteration"]["Other"]["Earthquake"] = IsUsing_Earthquake;
    settings["Alteration"]["Other"]["Egocentrism (Altered Camera)"] = IsUsing_Egocentrism;
    settings["Alteration"]["Other"]["Fast"] = IsUsing_Fast;
    settings["Alteration"]["Other"]["Flipped"] = IsUsing_Flipped;
    settings["Alteration"]["Other"]["Holes"] = IsUsing_Holes;
    settings["Alteration"]["Other"]["Lunatic"] = IsUsing_Lunatic;
    settings["Alteration"]["Other"]["Mini RPG"] = IsUsing_Mini_RPG;
    settings["Alteration"]["Other"]["Mirrored"] = IsUsing_Mirrored;
    settings["Alteration"]["Other"]["Ngolo / Cacti"] = IsUsing_Ngolo_Cacti;
    settings["Alteration"]["Other"]["No Cut"] = IsUsing_No_Cut;
    settings["Alteration"]["Other"]["Pool Hunters"] = IsUsing_Pool_Hunters;
    settings["Alteration"]["Other"]["Random"] = IsUsing_Random;
    settings["Alteration"]["Other"]["Ring CP"] = IsUsing_Ring_CP;
    settings["Alteration"]["Other"]["Scuba Diving"] = IsUsing_Scuba_Diving;
    settings["Alteration"]["Other"]["Sections Joined"] = IsUsing_Sections_joined;
    settings["Alteration"]["Other"]["Select DEL"] = IsUsing_Select_DEL;
    settings["Alteration"]["Other"]["Speedlimit"] = IsUsing_Speedlimit;
    settings["Alteration"]["Other"]["Start 1 Down"] = IsUsing_Start_1_Down;
    settings["Alteration"]["Other"]["Staircase"] = IsUsing_Staircase;
    settings["Alteration"]["Other"]["Supersized"] = IsUsing_Supersized;
    settings["Alteration"]["Other"]["Straight to the Finish"] = IsUsing_Straight_to_the_Finish;
    settings["Alteration"]["Other"]["Symmetrical"] = IsUsing_Symmetrical;
    settings["Alteration"]["Other"]["Tilted"] = IsUsing_Tilted;
    settings["Alteration"]["Other"]["Walmart Mini"] = IsUsing_Walmart_Mini;
    settings["Alteration"]["Other"]["YEET"] = IsUsing_YEET;
    settings["Alteration"]["Other"]["YEET Down"] = IsUsing_YEET_Down;

    // Extra Campaigns
    settings["Alteration"]["Extra Campaigns"]["Training"] = IsUsing_Trainig;
    settings["Alteration"]["Extra Campaigns"]["TMGL / TMWT Easy mode"] = IsUsing_TMGL_Easy;
    settings["Alteration"]["Extra Campaigns"]["Competitions (With Alterations)"] = IsUsing__AllOfficialCompetitions;
    settings["Alteration"]["Extra Campaigns"]["Competitions (Without Alterations)"] = IsUsing_AllOfficialCompetitions;
    settings["Alteration"]["Extra Campaigns"]["Unaltered Nadeo"] = IsUsing_OfficialNadeo;
    settings["Alteration"]["Extra Campaigns"]["Altered TOTD"] = IsUsing_AllTOTD;

    // Seasons
    settings["Alteration"]["Seasons"]["Spring 2020"] = IsUsing_Spring2020Maps;
    settings["Alteration"]["Seasons"]["Summer 2020"] = IsUsing_Summer2020Maps;
    settings["Alteration"]["Seasons"]["Fall 2020"] = IsUsing_Fall2020Maps;
    settings["Alteration"]["Seasons"]["Winter 2021"] = IsUsing_Winter2021Maps;
    settings["Alteration"]["Seasons"]["Spring 2021"] = IsUsing_Spring2021Maps;
    settings["Alteration"]["Seasons"]["Summer 2021"] = IsUsing_Summer2021Maps;
    settings["Alteration"]["Seasons"]["Fall 2021"] = IsUsing_Fall2021Maps;
    settings["Alteration"]["Seasons"]["Winter 2022"] = IsUsing_Winter2022Maps;
    settings["Alteration"]["Seasons"]["Spring 2022"] = IsUsing_Spring2022Maps;
    settings["Alteration"]["Seasons"]["Summer 2022"] = IsUsing_Summer2022Maps;
    settings["Alteration"]["Seasons"]["Fall 2022"] = IsUsing_Fall2022Maps;
    settings["Alteration"]["Seasons"]["Winter 2023"] = IsUsing_Winter2023Maps;
    settings["Alteration"]["Seasons"]["Spring 2023"] = IsUsing_Spring2023Maps;
    settings["Alteration"]["Seasons"]["Summer 2023"] = IsUsing_Summer2023Maps;
    settings["Alteration"]["Seasons"]["Fall 2023"] = IsUsing_Fall2023Maps;
    settings["Alteration"]["Seasons"]["Winter 2024"] = IsUsing_Winter2024Maps;
    settings["Alteration"]["Seasons"]["Spring 2024"] = IsUsing_Spring2024Maps;
    settings["Alteration"]["Seasons"]["Summer 2024"] = IsUsing_Summer2024Maps;
    settings["Alteration"]["Seasons"]["Fall 2024"] = IsUsing_Fall2024Maps;
    settings["Alteration"]["Seasons"]["Winter 2025"] = IsUsing_Winter2025Maps;
    settings["Alteration"]["Seasons"]["Spring 2025"] = IsUsing_Spring2025Maps;
    settings["Alteration"]["Seasons"]["Summer 2025"] = IsUsing_Summer2025Maps;

    // Not on the discord
    settings["Alteration"]["Not on Discord"]["Hard"] = IsUsing_Hard;

    return settings;
}

// string SetOnlyWinterMaps(bool value) {
//     return "Sorry this currently isn't implemented";
// }
// string SetOnlySpringMaps(bool value) {
//     return "Sorry this currently isn't implemented";
// }
// string SetOnlySummerMaps(bool value) {
//     return "Sorry this currently isn't implemented";
// }
// string SetOnlyFallMaps(bool value) {
//     return "Sorry this currently isn't implemented";
// }

// bool SetSpring2020Maps(bool value) { if (value) { IsUsing_Spring2020Maps = true; } else (!value); { IsUsing_Spring2020Maps = false; } return IsUsing_Spring2020Maps; }
// bool SetSummer2020Maps(bool value) { if (value) { IsUsing_Summer2020Maps = true; } else (!value); { IsUsing_Summer2020Maps = false; } return IsUsing_Summer2020Maps; }
// bool SetFall2020Maps(bool value)   { if (value) { IsUsing_Fall2020Maps = true; }   else (!value); { IsUsing_Fall2020Maps = false; }   return IsUsing_Fall2020Maps; }
// bool SetWinter2021Maps(bool value) { if (value) { IsUsing_Winter2021Maps = true; } else (!value); { IsUsing_Winter2021Maps = false; } return IsUsing_Winter2021Maps; }
// bool SetSpring2021Maps(bool value) { if (value) { IsUsing_Spring2021Maps = true; } else (!value); { IsUsing_Spring2021Maps = false; } return IsUsing_Spring2021Maps; }
// bool SetSummer2021Maps(bool value) { if (value) { IsUsing_Summer2021Maps = true; } else (!value); { IsUsing_Summer2021Maps = false; } return IsUsing_Summer2021Maps; }
// bool SetFall2021Maps(bool value)   { if (value) { IsUsing_Fall2021Maps = true; }   else (!value); { IsUsing_Fall2021Maps = false; }   return IsUsing_Fall2021Maps; }
// bool SetWinter2022Maps(bool value) { if (value) { IsUsing_Winter2022Maps = true; } else (!value); { IsUsing_Winter2022Maps = false; } return IsUsing_Winter2022Maps; }
// bool SetSpring2022Maps(bool value) { if (value) { IsUsing_Spring2022Maps = true; } else (!value); { IsUsing_Spring2022Maps = false; } return IsUsing_Spring2022Maps; }
// bool SetSummer2022Maps(bool value) { if (value) { IsUsing_Summer2022Maps = true; } else (!value); { IsUsing_Summer2022Maps = false; } return IsUsing_Summer2022Maps; }
// bool SetFall2022Maps(bool value)   { if (value) { IsUsing_Fall2022Maps = true; }   else (!value); { IsUsing_Fall2022Maps = false; }   return IsUsing_Fall2022Maps; }
// bool SetWinter2023Maps(bool value) { if (value) { IsUsing_Winter2023Maps = true; } else (!value); { IsUsing_Winter2023Maps = false; } return IsUsing_Winter2023Maps; }
// bool SetSpring2023Maps(bool value) { if (value) { IsUsing_Spring2023Maps = true; } else (!value); { IsUsing_Spring2023Maps = false; } return IsUsing_Spring2023Maps; }
// bool SetSummer2023Maps(bool value) { if (value) { IsUsing_Summer2023Maps = true; } else (!value); { IsUsing_Summer2023Maps = false; } return IsUsing_Summer2023Maps; }
// bool SetFall2023Maps(bool value)   { if (value) { IsUsing_Fall2023Maps = true; }   else (!value); { IsUsing_Fall2023Maps = false; }   return IsUsing_Fall2023Maps; }
// bool SetWinter2024Maps(bool value) { if (value) { IsUsing_Winter2024Maps = true; } else (!value); { IsUsing_Winter2024Maps = false; } return IsUsing_Winter2024Maps; }
// bool SetSpring2024Maps(bool value) { if (value) { IsUsing_Spring2024Maps = true; } else (!value); { IsUsing_Spring2024Maps = false; } return IsUsing_Spring2024Maps; }
// bool SetSummer2024Maps(bool value) { if (value) { IsUsing_Summer2024Maps = true; } else (!value); { IsUsing_Summer2024Maps = false; } return IsUsing_Summer2024Maps; }
// bool SetFall2024Maps(bool value)   { if (value) { IsUsing_Fall2024Maps = true; }   else (!value); { IsUsing_Fall2024Maps = false; }   return IsUsing_Fall2024Maps; }
// bool SetWinter2025Maps(bool value) { if (value) { IsUsing_Winter2025Maps = true; } else (!value); { IsUsing_Winter2025Maps = false; } return IsUsing_Winter2025Maps; }
// bool SetSpring2025Maps(bool value) { if (value) { IsUsing_Spring2025Maps = true; } else (!value); { IsUsing_Spring2025Maps = false; } return IsUsing_Spring2025Maps; }

// bool SetSNOW(bool value)                   { if (value) { IsUsing_Snow_ = true; }                        else (!value); { IsUsing_Snow_ = false; }                        return IsUsing_Snow_; }
// bool SetSNOW_Carswitch(bool value)         { if (value) { IsUsing_Snow_Carswitch = true; }               else (!value); { IsUsing_Snow_Carswitch = false; }               return IsUsing_Snow_Carswitch; }
// bool SetSNOW_Checkpointless(bool value)    { if (value) { IsUsing_Snow_Checkpointless = true; }          else (!value); { IsUsing_Snow_Checkpointless = false; }          return IsUsing_Snow_Checkpointless; }
// bool SetSNOW_Icy(bool value)               { if (value) { IsUsing_Snow_Icy = true; }                     else (!value); { IsUsing_Snow_Icy = false; }                     return IsUsing_Snow_Icy; }
// bool SetSNOW_Underwater(bool value)        { if (value) { IsUsing_Snow_Underwater = true; }              else (!value); { IsUsing_Snow_Underwater = false; }              return IsUsing_Snow_Underwater; }
// bool SetSNOW_Wood(bool value)              { if (value) { IsUsing_Snow_Wood = true; }                    else (!value); { IsUsing_Snow_Wood = false; }                    return IsUsing_Snow_Wood; }

// bool SetSTADIUM(bool value)                { if (value) { IsUsing_Stadium_ = true; }                     else (!value); { IsUsing_Stadium_ = false; }                     return IsUsing_Stadium_; }

// bool SetRALLY(bool value)                  { if (value) { IsUsing_Rally_ = true; }                       else (!value); { IsUsing_Rally_ = false; }                       return IsUsing_Rally_; }

// bool Set1Back(bool value)                  { if (value) { IsUsing_1Back = true; }                        else (!value); { IsUsing_1Back = false; }                        return IsUsing_1Back; }
// bool Set1Down(bool value)                  { if (value) { IsUsing_1Down = true; }                        else (!value); { IsUsing_1Down = false; }                        return IsUsing_1Down; }
// bool Set1Left(bool value)                  { if (value) { IsUsing_1Left = true; }                        else (!value); { IsUsing_1Left = false; }                        return IsUsing_1Left; }
// bool Set1Right(bool value)                 { if (value) { IsUsing_1Right = true; }                       else (!value); { IsUsing_1Right = false; }                       return IsUsing_1Right; }
// bool Set1Up(bool value)                    { if (value) { IsUsing_1Up = true; }                          else (!value); { IsUsing_1Up = false; }                          return IsUsing_1Up; }
// bool Set2D(bool value)                     { if (value) { IsUsing_Flat_2D = true; }                           else (!value); { IsUsing_Flat_2D = false; }                           return IsUsing_Flat_2D; }
// bool Set2Up(bool value)                    { if (value) { IsUsing_2Up = true; }                          else (!value); { IsUsing_2Up = false; }                          return IsUsing_2Up; }
// bool SetA08(bool value)                    { if (value) { IsUsing_A08 = true; }                          else (!value); { IsUsing_A08 = false; }                          return IsUsing_A08; }
// bool SetAntibooster(bool value)            { if (value) { IsUsing_Antibooster = true; }                  else (!value); { IsUsing_Antibooster = false; }                  return IsUsing_Antibooster; }
// bool SetBoss(bool value)                   { if (value) { IsUsing_BOSS = true; }                         else (!value); { IsUsing_BOSS = false; }                         return IsUsing_BOSS; }
// bool SetBackwards(bool value)              { if (value) { IsUsing_Backwards = true; }                    else (!value); { IsUsing_Backwards = false; }                    return IsUsing_Backwards; }
// bool SetBetter_Mixed(bool value)           { if (value) { IsUsing_Better_Mixed = true; }                 else (!value); { IsUsing_Better_Mixed = false; }                 return IsUsing_Better_Mixed; }
// bool SetBetter_Reverse(bool value)         { if (value) { IsUsing_Better_Reverse = true; }               else (!value); { IsUsing_Better_Reverse = false; }               return IsUsing_Better_Reverse; }
// bool SetBlind(bool value)                  { if (value) { IsUsing_Blind = true; }                        else (!value); { IsUsing_Blind = false; }                        return IsUsing_Blind; }
// bool SetBobsleigh(bool value)              { if (value) { IsUsing_Bobsleigh = true; }                    else (!value); { IsUsing_Bobsleigh = false; }                    return IsUsing_Bobsleigh; }
// bool SetBoomerangThereAndBack(bool value)  { if (value) { IsUsing_There_and_Back_Boomerang = true; }     else (!value); { IsUsing_There_and_Back_Boomerang = false; }     return IsUsing_There_and_Back_Boomerang; }
// bool SetBoosterless(bool value)            { if (value) { IsUsing_Boosterless = true; }                  else (!value); { IsUsing_Boosterless = false; }                  return IsUsing_Boosterless; }
// bool SetBroken(bool value)                 { if (value) { IsUsing_Broken = true; }                       else (!value); { IsUsing_Broken = false; }                       return IsUsing_Broken; }
// bool SetBumper(bool value)                 { if (value) { IsUsing_Bumper = true; }                       else (!value); { IsUsing_Bumper = false; }                       return IsUsing_Bumper; }
// bool SetCP1Kept(bool value)                { if (value) { IsUsing_CP1_Kept = true; }                     else (!value); { IsUsing_CP1_Kept = false; }                     return IsUsing_CP1_Kept; }
// bool SetCP1IsEnd(bool value)               { if (value) { IsUsing_CP1_is_End = true; }                   else (!value); { IsUsing_CP1_is_End = false; }                   return IsUsing_CP1_is_End; }
// bool SetCPLink(bool value)                 { if (value) { IsUsing_CPLink = true; }                       else (!value); { IsUsing_CPLink = false; }                       return IsUsing_CPLink; }
// bool SetCPBoost(bool value)                { if (value) { IsUsing_CP_Boost = true; }                     else (!value); { IsUsing_CP_Boost = false; }                     return IsUsing_CP_Boost; }
// bool SetCPfull(bool value)                 { if (value) { IsUsing_CPfull = true; }                       else (!value); { IsUsing_CPfull = false; }                       return IsUsing_CPfull; }
// bool SetCheckpoin_t(bool value)            { if (value) { IsUsing_Checkpoin_t = true; }                  else (!value); { IsUsing_Checkpoin_t = false; }                  return IsUsing_Checkpoin_t; }
// bool SetCheckpointless(bool value)         { if (value) { IsUsing_Checkpointless = true; }               else (!value); { IsUsing_Checkpointless = false; }               return IsUsing_Checkpointless; }
// bool SetCheckpointless_Reverse(bool value) { if (value) { IsUsing_Checkpointless_Reverse = true; }       else (!value); { IsUsing_Checkpointless_Reverse = false; }       return IsUsing_Checkpointless_Reverse; }
// bool SetCleaned(bool value)                { if (value) { IsUsing_Cleaned = true; }                      else (!value); { IsUsing_Cleaned = false; }                      return IsUsing_Cleaned; }
// bool SetColorsCombined(bool value)         { if (value) { IsUsing_Colours_Combined = true; }              else (!value); { IsUsing_Colours_Combined = false; }              return IsUsing_Colours_Combined; }
// bool SetCruise(bool value)                 { if (value) { IsUsing_Cruise = true; }                       else (!value); { IsUsing_Cruise = false; }                       return IsUsing_Cruise; }
// bool SetDirt(bool value)                   { if (value) { IsUsing_Dirt = true; }                         else (!value); { IsUsing_Dirt = false; }                         return IsUsing_Dirt; }
// bool SetEarthquake(bool value)             { if (value) { IsUsing_Earthquake = true; }                   else (!value); { IsUsing_Earthquake = false; }                   return IsUsing_Earthquake; }
// bool SetEffectless(bool value)             { if (value) { IsUsing_No_Effects = true; }                   else (!value); { IsUsing_No_Effects = false; }                   return IsUsing_No_Effects; }
// bool SetEgocentrism(bool value)            { if (value) { IsUsing_Egocentrism = true; }                  else (!value); { IsUsing_Egocentrism = false; }                  return IsUsing_Egocentrism; }
// bool SetFast(bool value)                   { if (value) { IsUsing_Fast = true; }                         else (!value); { IsUsing_Fast = false; }                         return IsUsing_Fast; }
// bool SetFastMagnet(bool value)             { if (value) { IsUsing_Fast_Magnet = true; }                  else (!value); { IsUsing_Fast_Magnet = false; }                  return IsUsing_Fast_Magnet; }
// bool SetFlipped(bool value)                { if (value) { IsUsing_Flipped = true; }                      else (!value); { IsUsing_Flipped = false; }                      return IsUsing_Flipped; }
// bool SetFlooded(bool value)                { if (value) { IsUsing_Flooded = true; }                      else (!value); { IsUsing_Flooded = false; }                      return IsUsing_Flooded; }
// bool SetFloorFin(bool value)               { if (value) { IsUsing_Floor_Fin = true; }                    else (!value); { IsUsing_Floor_Fin = false; }                    return IsUsing_Floor_Fin; }
// bool SetFragile(bool value)                { if (value) { IsUsing_Fragile = true; }                      else (!value); { IsUsing_Fragile = false; }                      return IsUsing_Fragile; }
// bool SetFreewheel(bool value)              { if (value) { IsUsing_Freewheel = true; }                    else (!value); { IsUsing_Freewheel = false; }                    return IsUsing_Freewheel; }
// bool SetGlider(bool value)                 { if (value) { IsUsing_Glider = true; }                       else (!value); { IsUsing_Glider = false; }                       return IsUsing_Glider; }
// bool SetGotRotated_CPsRotated(bool value)  { if (value) { IsUsing_Got_Rotated_CPs_Rotated_90__ = true; } else (!value); { IsUsing_Got_Rotated_CPs_Rotated_90__ = false; } return IsUsing_Got_Rotated_CPs_Rotated_90__; }
// bool SetGrass(bool value)                  { if (value) { IsUsing_Grass = true; }                        else (!value); { IsUsing_Grass = false; }                        return IsUsing_Grass; }
// bool SetHard(bool value)                   { if (value) { IsUsing_Hard = true; }                         else (!value); { IsUsing_Hard = false; }                         return IsUsing_Hard; }
// bool SetHoles(bool value)                  { if (value) { IsUsing_Holes = true; }                        else (!value); { IsUsing_Holes = false; }                        return IsUsing_Holes; }
// bool SetIce(bool value)                    { if (value) { IsUsing_Ice = true; }                          else (!value); { IsUsing_Ice = false; }                          return IsUsing_Ice; }
// bool SetIce_Reverse(bool value)            { if (value) { IsUsing_Ice_Reverse = true; }                  else (!value); { IsUsing_Ice_Reverse = false; }                  return IsUsing_Ice_Reverse; }
// bool SetIce_Reverse_Reactor(bool value)    { if (value) { IsUsing_Ice_Reverse_Reactor = true; }          else (!value); { IsUsing_Ice_Reverse_Reactor = false; }          return IsUsing_Ice_Reverse_Reactor; }
// bool SetIce_Short(bool value)              { if (value) { IsUsing_Ice_Short = true; }                    else (!value); { IsUsing_Ice_Short = false; }                    return IsUsing_Ice_Short; }
// bool SetIcy_Reactor(bool value)            { if (value) { IsUsing_Icy_Reactor = true; }                  else (!value); { IsUsing_Icy_Reactor = false; }                  return IsUsing_Icy_Reactor; }
// bool SetInclined(bool value)               { if (value) { IsUsing_Inclined = true; }                     else (!value); { IsUsing_Inclined = false; }                     return IsUsing_Inclined; }
// bool SetLunatic(bool value)                { if (value) { IsUsing_Lunatic = true; }                      else (!value); { IsUsing_Lunatic = false; }                      return IsUsing_Lunatic; }
// bool SetMagnet(bool value)                 { if (value) { IsUsing_Magnet = true; }                       else (!value); { IsUsing_Magnet = false; }                       return IsUsing_Magnet; }
// bool SetMagnet_Reverse(bool value)         { if (value) { IsUsing_Magnet_Reverse = true; }               else (!value); { IsUsing_Magnet_Reverse = false; }               return IsUsing_Magnet_Reverse; }
// bool SetManslaughter(bool value)           { if (value) { IsUsing_Manslaughter = true; }                 else (!value); { IsUsing_Manslaughter = false; }                 return IsUsing_Manslaughter; }
// bool SetMiniRPG(bool value)                { if (value) { IsUsing_Mini_RPG = true; }                     else (!value); { IsUsing_Mini_RPG = false; }                     return IsUsing_Mini_RPG; }
// bool SetMirrored(bool value)               { if (value) { IsUsing_Mirrored = true; }                     else (!value); { IsUsing_Mirrored = false; }                     return IsUsing_Mirrored; }
// bool SetMixed(bool value)                  { if (value) { IsUsing_Mixed = true; }                        else (!value); { IsUsing_Mixed = false; }                        return IsUsing_Mixed; }
// bool SetNgolo_Cacti(bool value)            { if (value) { IsUsing_Ngolo_Cacti = true; }                  else (!value); { IsUsing_Ngolo_Cacti = false; }                  return IsUsing_Ngolo_Cacti; }
// bool SetNoSteer(bool value)                { if (value) { IsUsing_No_Steer = true; }                     else (!value); { IsUsing_No_Steer = false; }                     return IsUsing_No_Steer; }
// bool SetNoBrakes(bool value)               { if (value) { IsUsing_No_Brakes = true; }                    else (!value); { IsUsing_No_Brakes = false; }                    return IsUsing_No_Brakes; }
// bool SetNoCut(bool value)                  { if (value) { IsUsing_No_Cut = true; }                       else (!value); { IsUsing_No_Cut = false; }                       return IsUsing_No_Cut; }
// bool SetNoGrip(bool value)                 { if (value) { IsUsing_No_Grip = true; }                      else (!value); { IsUsing_No_Grip = false; }                      return IsUsing_No_Grip; }
// bool SetNoGear5(bool value)                { if (value) { IsUsing_No_Gear_5 = true; }                    else (!value); { IsUsing_No_Gear_5 = false; }                    return IsUsing_No_Gear_5; }
// bool SetPenalty(bool value)                { if (value) { IsUsing_Penalty = true; }                      else (!value); { IsUsing_Penalty = false; }                      return IsUsing_Penalty; }
// bool SetPipe(bool value)                   { if (value) { IsUsing_Pipe = true; }                         else (!value); { IsUsing_Pipe = false; }                         return IsUsing_Pipe; }
// bool SetPlastic(bool value)                { if (value) { IsUsing_Plastic = true; }                      else (!value); { IsUsing_Plastic = false; }                      return IsUsing_Plastic; }
// bool SetPlastic_Reverse(bool value)        { if (value) { IsUsing_Plastic_Reverse = true; }              else (!value); { IsUsing_Plastic_Reverse = false; }              return IsUsing_Plastic_Reverse; }
// bool SetPlatform(bool value)               { if (value) { IsUsing_Platform = true; }                     else (!value); { IsUsing_Platform = false; }                     return IsUsing_Platform; }
// bool SetPodium(bool value)                 { if (value) { IsUsing_Podium = true; }                       else (!value); { IsUsing_Podium = false; }                       return IsUsing_Podium; }
// bool SetPoolHunters(bool value)            { if (value) { IsUsing_Pool_Hunters = true; }                 else (!value); { IsUsing_Pool_Hunters = false; }                 return IsUsing_Pool_Hunters; }
// bool SetPuzzle(bool value)                 { if (value) { IsUsing_Puzzle = true; }                       else (!value); { IsUsing_Puzzle = false; }                       return IsUsing_Puzzle; }
// bool SetRandom(bool value)                 { if (value) { IsUsing_Random = true; }                       else (!value); { IsUsing_Random = false; }                       return IsUsing_Random; }
// bool SetRandomDankness(bool value)         { if (value) { IsUsing_Random_Dankness = true; }              else (!value); { IsUsing_Random_Dankness = false; }              return IsUsing_Random_Dankness; }
// bool SetRandomEffects(bool value)          { if (value) { IsUsing_Random_Effects = true; }               else (!value); { IsUsing_Random_Effects = false; }               return IsUsing_Random_Effects; }
// bool SetReactor(bool value)                { if (value) { IsUsing_Reactor = true; }                      else (!value); { IsUsing_Reactor = false; }                      return IsUsing_Reactor; }
// bool SetReactorDown(bool value)            { if (value) { IsUsing_Reactor_Down = true; }                 else (!value); { IsUsing_Reactor_Down = false; }                 return IsUsing_Reactor_Down; }
// bool SetReverse(bool value)                { if (value) { IsUsing_Reverse = true; }                      else (!value); { IsUsing_Reverse = false; }                      return IsUsing_Reverse; }
// bool SetRingCP(bool value)                 { if (value) { IsUsing_Ring_CP = true; }                      else (!value); { IsUsing_Ring_CP = false; }                      return IsUsing_Ring_CP; }
// bool SetRoad(bool value)                   { if (value) { IsUsing_Road = true; }                         else (!value); { IsUsing_Road = false; }                         return IsUsing_Road; }
// bool SetRoad_Dirt(bool value)              { if (value) { IsUsing_Road_Dirt = true; }                    else (!value); { IsUsing_Road_Dirt = false; }                    return IsUsing_Road_Dirt; }
// bool SetRoofing(bool value)                { if (value) { IsUsing_Roofing = true; }                      else (!value); { IsUsing_Roofing = false; }                      return IsUsing_Roofing; }
// bool SetSausage(bool value)                { if (value) { IsUsing_Sausage = true; }                      else (!value); { IsUsing_Sausage = false; }                      return IsUsing_Sausage; }
// bool SetScubaDiving(bool value)            { if (value) { IsUsing_Scuba_Diving = true; }                 else (!value); { IsUsing_Scuba_Diving = false; }                 return IsUsing_Scuba_Diving; }
// bool SetSectionsjoined(bool value)         { if (value) { IsUsing_Sections_joined = true; }              else (!value); { IsUsing_Sections_joined = false; }              return IsUsing_Sections_joined; }
// bool SetSelectDEL(bool value)              { if (value) { IsUsing_Select_DEL = true; }                   else (!value); { IsUsing_Select_DEL = false; }                   return IsUsing_Select_DEL; }
// bool SetShort(bool value)                  { if (value) { IsUsing_Short = true; }                        else (!value); { IsUsing_Short = false; }                        return IsUsing_Short; }
// bool SetSkyIsTheFinish(bool value)         { if (value) { IsUsing_Sky_is_the_Finish = true; }            else (!value); { IsUsing_Sky_is_the_Finish = false; }            return IsUsing_Sky_is_the_Finish; }
// bool SetSkyIsTheFinishReverse(bool value)  { if (value) { IsUsing_Sky_is_the_Finish_Reverse = true; }    else (!value); { IsUsing_Sky_is_the_Finish_Reverse = false; }    return IsUsing_Sky_is_the_Finish_Reverse; }
// bool SetSlowmo(bool value)                 { if (value) { IsUsing_Slowmo = true; }                       else (!value); { IsUsing_Slowmo = false; }                       return IsUsing_Slowmo; }
// bool SetSpeedlimit(bool value)             { if (value) { IsUsing_Speedlimit = true; }                   else (!value); { IsUsing_Speedlimit = false; }                   return IsUsing_Speedlimit; }
// bool SetStaircase(bool value)              { if (value) { IsUsing_Staircase = true; }                    else (!value); { IsUsing_Staircase = false; }                    return IsUsing_Staircase; }
// bool SetStart1Down(bool value)             { if (value) { IsUsing_Start_1_Down = true; }                 else (!value); { IsUsing_Start_1_Down = false; }                 return IsUsing_Start_1_Down; }
// bool SetStraightToTheFinish(bool value)    { if (value) { IsUsing_Straight_to_the_Finish = true; }       else (!value); { IsUsing_Straight_to_the_Finish = false; }       return IsUsing_Straight_to_the_Finish; }
// bool SetSupersized(bool value)             { if (value) { IsUsing_Supersized = true; }                   else (!value); { IsUsing_Supersized = false; }                   return IsUsing_Supersized; }
// bool SetSurfaceless(bool value)            { if (value) { IsUsing_Surfaceless = true; }                  else (!value); { IsUsing_Surfaceless = false; }                  return IsUsing_Surfaceless; }
// bool Set_sw2u1l_cpu_f2d1r(bool value)      { if (value) { IsUsing_sw2u1l_cpu_f2d1r = true; }             else (!value); { IsUsing_sw2u1l_cpu_f2d1r = false; }             return IsUsing_sw2u1l_cpu_f2d1r; }
// bool SetSymmetrical(bool value)            { if (value) { IsUsing_Symmetrical = true; }                  else (!value); { IsUsing_Symmetrical = false; }                  return IsUsing_Symmetrical; }
// bool SetTMGL_Easy(bool value)              { if (value) { IsUsing_TMGL_Easy = true; }                    else (!value); { IsUsing_TMGL_Easy = false; }                    return IsUsing_TMGL_Easy; }
// bool SetTilted(bool value)                 { if (value) { IsUsing_Tilted = true; }                       else (!value); { IsUsing_Tilted = false; }                       return IsUsing_Tilted; }
// bool SetUnderwater(bool value)             { if (value) { IsUsing_Underwater = true; }                   else (!value); { IsUsing_Underwater = false; }                   return IsUsing_Underwater; }
// bool SetUnderwater_Reverse(bool value)     { if (value) { IsUsing_Underwater_Reverse = true; }           else (!value); { IsUsing_Underwater_Reverse = false; }           return IsUsing_Underwater_Reverse; }
// bool SetWalmartMini(bool value)            { if (value) { IsUsing_Walmart_Mini = true; }                 else (!value); { IsUsing_Walmart_Mini = false; }                 return IsUsing_Walmart_Mini; }
// bool SetWetIcyWood(bool value)             { if (value) { IsUsing_Wet_Icy_Wood = true; }                 else (!value); { IsUsing_Wet_Icy_Wood = false; }                 return IsUsing_Wet_Icy_Wood; }
// bool SetWetWheels(bool value)              { if (value) { IsUsing_Wet_Wheels = true; }                   else (!value); { IsUsing_Wet_Wheels = false; }                   return IsUsing_Wet_Wheels; }
// bool SetWetWood(bool value)                { if (value) { IsUsing_Wet_Wood = true; }                     else (!value); { IsUsing_Wet_Wood = false; }                     return IsUsing_Wet_Wood; }
// bool SetWood(bool value)                   { if (value) { IsUsing_Wood = true; }                         else (!value); { IsUsing_Wood = false; }                         return IsUsing_Wood; }
// bool SetWornTires(bool value)              { if (value) { IsUsing_Worn_Tires = true; }                   else (!value); { IsUsing_Worn_Tires = false; }                   return IsUsing_Worn_Tires; }
// bool SetXX_But(bool value)                 { if (value) { IsUsing_XX_But = true; }                       else (!value); { IsUsing_XX_But = false; }                       return IsUsing_XX_But; }
// bool SetYEET(bool value)                   { if (value) { IsUsing_YEET = true; }                         else (!value); { IsUsing_YEET = false; }                         return IsUsing_YEET; }
// bool SetYEET_Down(bool value)              { if (value) { IsUsing_YEET_Down = true; }                    else (!value); { IsUsing_YEET_Down = false; }                    return IsUsing_YEET_Down; }
// bool SetYEET_Puzzle(bool value)            { if (value) { IsUsing_YEET_Puzzle = true; }                  else (!value); { IsUsing_YEET_Puzzle = false; }                  return IsUsing_YEET_Puzzle; }
// bool SetYEET_Random_Puzzle(bool value)     { if (value) { IsUsing_YEET_Random_Puzzle = true; }           else (!value); { IsUsing_YEET_Random_Puzzle = false; }           return IsUsing_YEET_Random_Puzzle; }
// bool SetYEET_Reverse(bool value)           { if (value) { IsUsing_YEET_Reverse = true; }                 else (!value); { IsUsing_YEET_Reverse = false; }                 return IsUsing_YEET_Reverse; }
// bool SetYeet_Max_Up(bool value)            { if (value) { IsUsing_Yeet_Max_Up = true; }                  else (!value); { IsUsing_Yeet_Max_Up = false; }                  return IsUsing_Yeet_Max_Up; }
// bool SetYEP_Tree_Puzzle(bool value)        { if (value) { IsUsing_YEP_Tree_Puzzle = true; }              else (!value); { IsUsing_YEP_Tree_Puzzle = false; }              return IsUsing_YEP_Tree_Puzzle; }

// bool SetAllOfficialCompetitions(bool value)        { if (value) { IsUsing_AllOfficialCompetitions = true; }  else (!value); { IsUsing_AllOfficialCompetitions = false; }  return IsUsing_AllOfficialCompetitions; }
// bool SetAllAlteredOfficialCompetitions(bool value) { if (value) { IsUsing__AllOfficialCompetitions = true; } else (!value); { IsUsing__AllOfficialCompetitions = false; } return IsUsing__AllOfficialCompetitions; }
// bool SetAllSnowDiscovery(bool value)               { if (value) { IsUsing_AllSnowDiscovery = true; }         else (!value); { IsUsing_AllSnowDiscovery = false; }         return IsUsing_AllSnowDiscovery; }
// bool SetAllRallyDiscovery(bool value)              { if (value) { IsUsing_AllRallyDiscovery = true; }        else (!value); { IsUsing_AllRallyDiscovery = false; }        return IsUsing_AllRallyDiscovery; }
// bool SetMapIsNotObtainable(bool value)             { if (value) { IsUsing_MapIsNotObtainable = true; }       else (!value); { IsUsing_MapIsNotObtainable = false; }       return IsUsing_MapIsNotObtainable; }
// bool SetOfficialNadeo(bool value)                  { if (value) { IsUsing_OfficialNadeo = true; }            else (!value); { IsUsing_OfficialNadeo = false; }            return IsUsing_OfficialNadeo; }
// bool SetAllTOTD(bool value)                        { if (value) { IsUsing_AllTOTD = true; }                  else (!value); { IsUsing_AllTOTD = false; }                  return IsUsing_AllTOTD; }
// ;