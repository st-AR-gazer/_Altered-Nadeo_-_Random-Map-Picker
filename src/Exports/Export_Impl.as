string GetARandomAltMapUid() {
    string t_uid = GetRandomUID();
    return t_uid;
}

string GetARandomAltMapStorageObject() {
    string t_storageObject = FetchRandomMapUrl();
    return t_storageObject;
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
    // settings["Alteration"]["Not on Discord"]["Hard"] = IsUsing_Hard; // Is actally Lunatic

    return settings;
}

void SetSeason(const string &in t_season, bool t_shouldUse) {
    if (t_season.ToLower() == "spring 2020") { IsUsing_Spring2020Maps = t_shouldUse; }
    else if (t_season.ToLower() == "summer 2020") { IsUsing_Summer2020Maps = t_shouldUse; }
    else if (t_season.ToLower() == "fall 2020") { IsUsing_Fall2020Maps = t_shouldUse; }
    else if (t_season.ToLower() == "winter 2021") { IsUsing_Winter2021Maps = t_shouldUse; }
    else if (t_season.ToLower() == "spring 2021") { IsUsing_Spring2021Maps = t_shouldUse; }
    else if (t_season.ToLower() == "summer 2021") { IsUsing_Summer2021Maps = t_shouldUse; }
    else if (t_season.ToLower() == "fall 2021") { IsUsing_Fall2021Maps = t_shouldUse; }
    else if (t_season.ToLower() == "winter 2022") { IsUsing_Winter2022Maps = t_shouldUse; }
    else if (t_season.ToLower() == "spring 2022") { IsUsing_Spring2022Maps = t_shouldUse; }
    else if (t_season.ToLower() == "summer 2022") { IsUsing_Summer2022Maps = t_shouldUse; }
    else if (t_season.ToLower() == "fall 2022") { IsUsing_Fall2022Maps = t_shouldUse; }
    else if (t_season.ToLower() == "winter 2023") { IsUsing_Winter2023Maps = t_shouldUse; }
    else if (t_season.ToLower() == "spring 2023") { IsUsing_Spring2023Maps = t_shouldUse; }
    else if (t_season.ToLower() == "summer 2023") { IsUsing_Summer2023Maps = t_shouldUse; }
    else if (t_season.ToLower() == "fall 2023") { IsUsing_Fall2023Maps = t_shouldUse; }
    else if (t_season.ToLower() == "winter 2024") { IsUsing_Winter2024Maps = t_shouldUse; }
    else if (t_season.ToLower() == "spring 2024") { IsUsing_Spring2024Maps = t_shouldUse; }
    else if (t_season.ToLower() == "summer 2024") { IsUsing_Summer2024Maps = t_shouldUse; }
    else if (t_season.ToLower() == "fall 2024") { IsUsing_Fall2024Maps = t_shouldUse; }
    else if (t_season.ToLower() == "winter 2025") { IsUsing_Winter2025Maps = t_shouldUse; }
    else if (t_season.ToLower() == "spring 2025") { IsUsing_Spring2025Maps = t_shouldUse; }
    else if (t_season.ToLower() == "summer 2025") { IsUsing_Summer2025Maps = t_shouldUse; }
}

void SetAlteration(const string &in t_alteration, bool t_shouldUse) {
    if (t_alteration.ToLower() == "dirt") { IsUsing_Dirt = t_shouldUse; }
    else if (t_alteration.ToLower() == "fast fagnet") { IsUsing_Fast_Magnet = t_shouldUse; }
    else if (t_alteration.ToLower() == "flooded") { IsUsing_Flooded = t_shouldUse; }
    else if (t_alteration.ToLower() == "grass") { IsUsing_Grass = t_shouldUse; }
    else if (t_alteration.ToLower() == "ice") { IsUsing_Ice = t_shouldUse; }
    else if (t_alteration.ToLower() == "magnet") { IsUsing_Magnet = t_shouldUse; }
    else if (t_alteration.ToLower() == "mixed") { IsUsing_Mixed = t_shouldUse; }
    else if (t_alteration.ToLower() == "better mixed") { IsUsing_Better_Mixed = t_shouldUse; }
    else if (t_alteration.ToLower() == "penalty") { IsUsing_Penalty = t_shouldUse; }
    else if (t_alteration.ToLower() == "plastic") { IsUsing_Plastic = t_shouldUse; }
    else if (t_alteration.ToLower() == "road") { IsUsing_Road = t_shouldUse; }
    else if (t_alteration.ToLower() == "road dirt") { IsUsing_Road_Dirt = t_shouldUse; }
    else if (t_alteration.ToLower() == "wood") { IsUsing_Wood = t_shouldUse; }
    else if (t_alteration.ToLower() == "bobsleigh") { IsUsing_Bobsleigh = t_shouldUse; }
    else if (t_alteration.ToLower() == "pipe") { IsUsing_Pipe = t_shouldUse; }
    else if (t_alteration.ToLower() == "platform") { IsUsing_Platform = t_shouldUse; }
    else if (t_alteration.ToLower() == "sausage") { IsUsing_Sausage = t_shouldUse; }
    else if (t_alteration.ToLower() == "surfaceless") { IsUsing_Surfaceless = t_shouldUse; }
    else if (t_alteration.ToLower() == "underwater") { IsUsing_Underwater = t_shouldUse; }

    else if (t_alteration.ToLower() == "cruise") { IsUsing_Cruise = t_shouldUse; }
    else if (t_alteration.ToLower() == "fragile") { IsUsing_Fragile = t_shouldUse; }
    else if (t_alteration.ToLower() == "full fragile") { IsUsing_Full_Fragile = t_shouldUse; }
    else if (t_alteration.ToLower() == "freewheel") { IsUsing_Freewheel = t_shouldUse; }
    else if (t_alteration.ToLower() == "glider") { IsUsing_Glider = t_shouldUse; }
    else if (t_alteration.ToLower() == "no brake") { IsUsing_No_Brakes = t_shouldUse; }
    else if (t_alteration.ToLower() == "no effect") { IsUsing_No_Effects = t_shouldUse; }
    else if (t_alteration.ToLower() == "no grip") { IsUsing_No_Grip = t_shouldUse; }
    else if (t_alteration.ToLower() == "no steering") { IsUsing_No_Steer = t_shouldUse; }
    else if (t_alteration.ToLower() == "random dankness") { IsUsing_Random_Dankness = t_shouldUse; }
    else if (t_alteration.ToLower() == "random effects") { IsUsing_Random_Effects = t_shouldUse; }
    else if (t_alteration.ToLower() == "reactor (up)") { IsUsing_Reactor = t_shouldUse; }
    else if (t_alteration.ToLower() == "reactor down") { IsUsing_Reactor_Down = t_shouldUse; }
    else if (t_alteration.ToLower() == "slowmo") { IsUsing_Slowmo = t_shouldUse; }
    else if (t_alteration.ToLower() == "wet wheels") { IsUsing_Wet_Wheels = t_shouldUse; }
    else if (t_alteration.ToLower() == "worn tires") { IsUsing_Worn_Tires = t_shouldUse; }

    else if (t_alteration.ToLower() == "1 down") { IsUsing_1Down = t_shouldUse; }
    else if (t_alteration.ToLower() == "1 back / forward") { IsUsing_1Back = t_shouldUse; }
    else if (t_alteration.ToLower() == "1 left") { IsUsing_1Left = t_shouldUse; }
    else if (t_alteration.ToLower() == "1 right") { IsUsing_1Right = t_shouldUse; }
    else if (t_alteration.ToLower() == "1 up") { IsUsing_1Up = t_shouldUse; }
    else if (t_alteration.ToLower() == "2 up") { IsUsing_2Up = t_shouldUse; }
    else if (t_alteration.ToLower() == "better reverse / reverse magna") { IsUsing_Better_Reverse = t_shouldUse; }
    else if (t_alteration.ToLower() == "cp1 is end") { IsUsing_CP1_is_End = t_shouldUse; }
    else if (t_alteration.ToLower() == "floor fin") { IsUsing_Floor_Fin = t_shouldUse; }
    else if (t_alteration.ToLower() == "mansloughter") { IsUsing_Manslaughter = t_shouldUse; }
    else if (t_alteration.ToLower() == "no gear 5") { IsUsing_No_Gear_5 = t_shouldUse; }
    else if (t_alteration.ToLower() == "podium") { IsUsing_Podium = t_shouldUse; }
    else if (t_alteration.ToLower() == "puzzle") { IsUsing_Puzzle = t_shouldUse; }
    else if (t_alteration.ToLower() == "reverse") { IsUsing_Reverse = t_shouldUse; }
    else if (t_alteration.ToLower() == "roofing") { IsUsing_Roofing = t_shouldUse; }
    else if (t_alteration.ToLower() == "short") { IsUsing_Short = t_shouldUse; }
    else if (t_alteration.ToLower() == "sky is the finish") { IsUsing_Sky_is_the_Finish = t_shouldUse; }
    else if (t_alteration.ToLower() == "there and back / boomerang") { IsUsing_There_and_Back_Boomerang = t_shouldUse; }
    else if (t_alteration.ToLower() == "yep tree puzzle") { IsUsing_YEP_Tree_Puzzle = t_shouldUse; }
    else if (t_alteration.ToLower() == "inclined") { IsUsing_Inclined = t_shouldUse; }

    else if (t_alteration.ToLower() == "[stadium]") { IsUsing_Stadium_ = t_shouldUse; }
    else if (t_alteration.ToLower() == "[stadium] wet wood") { IsUsing_Stadium_Wet_Wood = t_shouldUse; }
    else if (t_alteration.ToLower() == "[snow]") { IsUsing_Snow_ = t_shouldUse; }
    else if (t_alteration.ToLower() == "[snow] carswitch") { IsUsing_Snow_Carswitch = t_shouldUse; }
    else if (t_alteration.ToLower() == "[snow] checkpointless") { IsUsing_Snow_Checkpointless = t_shouldUse; }
    else if (t_alteration.ToLower() == "[snow] ice") { IsUsing_Snow_Icy = t_shouldUse; }
    else if (t_alteration.ToLower() == "[snow] underwater") { IsUsing_Snow_Underwater; }
    else if (t_alteration.ToLower() == "[snow] wet plastic") { IsUsing_Snow_Wet_Plastic = t_shouldUse; }
    else if (t_alteration.ToLower() == "[snow] wood") { IsUsing_Snow_Wood = t_shouldUse; }
    else if (t_alteration.ToLower() == "[rally]") { IsUsing_Rally_ = t_shouldUse; }
    else if (t_alteration.ToLower() == "[rally] carswitch") { IsUsing_Rally_Carswitch = t_shouldUse; }
    else if (t_alteration.ToLower() == "[rally] cp1 is end") { IsUsing_Rally_CP1_is_End = t_shouldUse; }
    else if (t_alteration.ToLower() == "[rally] underwater") { IsUsing_Rally_Underwater = t_shouldUse; }
    else if (t_alteration.ToLower() == "[rally] ice") { IsUsing_Rally_Icy = t_shouldUse; }

    else if (t_alteration.ToLower() == "100% wet icy wood") { IsUsing_100WetIcyWood = t_shouldUse; }
    else if (t_alteration.ToLower() == "checkpointless reverse") { IsUsing_Checkpointless_Reverse = t_shouldUse; }
    else if (t_alteration.ToLower() == "ice reactor") { IsUsing_Icy_Reactor = t_shouldUse; }
    else if (t_alteration.ToLower() == "ice reverse") { IsUsing_Ice_Reverse = t_shouldUse; }
    else if (t_alteration.ToLower() == "ice reverse reactor") { IsUsing_Ice_Reverse_Reactor = t_shouldUse; }
    else if (t_alteration.ToLower() == "ice short") { IsUsing_Ice_Short = t_shouldUse; }
    else if (t_alteration.ToLower() == "magnet reverse") { IsUsing_Magnet_Reverse = t_shouldUse; }
    else if (t_alteration.ToLower() == "plastic reverse") { IsUsing_Plastic_Reverse = t_shouldUse; }
    else if (t_alteration.ToLower() == "sky is the finish reverse") { IsUsing_Sky_is_the_Finish_Reverse = t_shouldUse; }
    else if (t_alteration.ToLower() == "start water 2 up 1 left checkpoints unlinked finish 2 down 1 right") { IsUsing_sw2u1l_cpu_f2d1r = t_shouldUse; }
    else if (t_alteration.ToLower() == "sw2u1l cpu f2d1r") { IsUsing_sw2u1l_cpu_f2d1r; }
    else if (t_alteration.ToLower() == "underwater reverse") { IsUsing_Underwater_Reverse = t_shouldUse; }
    else if (t_alteration.ToLower() == "wet plastic") { IsUsing_Wet_Plastic = t_shouldUse; }
    else if (t_alteration.ToLower() == "wet wood") { IsUsing_Wet_Wood = t_shouldUse; }
    else if (t_alteration.ToLower() == "wet icy wood") { IsUsing_Wet_Icy_Wood = t_shouldUse; }
    else if (t_alteration.ToLower() == "yeet max up") { IsUsing_Yeet_Max_Up = t_shouldUse; }
    else if (t_alteration.ToLower() == "yeet puzzle") { IsUsing_YEET_Puzzle = t_shouldUse; }
    else if (t_alteration.ToLower() == "yeet random puzzle") { IsUsing_YEET_Random_Puzzle = t_shouldUse; }
    else if (t_alteration.ToLower() == "yeet reverse") { IsUsing_YEET_Reverse = t_shouldUse; }

    else if (t_alteration.ToLower() == "xx-but") { IsUsing_XX_But = t_shouldUse; }
    else if (t_alteration.ToLower() == "flat / 2d") { IsUsing_Flat_2D = t_shouldUse; }
    else if (t_alteration.ToLower() == "a08") { IsUsing_A08 = t_shouldUse; }
    else if (t_alteration.ToLower() == "altered camera") { IsUsing_Altered_Camera = t_shouldUse; }
    else if (t_alteration.ToLower() == "antiboosters") { IsUsing_Antibooster = t_shouldUse; }
    else if (t_alteration.ToLower() == "backwards") { IsUsing_Backwards = t_shouldUse; }
    else if (t_alteration.ToLower() == "blind (altered camera)") { IsUsing_Blind = t_shouldUse; }
    else if (t_alteration.ToLower() == "boosterless") { IsUsing_Boosterless = t_shouldUse; }
    else if (t_alteration.ToLower() == "boss / overlayed") { IsUsing_BOSS = t_shouldUse; }
    else if (t_alteration.ToLower() == "broken") { IsUsing_Broken = t_shouldUse; }
    else if (t_alteration.ToLower() == "bumper") { IsUsing_Bumper = t_shouldUse; }
    else if (t_alteration.ToLower() == "checkpoin't") { IsUsing_Checkpoin_t = t_shouldUse; }
    else if (t_alteration.ToLower() == "cleaned") { IsUsing_Cleaned = t_shouldUse; }
    else if (t_alteration.ToLower() == "colour combined") { IsUsing_Colours_Combined = t_shouldUse; }
    else if (t_alteration.ToLower() == "cp/boost swap") { IsUsing_CP_Boost = t_shouldUse; }
    else if (t_alteration.ToLower() == "cp1 kept") { IsUsing_CP1_Kept = t_shouldUse; }
    else if (t_alteration.ToLower() == "cpfull") { IsUsing_CPfull = t_shouldUse; }
    else if (t_alteration.ToLower() == "cpless") { IsUsing_Checkpointless = t_shouldUse; }
    else if (t_alteration.ToLower() == "cplink") { IsUsing_CPLink = t_shouldUse; }
    else if (t_alteration.ToLower() == "got rotated / cps rotated 90°") { IsUsing_Got_Rotated_CPs_Rotated_90__ = t_shouldUse; }
    else if (t_alteration.ToLower() == "earthquake") { IsUsing_Earthquake = t_shouldUse; }
    else if (t_alteration.ToLower() == "egocentrism (altered camera)") { IsUsing_Egocentrism = t_shouldUse; }
    else if (t_alteration.ToLower() == "fast") { IsUsing_Fast = t_shouldUse; }
    else if (t_alteration.ToLower() == "flipped") { IsUsing_Flipped = t_shouldUse; }
    else if (t_alteration.ToLower() == "holes") { IsUsing_Holes = t_shouldUse; }
    else if (t_alteration.ToLower() == "lunatic") { IsUsing_Lunatic = t_shouldUse; }
    else if (t_alteration.ToLower() == "mini rpg") { IsUsing_Mini_RPG = t_shouldUse; }
    else if (t_alteration.ToLower() == "mirrored") { IsUsing_Mirrored = t_shouldUse; }
    else if (t_alteration.ToLower() == "ngolo / cacti") { IsUsing_Ngolo_Cacti = t_shouldUse; }
    else if (t_alteration.ToLower() == "no cut") { IsUsing_No_Cut = t_shouldUse; }
    else if (t_alteration.ToLower() == "pool hunters") { IsUsing_Pool_Hunters = t_shouldUse; }
    else if (t_alteration.ToLower() == "random") { IsUsing_Random = t_shouldUse; }
    else if (t_alteration.ToLower() == "ring cp") { IsUsing_Ring_CP = t_shouldUse; }
    else if (t_alteration.ToLower() == "scuba diving") { IsUsing_Scuba_Diving = t_shouldUse; }
    else if (t_alteration.ToLower() == "sections joined") { IsUsing_Sections_joined = t_shouldUse; }
    else if (t_alteration.ToLower() == "select del") { IsUsing_Select_DEL = t_shouldUse; }
    else if (t_alteration.ToLower() == "speedlimit") { IsUsing_Speedlimit = t_shouldUse; }
    else if (t_alteration.ToLower() == "start 1 down") { IsUsing_Start_1_Down = t_shouldUse; }
    else if (t_alteration.ToLower() == "staircase") { IsUsing_Staircase = t_shouldUse; }
    else if (t_alteration.ToLower() == "supersized") { IsUsing_Supersized = t_shouldUse; }
    else if (t_alteration.ToLower() == "straight to the finish") { IsUsing_Straight_to_the_Finish = t_shouldUse; }
    else if (t_alteration.ToLower() == "symmetrical") { IsUsing_Symmetrical = t_shouldUse; }
    else if (t_alteration.ToLower() == "tilted") { IsUsing_Tilted = t_shouldUse; }
    else if (t_alteration.ToLower() == "walmart mini") { IsUsing_Walmart_Mini = t_shouldUse; }
    else if (t_alteration.ToLower() == "yeet") { IsUsing_YEET = t_shouldUse; }
    else if (t_alteration.ToLower() == "yeet down") { IsUsing_YEET_Down = t_shouldUse; }

    else if (t_alteration.ToLower() == "training") { IsUsing_Trainig = t_shouldUse; }
    else if (t_alteration.ToLower() == "tmgl / tmwt easy mode") { IsUsing_TMGL_Easy = t_shouldUse; }
    else if (t_alteration.ToLower() == "competitions (with alterations)") { IsUsing__AllOfficialCompetitions = t_shouldUse; }
    else if (t_alteration.ToLower() == "competitions (without alterations)") { IsUsing_AllOfficialCompetitions = t_shouldUse; }
    else if (t_alteration.ToLower() == "unaltered nadeo") { IsUsing_OfficialNadeo = t_shouldUse; }
    else if (t_alteration.ToLower() == "altered totd") { IsUsing_AllTOTD = t_shouldUse; }

    else if (t_alteration.ToLower() == "spring 2020") { IsUsing_Spring2020Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "summer 2020") { IsUsing_Summer2020Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "fall 2020") { IsUsing_Fall2020Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "winter 2021") { IsUsing_Winter2021Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "spring 2021") { IsUsing_Spring2021Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "summer 2021") { IsUsing_Summer2021Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "fall 2021") { IsUsing_Fall2021Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "winter 2022") { IsUsing_Winter2022Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "spring 2022") { IsUsing_Spring2022Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "summer 2022") { IsUsing_Summer2022Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "fall 2022") { IsUsing_Fall2022Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "winter 2023") { IsUsing_Winter2023Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "spring 2023") { IsUsing_Spring2023Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "summer 2023") { IsUsing_Summer2023Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "fall 2023") { IsUsing_Fall2023Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "winter 2024") { IsUsing_Winter2024Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "spring 2024") { IsUsing_Spring2024Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "summer 2024") { IsUsing_Summer2024Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "fall 2024") { IsUsing_Fall2024Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "winter 2025") { IsUsing_Winter2025Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "spring 2025") { IsUsing_Spring2025Maps = t_shouldUse; }
    else if (t_alteration.ToLower() == "summer 2025") { IsUsing_Summer2025Maps = t_shouldUse; }
}

void SetFullSeason(const string &in t_fullSeason, bool t_shouldUse) {
    if (t_fullSeason.ToLower() == "winter") { IsUsing_Winter2021Maps = t_shouldUse; 
                                              IsUsing_Winter2022Maps = t_shouldUse; 
                                              IsUsing_Winter2023Maps = t_shouldUse; 
                                              IsUsing_Winter2024Maps = t_shouldUse; 
                                              IsUsing_Winter2025Maps = t_shouldUse; }
    else if (t_fullSeason.ToLower() == "spring") { IsUsing_Spring2020Maps = t_shouldUse; 
                                                   IsUsing_Spring2021Maps = t_shouldUse; 
                                                   IsUsing_Spring2022Maps = t_shouldUse; 
                                                   IsUsing_Spring2023Maps = t_shouldUse; 
                                                   IsUsing_Spring2024Maps = t_shouldUse; 
                                                   IsUsing_Spring2025Maps = t_shouldUse; }
    else if (t_fullSeason.ToLower() == "summer") { IsUsing_Summer2020Maps = t_shouldUse; 
                                                   IsUsing_Summer2021Maps = t_shouldUse; 
                                                   IsUsing_Summer2022Maps = t_shouldUse; 
                                                   IsUsing_Summer2023Maps = t_shouldUse; 
                                                   IsUsing_Summer2024Maps = t_shouldUse; 
                                                   IsUsing_Summer2025Maps = t_shouldUse; }
    else if (t_fullSeason.ToLower() == "fall") { IsUsing_Fall2020Maps = t_shouldUse; 
                                                 IsUsing_Fall2021Maps = t_shouldUse; 
                                                 IsUsing_Fall2022Maps = t_shouldUse; 
                                                 IsUsing_Fall2023Maps = t_shouldUse; 
                                                 IsUsing_Fall2024Maps = t_shouldUse; }
}