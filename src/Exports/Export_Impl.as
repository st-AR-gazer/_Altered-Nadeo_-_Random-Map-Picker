string GetARandomAltMapUid() {
    string t_uid = GetRandomUID();
    return t_uid;
}

string GetARandomAltMapStorageObject() {
    string t_storageObject = FetchRandomMapUrl();
    return t_storageObject;
}

Json::Value GetUserSettings() {
    Json::Value settings = Json::Object();

    // Type

    settings["Type"] = Json::Object();
    settings["Type"]["Race"] = IsUsing_Race_Maps;
    settings["Type"]["Stunt"] = IsUsing_Stunt_Maps;

    // Score
    settings["Score"] = Json::Object();
    settings["Score"]["Author"] = Json::Object();
    settings["Score"]["Gold"] = Json::Object();
    settings["Score"]["Silver"] = Json::Object();
    settings["Score"]["Bronze"] = Json::Object();

    settings["Score"]["Author"]["Max"] = IsUsing_authorScoreMax;
    settings["Score"]["Author"]["Min"] = IsUsing_authorScoreMin;
    settings["Score"]["Gold"]["Max"] = IsUsing_goldScoreMax;
    settings["Score"]["Gold"]["Min"] = IsUsing_goldScoreMin;
    settings["Score"]["Silver"]["Max"] = IsUsing_silverScoreMax;
    settings["Score"]["Silver"]["Min"] = IsUsing_silverScoreMin;
    settings["Score"]["Bronze"]["Max"] = IsUsing_bronzeScoreMax;
    settings["Score"]["Bronze"]["Min"] = IsUsing_bronzeScoreMin;

    // Alterations
    settings["Alterations"] = Json::Object();
    // Altered Surface
    settings["Alterations"]["Surface"] = Json::Object();

    settings["Alterations"]["Surface"]["Dirt"] = IsUsing_Dirt;
    settings["Alterations"]["Surface"]["Fast Magnet"] = IsUsing_Fast_Magnet;
    settings["Alterations"]["Surface"]["Flooded"] = IsUsing_Flooded;
    settings["Alterations"]["Surface"]["Grass"] = IsUsing_Grass;
    settings["Alterations"]["Surface"]["Ice"] = IsUsing_Ice;
    settings["Alterations"]["Surface"]["Magnet"] = IsUsing_Magnet;
    settings["Alterations"]["Surface"]["Mixed"] = IsUsing_Mixed;
    settings["Alterations"]["Surface"]["Better Mixed"] = IsUsing_Better_Mixed;
    settings["Alterations"]["Surface"]["Penalty"] = IsUsing_Penalty;
    settings["Alterations"]["Surface"]["Plastic"] = IsUsing_Plastic;
    settings["Alterations"]["Surface"]["Road"] = IsUsing_Road;
    settings["Alterations"]["Surface"]["Road Dirt"] = IsUsing_Road_Dirt;
    settings["Alterations"]["Surface"]["Wood"] = IsUsing_Wood;
    settings["Alterations"]["Surface"]["Bobsleigh"] = IsUsing_Bobsleigh;
    settings["Alterations"]["Surface"]["Pipe"] = IsUsing_Pipe;
    settings["Alterations"]["Surface"]["Platform"] = IsUsing_Platform;
    settings["Alterations"]["Surface"]["Sausage"] = IsUsing_Sausage;
    settings["Alterations"]["Surface"]["Slot Track"] = IsUsing_Slot_Track;
    settings["Alterations"]["Surface"]["Surfaceless"] = IsUsing_Surfaceless;
    settings["Alterations"]["Surface"]["Underwater"] = IsUsing_Underwater;

    // Altered Effects
    settings["Alterations"]["Effects"] = Json::Object();

    settings["Alterations"]["Effects"]["Cruise"] = IsUsing_Cruise;
    settings["Alterations"]["Effects"]["Fragile"] = IsUsing_Fragile;
    settings["Alterations"]["Effects"]["Full Fragile"] = IsUsing_Full_Fragile;
    settings["Alterations"]["Effects"]["Freewheel"] = IsUsing_Freewheel;
    settings["Alterations"]["Effects"]["Glider"] = IsUsing_Glider;
    settings["Alterations"]["Effects"]["No Brake"] = IsUsing_No_Brakes;
    settings["Alterations"]["Effects"]["No Effect"] = IsUsing_No_Effects;
    settings["Alterations"]["Effects"]["No Grip"] = IsUsing_No_Grip;
    settings["Alterations"]["Effects"]["No Steering"] = IsUsing_No_Steer;
    settings["Alterations"]["Effects"]["Random Dankness"] = IsUsing_Random_Dankness;
    settings["Alterations"]["Effects"]["Random Effects"] = IsUsing_Random_Effects;
    settings["Alterations"]["Effects"]["Reactor (Up)"] = IsUsing_Reactor;
    settings["Alterations"]["Effects"]["Reactor Down"] = IsUsing_Reactor_Down;
    settings["Alterations"]["Effects"]["Red Effects"] = IsUsing_Red_Effects;
    settings["Alterations"]["Effects"]["RNG Booster"] = IsUsing_RNG_Booster;
    settings["Alterations"]["Effects"]["Slowmo"] = IsUsing_Slowmo;
    settings["Alterations"]["Effects"]["Wet Wheels"] = IsUsing_Wet_Wheels;
    settings["Alterations"]["Effects"]["Worn Tires"] = IsUsing_Worn_Tires;
    
    // Altered Finish Location
    settings["Alterations"]["Finish Location"] = Json::Object();

    settings["Alterations"]["Finish Location"]["1 Down"] = IsUsing_1Down;
    settings["Alterations"]["Finish Location"]["1 Back / Forward"] = IsUsing_1Back;
    settings["Alterations"]["Finish Location"]["1 Left"] = IsUsing_1Left;
    settings["Alterations"]["Finish Location"]["1 Right"] = IsUsing_1Right;
    settings["Alterations"]["Finish Location"]["1 Up"] = IsUsing_1Up;
    settings["Alterations"]["Finish Location"]["2 Up"] = IsUsing_2Up;
    settings["Alterations"]["Finish Location"]["Better Reverse / Reverse Magna"] = IsUsing_Better_Reverse;
    settings["Alterations"]["Finish Location"]["CP1 is End"] = IsUsing_CP1_is_End;
    settings["Alterations"]["Finish Location"]["Floor Fin"] = IsUsing_Floor_Fin;
    settings["Alterations"]["Finish Location"]["Mansloughter"] = IsUsing_Manslaughter;
    settings["Alterations"]["Finish Location"]["No Gear 5"] = IsUsing_No_Gear_5;
    settings["Alterations"]["Finish Location"]["Podium"] = IsUsing_Podium;
    settings["Alterations"]["Finish Location"]["Puzzle"] = IsUsing_Puzzle;
    settings["Alterations"]["Finish Location"]["Reverse"] = IsUsing_Reverse;
    settings["Alterations"]["Finish Location"]["Roofing"] = IsUsing_Roofing;
    settings["Alterations"]["Finish Location"]["Short"] = IsUsing_Short;
    settings["Alterations"]["Finish Location"]["Sky is the Finish"] = IsUsing_Sky_is_the_Finish;
    settings["Alterations"]["Finish Location"]["There and Back / Boomerang"] = IsUsing_There_and_Back_Boomerang;
    settings["Alterations"]["Finish Location"]["YEP Tree Puzzle"] = IsUsing_YEP_Tree_Puzzle;
    settings["Alterations"]["Finish Location"]["Inclined"] = IsUsing_Inclined;

    // Altered Environment (Envimix)
    settings["Alterations"]["Environment"] = Json::Object();

    settings["Alterations"]["Environment"]["[Stadium]"] = IsUsing_Stadium_;
    settings["Alterations"]["Environment"]["[Stadium] Wet Wood"] = IsUsing_Stadium_Wet_Wood;
    settings["Alterations"]["Environment"]["[Snow]"] = IsUsing_Snow_;
    settings["Alterations"]["Environment"]["[Snow] Carswitch"] = IsUsing_Snow_Carswitch;
    settings["Alterations"]["Environment"]["[Snow] Checkpointless"] = IsUsing_Snow_Checkpointless;
    settings["Alterations"]["Environment"]["[Snow] Ice"] = IsUsing_Snow_Icy;
    settings["Alterations"]["Environment"]["[Snow] Underwater"] = IsUsing_Snow_Underwater;
    settings["Alterations"]["Environment"]["[Snow] Wet Plastic"] = IsUsing_Snow_Wet_Plastic;
    settings["Alterations"]["Environment"]["[Snow] Wood"] = IsUsing_Snow_Wood;
    settings["Alterations"]["Environment"]["[Rally]"] = IsUsing_Rally_;
    settings["Alterations"]["Environment"]["[Rally] Carswitch"] = IsUsing_Rally_Carswitch;
    settings["Alterations"]["Environment"]["[Rally] CP1 is End"] = IsUsing_Rally_CP1_is_End;
    settings["Alterations"]["Environment"]["[Rally] Underwater"] = IsUsing_Rally_Underwater;
    settings["Alterations"]["Environment"]["[Rally] Ice"] = IsUsing_Rally_Icy;
    settings["Alterations"]["Environment"]["[Desert]"] = IsUsing_Desert_;
    settings["Alterations"]["Environment"]["[Desert] Carswitch"] = IsUsing_Desert_Carswitch;
    settings["Alterations"]["Environment"]["[Desert] Underwater"] = IsUsing_Desert_Underwater;

    // Altered Game Modes
    settings["Alterations"]["Game Modes"] = Json::Object();

    settings["Alterations"]["Game Modes"]["[Race]"] = IsUsing_Race_;
    settings["Alterations"]["Game Modes"]["[Stunt]"] = IsUsing_Stunt_;

    // Multi Alterationss
    settings["Alterations"]["Multi"] = Json::Object();

    settings["Alterations"]["Multi"]["100% Wet Icy Wood"] = IsUsing_100WetIcyWood;
    settings["Alterations"]["Multi"]["Checkpointless Reverse"] = IsUsing_Checkpointless_Reverse;
    settings["Alterations"]["Multi"]["Ice Reactor"] = IsUsing_Icy_Reactor;
    settings["Alterations"]["Multi"]["Ice Reverse"] = IsUsing_Ice_Reverse;
    settings["Alterations"]["Multi"]["Ice Reverse Reactor"] = IsUsing_Ice_Reverse_Reactor;
    settings["Alterations"]["Multi"]["Ice Short"] = IsUsing_Ice_Short;
    settings["Alterations"]["Multi"]["Magnet Reverse"] = IsUsing_Magnet_Reverse;
    settings["Alterations"]["Multi"]["Plastic Reverse"] = IsUsing_Plastic_Reverse;
    settings["Alterations"]["Multi"]["Sky is the Finish Reverse"] = IsUsing_Sky_is_the_Finish_Reverse;
    settings["Alterations"]["Multi"]["Start Water 2 Up 1 Left Checkpoints Unlinked Finish 2 Down 1 Right"] = IsUsing_sw2u1l_cpu_f2d1r;
    settings["Alterations"]["Multi"]["Underwater Reverse"] = IsUsing_Underwater_Reverse;
    settings["Alterations"]["Multi"]["Wet Plastic"] = IsUsing_Wet_Plastic;
    settings["Alterations"]["Multi"]["Wet Wood"] = IsUsing_Wet_Wood;
    settings["Alterations"]["Multi"]["Wet Icy Wood"] = IsUsing_Wet_Icy_Wood;
    settings["Alterations"]["Multi"]["YEET Max Up"] = IsUsing_Yeet_Max_Up;
    settings["Alterations"]["Multi"]["YEET Puzzle"] = IsUsing_YEET_Puzzle;
    settings["Alterations"]["Multi"]["YEET Random Puzzle"] = IsUsing_YEET_Random_Puzzle;
    settings["Alterations"]["Multi"]["YEET Reverse"] = IsUsing_YEET_Reverse;

    // Other Alterationss
    settings["Alterations"]["Other"] = Json::Object();

    settings["Alterations"]["Other"]["XX-But"] = IsUsing_XX_But;
    settings["Alterations"]["Other"]["Flat / 2D"] = IsUsing_Flat_2D;
    settings["Alterations"]["Other"]["a08"] = IsUsing_A08;
    settings["Alterations"]["Other"]["Altered Camera"] = IsUsing_Altered_Camera;
    settings["Alterations"]["Other"]["Antiboosters"] = IsUsing_Antibooster;
    settings["Alterations"]["Other"]["Backwards"] = IsUsing_Backwards;
    settings["Alterations"]["Other"]["Blind (Altered Camera)"] = IsUsing_Blind;
    settings["Alterations"]["Other"]["Boosterless"] = IsUsing_Boosterless;
    settings["Alterations"]["Other"]["BOSS / Overlayed"] = IsUsing_BOSS;
    settings["Alterations"]["Other"]["Broken"] = IsUsing_Broken;
    settings["Alterations"]["Other"]["Bumper"] = IsUsing_Bumper;
    settings["Alterations"]["Other"]["Checkpoin't"] = IsUsing_Checkpoin_t;
    settings["Alterations"]["Other"]["Cleaned"] = IsUsing_Cleaned;
    settings["Alterations"]["Other"]["Colour Combined"] = IsUsing_Colours_Combined;
    settings["Alterations"]["Other"]["CP/Boost Swap"] = IsUsing_CP_Boost;
    settings["Alterations"]["Other"]["CP1 Kept"] = IsUsing_CP1_Kept;
    settings["Alterations"]["Other"]["CPfull"] = IsUsing_CPfull;
    settings["Alterations"]["Other"]["CPLess"] = IsUsing_Checkpointless;
    settings["Alterations"]["Other"]["CPLink"] = IsUsing_CPLink;
    settings["Alterations"]["Other"]["Got Rotated / CPs Rotated 90°"] = IsUsing_Got_Rotated_CPs_Rotated_90__;
    settings["Alterations"]["Other"]["Earthquake"] = IsUsing_Earthquake;
    settings["Alterations"]["Other"]["Egocentrism (Altered Camera)"] = IsUsing_Egocentrism;
    settings["Alterations"]["Other"]["Fast"] = IsUsing_Fast;
    settings["Alterations"]["Other"]["Flipped"] = IsUsing_Flipped;
    settings["Alterations"]["Other"]["Ground Clippers"] = IsUsing_Ground_Clippers;
    settings["Alterations"]["Other"]["Holes"] = IsUsing_Holes;
    settings["Alterations"]["Other"]["Lunatic"] = IsUsing_Lunatic;
    settings["Alterations"]["Other"]["Mini RPG"] = IsUsing_Mini_RPG;
    settings["Alterations"]["Other"]["Mirrored"] = IsUsing_Mirrored;
    settings["Alterations"]["Other"]["No Itmes"] = IsUsing_No_Items;
    settings["Alterations"]["Other"]["Ngolo / Cacti"] = IsUsing_Ngolo_Cacti;
    settings["Alterations"]["Other"]["No Cut"] = IsUsing_No_Cut;
    settings["Alterations"]["Other"]["Pool Hunters"] = IsUsing_Pool_Hunters;
    settings["Alterations"]["Other"]["Random"] = IsUsing_Random;
    settings["Alterations"]["Other"]["Replay"] = IsUsing_Replay;
    settings["Alterations"]["Other"]["Ring CP"] = IsUsing_Ring_CP;
    settings["Alterations"]["Other"]["Scuba Diving"] = IsUsing_Scuba_Diving;
    settings["Alterations"]["Other"]["Sections Joined"] = IsUsing_Sections_joined;
    settings["Alterations"]["Other"]["Select DEL"] = IsUsing_Select_DEL;
    settings["Alterations"]["Other"]["Speedlimit"] = IsUsing_Speedlimit;
    settings["Alterations"]["Other"]["Start 1 Down"] = IsUsing_Start_1_Down;
    settings["Alterations"]["Other"]["Staircase"] = IsUsing_Staircase;
    settings["Alterations"]["Other"]["Supersized"] = IsUsing_Supersized;
    settings["Alterations"]["Other"]["Straight to the Finish"] = IsUsing_Straight_to_the_Finish;
    settings["Alterations"]["Other"]["Stunt"] = IsUsing_Stunt;
    settings["Alterations"]["Other"]["Symmetrical"] = IsUsing_Symmetrical;
    settings["Alterations"]["Other"]["Tilted"] = IsUsing_Tilted;
    settings["Alterations"]["Other"]["Walmart Mini"] = IsUsing_Walmart_Mini;
    settings["Alterations"]["Other"]["YEET"] = IsUsing_YEET;
    settings["Alterations"]["Other"]["YEET Down"] = IsUsing_YEET_Down;

    // Extra Campaigns
    settings["Alterations"]["Extra Campaigns"] = Json::Object();

    settings["Alterations"]["Extra Campaigns"]["Training"] = IsUsing_Trainig;
    settings["Alterations"]["Extra Campaigns"]["TMGL / TMWT Easy mode"] = IsUsing_TMGL_Easy;
    settings["Alterations"]["Extra Campaigns"]["Competitions (With Alterations)"] = IsUsing__AllOfficialCompetitions;
    settings["Alterations"]["Extra Campaigns"]["Competitions (Without Alterations)"] = IsUsing_AllOfficialCompetitions;
    settings["Alterations"]["Extra Campaigns"]["Unaltered Nadeo"] = IsUsing_OfficialNadeo;
    settings["Alterations"]["Extra Campaigns"]["Altered TOTD"] = IsUsing_AllTOTD;

    // Seasons
    settings["Seasons"] = Json::Object();

    settings["Seasons"]["Spring 2020"] = IsUsing_Spring2020Maps;
    settings["Seasons"]["Summer 2020"] = IsUsing_Summer2020Maps;
    settings["Seasons"]["Fall 2020"] = IsUsing_Fall2020Maps;
    settings["Seasons"]["Winter 2021"] = IsUsing_Winter2021Maps;
    settings["Seasons"]["Spring 2021"] = IsUsing_Spring2021Maps;
    settings["Seasons"]["Summer 2021"] = IsUsing_Summer2021Maps;
    settings["Seasons"]["Fall 2021"] = IsUsing_Fall2021Maps;
    settings["Seasons"]["Winter 2022"] = IsUsing_Winter2022Maps;
    settings["Seasons"]["Spring 2022"] = IsUsing_Spring2022Maps;
    settings["Seasons"]["Summer 2022"] = IsUsing_Summer2022Maps;
    settings["Seasons"]["Fall 2022"] = IsUsing_Fall2022Maps;
    settings["Seasons"]["Winter 2023"] = IsUsing_Winter2023Maps;
    settings["Seasons"]["Spring 2023"] = IsUsing_Spring2023Maps;
    settings["Seasons"]["Summer 2023"] = IsUsing_Summer2023Maps;
    settings["Seasons"]["Fall 2023"] = IsUsing_Fall2023Maps;
    settings["Seasons"]["Winter 2024"] = IsUsing_Winter2024Maps;
    settings["Seasons"]["Spring 2024"] = IsUsing_Spring2024Maps;
    settings["Seasons"]["Summer 2024"] = IsUsing_Summer2024Maps;
    settings["Seasons"]["Fall 2024"] = IsUsing_Fall2024Maps;
    settings["Seasons"]["Winter 2025"] = IsUsing_Winter2025Maps;
    settings["Seasons"]["Spring 2025"] = IsUsing_Spring2025Maps;
    settings["Seasons"]["Summer 2025"] = IsUsing_Summer2025Maps;

    settings["Seasons"]["Discovery"] = Json::Object();

    settings["Seasons"]["Discovery"]["Snow"] = IsUsing_AllSnowDiscovery;
    settings["Seasons"]["Discovery"]["Rally"] = IsUsing_AllRallyDiscovery;
    settings["Seasons"]["Discovery"]["Desert"] = IsUsing_AllDesertDiscovery;

    // Not on the discord
    // settings["Alterations"]["Not on Discord"]["Hard"] = IsUsing_Hard; // Is actally Lunatic

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
    else if (t_alteration.ToLower() == "slot track") { IsUsing_Slot_Track = t_shouldUse; }
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
    else if (t_alteration.ToLower() == "red effects") { IsUsing_Red_Effects = t_shouldUse; }
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

    else if (t_alteration.ToLower() == "[Race]") { IsUsing_Race_ = t_shouldUse; }
    else if (t_alteration.ToLower() == "[Stunt]") { IsUsing_Stunt_ = t_shouldUse; }

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
    else if (t_alteration.ToLower() == "ground clippers") { IsUsing_Ground_Clippers = t_shouldUse; }
    else if (t_alteration.ToLower() == "holes") { IsUsing_Holes = t_shouldUse; }
    else if (t_alteration.ToLower() == "lunatic") { IsUsing_Lunatic = t_shouldUse; }
    else if (t_alteration.ToLower() == "mini rpg") { IsUsing_Mini_RPG = t_shouldUse; }
    else if (t_alteration.ToLower() == "mirrored") { IsUsing_Mirrored = t_shouldUse; }
    else if (t_alteration.ToLower() == "no itmes") { IsUsing_No_Items = t_shouldUse; }
    else if (t_alteration.ToLower() == "ngolo / cacti") { IsUsing_Ngolo_Cacti = t_shouldUse; }
    else if (t_alteration.ToLower() == "no cut") { IsUsing_No_Cut = t_shouldUse; }
    else if (t_alteration.ToLower() == "pool hunters") { IsUsing_Pool_Hunters = t_shouldUse; }
    else if (t_alteration.ToLower() == "random") { IsUsing_Random = t_shouldUse; }
    else if (t_alteration.ToLower() == "replay") { IsUsing_Replay = t_shouldUse; }
    else if (t_alteration.ToLower() == "ring cp") { IsUsing_Ring_CP = t_shouldUse; }
    else if (t_alteration.ToLower() == "scuba diving") { IsUsing_Scuba_Diving = t_shouldUse; }
    else if (t_alteration.ToLower() == "sections joined") { IsUsing_Sections_joined = t_shouldUse; }
    else if (t_alteration.ToLower() == "select del") { IsUsing_Select_DEL = t_shouldUse; }
    else if (t_alteration.ToLower() == "speedlimit") { IsUsing_Speedlimit = t_shouldUse; }
    else if (t_alteration.ToLower() == "start 1 down") { IsUsing_Start_1_Down = t_shouldUse; }
    else if (t_alteration.ToLower() == "staircase") { IsUsing_Staircase = t_shouldUse; }
    else if (t_alteration.ToLower() == "supersized") { IsUsing_Supersized = t_shouldUse; }
    else if (t_alteration.ToLower() == "straight to the finish") { IsUsing_Straight_to_the_Finish = t_shouldUse; }
    else if (t_alteration.ToLower() == "stunt") { IsUsing_Stunt = t_shouldUse;}
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