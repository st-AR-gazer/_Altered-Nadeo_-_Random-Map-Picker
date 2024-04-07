bool placeholderValue;
bool showInterface;

int activeTab = 0;

void RenderInterface() {
    if (!showInterface) return;

    UI::Begin(ColorizeString("Altered") + " " + ColorizeString("Nadeo") + "\\$z Random Map Picker Settings", showInterface, UI::WindowFlags::AlwaysAutoResize);

    if (UI::Button("Open Map")) { 
        if (useStorageObjectOverUID) {
            LoadMapFromStorageObject();
        } else {
            LoadMapFromUIDProxy();
        }
    }

    UI::Separator();

    // Active TABS

    // Row 1: Main Settings
    if (UI::Button("General Settings")) activeTab = 0;
    UI::SameLine();
    if (UI::Button("General Alteration Settings")) activeTab = 1;

    // if (activeMainTab == 0) {
    //     UI::Text("AAAAAAAAAAAAAAAAAAAAA");
    // } else if (activeMainTab == 1) {
    //     UI::Text("BBBBBBBBBBBBBBBBBBBBB");
    // }

    UI::Separator();

    // Row 2: Seasonal Alterations
    if (UI::Button("Winter")) activeTab = 2;
    UI::SameLine();
    if (UI::Button("Spring")) activeTab = 3;
    UI::SameLine();
    if (UI::Button("Summer")) activeTab = 4;
    UI::SameLine();
    if (UI::Button("Fall")) activeTab = 5;
    UI::SameLine();
    if (UI::Button("Seasonal Other")) activeTab = 6;
    UI::SameLine();
    if (UI::Button("Discovery Campaigns")) activeTab = 7;

    UI::Separator();

    // Row 3: Alterational Alterations
    if (UI::Button("Surfaces")) activeTab = 8;
    UI::SameLine();
    if (UI::Button("Effects")) activeTab = 9;
    UI::SameLine();
    if (UI::Button("Finish Location")) activeTab = 10;
    UI::SameLine();
    if (UI::Button("Enviroments")) activeTab = 11;
    UI::SameLine();
    if (UI::Button("Multi")) activeTab = 12;
    UI::SameLine();
    if (UI::Button("Other")) activeTab = 13;
    UI::SameLine();
    if (UI::Button("Extra")) activeTab = 14;


    switch (activeTab) {
        case 0:
            RenderGeneralSettings();
            break;
        case 1:
            RenderGeneralAlterationSettings();
            break;
        case 2:
            RenderWinter();
            break;
        case 3:
            RenderSpring();
            break;
        case 4:
            RenderSummer();
            break;
        case 5:
            RenderFall();
            break;
        case 6:
            RenderSeasonalOther();
            break;
        case 7:
            RenderDiscoveryCampaigns();
            break;
        case 8:
            RenderSurfaces();
            break;
        case 9:
            RenderEffects();
            break;
        case 10:
            RenderFinishLocation();
            break;
        case 11:
            RenderEnviroments();
            break;
        case 12:
            RenderMulti();
            break;
        case 13:
            RenderAlterationalOther();
            break;
        case 14:
            RenderExtra();
            break;
        
    }

    UI::End();
}




void RenderGeneralSettings() { 
    UI::Text("All the altered nadeo general settings");

    // bool newValue;


}

void RenderGeneralAlterationSettings() { 
    UI::Text("All the altered nadeo general alteration settings");

    bool newValue;

    newValue = UI::Checkbox("Use Storage Object Over UID", useStorageObjectOverUID);
    if (newValue != useStorageObjectOverUID) { useStorageObjectOverUID = newValue; }

    // set maximum AT / gold / silver / bronze times

    if (UI::Button("Enable All settings")) {
        SelectAllSettings();
    }

    if (UI::Button("Disable All settings")) {
        DeselectAllSettings();
    }
    
    
}



void RenderWinter() { 
    UI::Text('Content for "Winter"');

    bool newValue;

    newValue = UI::Checkbox('Winter 2021', IsUsing_Winter2021Maps);
    if (newValue != IsUsing_Winter2021Maps) { IsUsing_Winter2021Maps = newValue; }
    
    newValue = UI::Checkbox('Winter 2022', IsUsing_Winter2022Maps);
    if (newValue != IsUsing_Winter2022Maps) { IsUsing_Winter2022Maps = newValue; }
    
    newValue = UI::Checkbox('Winter 2023', IsUsing_Winter2023Maps);
    if (newValue != IsUsing_Winter2023Maps) { IsUsing_Winter2023Maps = newValue; }
    
    newValue = UI::Checkbox('Winter 2024', IsUsing_Winter2024Maps);
    if (newValue != IsUsing_Winter2024Maps) { IsUsing_Winter2024Maps = newValue; }
    
    newValue = UI::Checkbox('Winter 2025', IsUsing_Winter2025Maps);
    if (newValue != IsUsing_Winter2025Maps) { IsUsing_Winter2025Maps = newValue; }

    if (UI::Button("Enable All winter maps settings")) { SelectWinter(); }

    if (UI::Button("Disable All winter maps settings")) { DeselectWinter(); }
}

void RenderSpring() { 
    UI::Text('Content for "Spring"');

    bool newValue;

    newValue = UI::Checkbox('Spring 2020', IsUsing_Spring2020Maps);
    if (newValue != IsUsing_Spring2020Maps) { IsUsing_Spring2020Maps = newValue; }

    newValue = UI::Checkbox('Spring 2021', IsUsing_Spring2021Maps);
    if (newValue != IsUsing_Spring2021Maps) { IsUsing_Spring2021Maps = newValue; }
    
    newValue = UI::Checkbox('Spring 2022', IsUsing_Spring2022Maps);
    if (newValue != IsUsing_Spring2022Maps) { IsUsing_Spring2022Maps = newValue; }
    
    newValue = UI::Checkbox('Spring 2023', IsUsing_Spring2023Maps);
    if (newValue != IsUsing_Spring2023Maps) { IsUsing_Spring2023Maps = newValue; }
    
    newValue = UI::Checkbox('Spring 2024', IsUsing_Spring2024Maps);
    if (newValue != IsUsing_Spring2024Maps) { IsUsing_Spring2024Maps = newValue; }
    
    newValue = UI::Checkbox('Spring 2025', IsUsing_Spring2025Maps);
    if (newValue != IsUsing_Spring2025Maps) { IsUsing_Spring2025Maps = newValue; }

    if (UI::Button("Enable All spring maps settings")) { SelectSpring(); }

    if (UI::Button("Disable All spring maps settings")) { DeselectSpring(); }
}

void RenderSummer() { 
    UI::Text('Content for "Summer"');

    bool newValue;

    newValue = UI::Checkbox('Summer 2020', IsUsing_Summer2020Maps);
    if (newValue != IsUsing_Summer2020Maps) { IsUsing_Summer2020Maps = newValue; }
    
    newValue = UI::Checkbox('Summer 2021', IsUsing_Summer2021Maps);
    if (newValue != IsUsing_Summer2021Maps) { IsUsing_Summer2021Maps = newValue; }
    
    newValue = UI::Checkbox('Summer 2022', IsUsing_Summer2022Maps);
    if (newValue != IsUsing_Summer2022Maps) { IsUsing_Summer2022Maps = newValue; }
    
    newValue = UI::Checkbox('Summer 2023', IsUsing_Summer2023Maps);
    if (newValue != IsUsing_Summer2023Maps) { IsUsing_Summer2023Maps = newValue; }
    
    newValue = UI::Checkbox('Summer 2024', IsUsing_Summer2024Maps);
    if (newValue != IsUsing_Summer2024Maps) { IsUsing_Summer2024Maps = newValue; }

    if (UI::Button("Enable All summer maps settings")) { SelectSummer(); }

    if (UI::Button("Disable All summer maps settings")) { DeselectSummer(); }
}

void RenderFall() { 
    UI::Text('Content for "Fall"');

    bool newValue;

    newValue = UI::Checkbox('Fall 2020', IsUsing_Fall2020Maps);
    if (newValue != IsUsing_Fall2020Maps) { IsUsing_Fall2020Maps = newValue; }
    
    newValue = UI::Checkbox('Fall 2021', IsUsing_Fall2021Maps);
    if (newValue != IsUsing_Fall2021Maps) { IsUsing_Fall2021Maps = newValue; }
    
    newValue = UI::Checkbox('Fall 2022', IsUsing_Fall2022Maps);
    if (newValue != IsUsing_Fall2022Maps) { IsUsing_Fall2022Maps = newValue; }
    
    newValue = UI::Checkbox('Fall 2023', IsUsing_Fall2023Maps);
    if (newValue != IsUsing_Fall2023Maps) { IsUsing_Fall2023Maps = newValue; }
    
    newValue = UI::Checkbox('Fall 2024', IsUsing_Fall2024Maps);
    if (newValue != IsUsing_Fall2024Maps) { IsUsing_Fall2024Maps = newValue; }

    if (UI::Button("Enable All fall maps settings")) { SelectFall(); }

    if (UI::Button("Disable All fall maps settings")) { DeselectFall(); }
}

void RenderSeasonalOther() {
    UI::Text("All the altered nadeo seasonal alterations");

    bool newValue;

    newValue = UI::Checkbox('Official Nadeo Maps', IsUsing_OfficialNadeo);
    if (newValue != IsUsing_OfficialNadeo) { IsUsing_OfficialNadeo = newValue; }
    
    newValue = UI::Checkbox('Altered TOTD', IsUsing_AllTOTD);
    if (newValue != IsUsing_AllTOTD) { IsUsing_AllTOTD = newValue; }
    
    newValue = UI::Checkbox('Training', IsUsing_Trainig);
    if (newValue != IsUsing_Trainig) { IsUsing_Trainig = newValue; }
    
    newValue = UI::Checkbox('Official TMGL / TMWR maps', IsUsing__AllOfficialCompetitions);
    if (newValue != IsUsing__AllOfficialCompetitions) { IsUsing__AllOfficialCompetitions = newValue; }

    if (UI::Button("Enable All seasonal maps settings")) { DeselectOrSelectAllSeasons(true); }

    if (UI::Button("Disable All seasonal maps settings")) { DeselectOrSelectAllSeasons(false); }
}

void RenderDiscoveryCampaigns() {
    UI::Text("All the altered nadeo car discovery campaign alterations");

    bool newValue;

    newValue = UI::Checkbox('Snow Discovery', IsUsing_AllSnowDiscovery);
    if (newValue != IsUsing_AllSnowDiscovery) { IsUsing_AllSnowDiscovery = newValue; }
    
    newValue = UI::Checkbox('Rally Discovery', IsUsing_AllRallyDiscovery);
    if (newValue != IsUsing_AllRallyDiscovery) { IsUsing_AllRallyDiscovery = newValue; }

    if (UI::Button("Enable All discovery campaign settings")) { SelectDiscoveryCampaigns(); }

    if (UI::Button("Disable All discovery campaign settings")) { DeselectDiscoveryCampaigns(); }
}


void RenderSurfaces() {
    UI::Text("All the altered nadeo surface alterations");

    bool newValue;

    newValue = UI::Checkbox("Dirt", IsUsing_Dirt);
    if (newValue != IsUsing_Dirt) { IsUsing_Dirt = newValue; }

    newValue = UI::Checkbox("Fast-Magnet", IsUsing_Fast_Magnet);
    if (newValue != IsUsing_Fast_Magnet) { IsUsing_Fast_Magnet = newValue; }
    
    newValue = UI::Checkbox("Flooded", IsUsing_Flooded);
    if (newValue != IsUsing_Flooded) { IsUsing_Flooded = newValue; }
    
    newValue = UI::Checkbox("Grass", IsUsing_Grass);
    if (newValue != IsUsing_Grass) { IsUsing_Grass = newValue; }
    
    newValue = UI::Checkbox("Ice", IsUsing_Ice);
    if (newValue != IsUsing_Ice) { IsUsing_Ice = newValue; }
    
    newValue = UI::Checkbox("Magnet", IsUsing_Magnet);
    if (newValue != IsUsing_Magnet) { IsUsing_Magnet = newValue; }
    
    newValue = UI::Checkbox("Mixed", IsUsing_Mixed);
    if (newValue != IsUsing_Mixed) { IsUsing_Mixed = newValue; }

    newValue = UI::Checkbox("Penalty", IsUsing_Penalty);
    if (newValue != IsUsing_Penalty) { IsUsing_Penalty = newValue; }

    newValue = UI::Checkbox("Plastic", IsUsing_Plastic);
    if (newValue != IsUsing_Plastic) { IsUsing_Plastic = newValue; }

    newValue = UI::Checkbox("Road", IsUsing_Wood);
    if (newValue != IsUsing_Wood) { IsUsing_Wood = newValue; }

    newValue = UI::Checkbox("Bobsleigh", IsUsing_Bobsleigh);
    if (newValue != IsUsing_Bobsleigh) { IsUsing_Bobsleigh = newValue; }
    
    newValue = UI::Checkbox("Pipe", IsUsing_Pipe);
    if (newValue != IsUsing_Pipe) { IsUsing_Pipe = newValue; }
    
    newValue = UI::Checkbox("Sausage", IsUsing_Sausage);
    if (newValue != IsUsing_Sausage) { IsUsing_Sausage = newValue; }
    
    newValue = UI::Checkbox("Surfaceless", IsUsing_Surfaceless);
    if (newValue != IsUsing_Surfaceless) { IsUsing_Surfaceless = newValue; }
    
    newValue = UI::Checkbox("Underwater", IsUsing_Underwater);
    if (newValue != IsUsing_Underwater) { IsUsing_Underwater = newValue; }

    if (UI::Button("Enable All surface settings")) { SelectAlteredSurface(); }

    if (UI::Button("Disable All surface settings")) { DeselectAlteredSurface(); }
}

void RenderEffects() { 
    UI::Text('All the altered nadeo effect alterations');

    bool newValue;

    newValue = UI::Checkbox('Cruise', IsUsing_Cruise);
    if (newValue != IsUsing_Cruise) { IsUsing_Cruise = newValue; }
    
    newValue = UI::Checkbox('Fragile', IsUsing_Fragile);
    if (newValue != IsUsing_Fragile) { IsUsing_Fragile = newValue; }
    
    newValue = UI::Checkbox('Freewheel', IsUsing_Freewheel);
    if (newValue != IsUsing_Freewheel) { IsUsing_Freewheel = newValue; }
    
    newValue = UI::Checkbox('Glider', IsUsing_Glider);
    if (newValue != IsUsing_Glider) { IsUsing_Glider = newValue; }
    
    newValue = UI::Checkbox('No-Brake', IsUsing_No_Brakes);
    if (newValue != IsUsing_No_Brakes) { IsUsing_No_Brakes = newValue; }

    newValue = UI::Checkbox('No-Effect', IsUsing_No_Effects);
    if (newValue != IsUsing_No_Effects) { IsUsing_No_Effects = newValue; }
    
    newValue = UI::Checkbox('No-Grip', IsUsing_No_Grip);
    if (newValue != IsUsing_No_Grip) { IsUsing_No_Grip = newValue; }
    
    newValue = UI::Checkbox('No-Steer', IsUsing_No_Steer);
    if (newValue != IsUsing_No_Steer) { IsUsing_No_Steer = newValue; }
    
    newValue = UI::Checkbox('Random Dankness', IsUsing_Random_Dankness);
    if (newValue != IsUsing_Random_Dankness) { IsUsing_Random_Dankness = newValue; }
    
    newValue = UI::Checkbox('Random Effects', IsUsing_Random_Effects);
    if (newValue != IsUsing_Random_Effects) { IsUsing_Random_Effects = newValue; }
    
    newValue = UI::Checkbox('Reactor', IsUsing_Reactor);
    if (newValue != IsUsing_Reactor) { IsUsing_Reactor = newValue; }
    
    newValue = UI::Checkbox('Reactor Down', IsUsing_Reactor_Down);
    if (newValue != IsUsing_Reactor_Down) { IsUsing_Reactor_Down = newValue; }
    
    newValue = UI::Checkbox('Slowmo', IsUsing_Slowmo);
    if (newValue != IsUsing_Slowmo) { IsUsing_Slowmo = newValue; }
    
    newValue = UI::Checkbox('Wet Wheels', IsUsing_Wet_Wheels);
    if (newValue != IsUsing_Wet_Wheels) { IsUsing_Wet_Wheels = newValue; }
    
    newValue = UI::Checkbox('Worn Tires', IsUsing_Worn_Tires);
    if (newValue != IsUsing_Worn_Tires) { IsUsing_Worn_Tires = newValue; }

    if (UI::Button("Enable All effect settings")) { SelectAlteredEffects(); }

    if (UI::Button("Disable All effect settings")) { DeselectAlteredEffects(); }
}

void RenderFinishLocation() { 
    UI::Text('All the altered nadeo finish location alterations');

    bool newValue;

    newValue = UI::Checkbox('1-Down', IsUsing_1Down);
    if (newValue != IsUsing_1Down) { IsUsing_1Down = newValue; }

    newValue = UI::Checkbox('1-Back / 1-Forwards', IsUsing_1Back);
    if (newValue != IsUsing_1Back) { IsUsing_1Back = newValue; }

    newValue = UI::Checkbox('1-Left', IsUsing_1Left);
    if (newValue != IsUsing_1Left) { IsUsing_1Left = newValue; }

    newValue = UI::Checkbox('1-Right', IsUsing_1Right);
    if (newValue != IsUsing_1Right) { IsUsing_1Right = newValue; }

    newValue = UI::Checkbox('1-UP', IsUsing_1Up);
    if (newValue != IsUsing_1Up) { IsUsing_1Up = newValue; }

    newValue = UI::Checkbox('2-UP', IsUsing_2Up);
    if (newValue != IsUsing_2Up) { IsUsing_2Up = newValue; }

    newValue = UI::Checkbox('Better Reverse', IsUsing_Better_Reverse);
    if (newValue != IsUsing_Better_Reverse) { IsUsing_Better_Reverse = newValue; }

    newValue = UI::Checkbox('CP1 is End', IsUsing_CP1_is_End);
    if (newValue != IsUsing_CP1_is_End) { IsUsing_CP1_is_End = newValue; }

    newValue = UI::Checkbox('Floor Fin', IsUsing_Floor_Fin);
    if (newValue != IsUsing_Floor_Fin) { IsUsing_Floor_Fin = newValue; }

    newValue = UI::Checkbox('Manslaoughter', IsUsing_Manslaughter);
    if (newValue != IsUsing_Manslaughter) { IsUsing_Manslaughter = newValue; }

    newValue = UI::Checkbox('No-Gear-5', IsUsing_No_Gear_5);
    if (newValue != IsUsing_No_Gear_5) { IsUsing_No_Gear_5 = newValue; }

    newValue = UI::Checkbox('Podium', IsUsing_Podium);
    if (newValue != IsUsing_Podium) { IsUsing_Podium = newValue; }

    newValue = UI::Checkbox('Puzzle', IsUsing_Puzzle);
    if (newValue != IsUsing_Puzzle) { IsUsing_Puzzle = newValue; }

    newValue = UI::Checkbox('Reverse', IsUsing_Reverse);
    if (newValue != IsUsing_Reverse) { IsUsing_Reverse = newValue; }

    newValue = UI::Checkbox('Roofing', IsUsing_Roofing);
    if (newValue != IsUsing_Roofing) { IsUsing_Roofing = newValue; }

    newValue = UI::Checkbox('Short', IsUsing_Short);
    if (newValue != IsUsing_Short) { IsUsing_Short = newValue; }

    newValue = UI::Checkbox('Sky is the Finish', IsUsing_Sky_is_the_Finish);
    if (newValue != IsUsing_Sky_is_the_Finish) { IsUsing_Sky_is_the_Finish = newValue; }

    newValue = UI::Checkbox('There and Back', IsUsing_There_and_Back_Boomerang);
    if (newValue != IsUsing_There_and_Back_Boomerang) { IsUsing_There_and_Back_Boomerang = newValue; }

    newValue = UI::Checkbox('YEP-Tree Puzzle', IsUsing_YEP_Tree_Puzzle);
    if (newValue != IsUsing_YEP_Tree_Puzzle) { IsUsing_YEP_Tree_Puzzle = newValue; }

    newValue = UI::Checkbox('Inclined', IsUsing_Inclined);
    if (newValue != IsUsing_Inclined) { IsUsing_Inclined = newValue; }

    if (UI::Button("Enable All finish location settings")) { SelectAlteredFinishLocation(); }

    if (UI::Button("Disable All finish location settings")) { DeselectAlteredFinishLocation(); }
}

void RenderEnviroments() { 
    UI::Text('All the altered nadeo envimix alterations');

    bool newValue;

    newValue = UI::Checkbox('[Stadium]', IsUsing_Stadium_);
    if (newValue != IsUsing_Stadium_) { IsUsing_Stadium_ = newValue; }
    
    newValue = UI::Checkbox('[Stadium] Wet Wood', IsUsing_Stadium_Wet_Wood);
    if (newValue != IsUsing_Stadium_Wet_Wood) { IsUsing_Stadium_Wet_Wood = newValue; }
    
    newValue = UI::Checkbox('[Snow]', IsUsing_Snow_);
    if (newValue != IsUsing_Snow_) { IsUsing_Snow_ = newValue; }
    
    newValue = UI::Checkbox('[Snow] Carswitch', IsUsing_Snow_Carswitch);
    if (newValue != IsUsing_Snow_Carswitch) { IsUsing_Snow_Carswitch = newValue; }
    
    newValue = UI::Checkbox('[Snow] Checkpointless', IsUsing_Snow_Checkpointless);
    if (newValue != IsUsing_Snow_Checkpointless) { IsUsing_Snow_Checkpointless = newValue; }
    
    newValue = UI::Checkbox('[Snow] Icy', IsUsing_Snow_Icy);
    if (newValue != IsUsing_Snow_Icy) { IsUsing_Snow_Icy = newValue; }
    
    newValue = UI::Checkbox('[Snow] Underwater', IsUsing_Snow_Underwater);
    if (newValue != IsUsing_Snow_Underwater) { IsUsing_Snow_Underwater = newValue; }
    
    newValue = UI::Checkbox('[Snow] Wet-Plastic', IsUsing_Snow_Wet_Plastic);
    if (newValue != IsUsing_Snow_Wet_Plastic) { IsUsing_Snow_Wet_Plastic = newValue; }
    
    newValue = UI::Checkbox('[Snow] Wood', IsUsing_Snow_Wood);
    if (newValue != IsUsing_Snow_Wood) { IsUsing_Snow_Wood = newValue; }
    
    newValue = UI::Checkbox('[Rally]', IsUsing_Rally_);
    if (newValue != IsUsing_Rally_) { IsUsing_Rally_ = newValue; }
    
    newValue = UI::Checkbox('[Rally] CP1 is End', IsUsing_Rally_CP1_is_End);
    if (newValue != IsUsing_Rally_CP1_is_End) { IsUsing_Rally_CP1_is_End = newValue; }
    
    newValue = UI::Checkbox('[Rally] Underwater', IsUsing_Rally_Underwater);
    if (newValue != IsUsing_Rally_Underwater) { IsUsing_Rally_Underwater = newValue; }

    if (UI::Button("Enable All enviroment settings")) { SelectAlteredEnviroments(); }

    if (UI::Button("Disable All enviroment settings")) { DeselectAlteredEnviroments(); }
}

void RenderMulti() { 
    UI::Text('All the altered nadeo multi alterations');

    bool newValue;

    newValue = UI::Checkbox('Checkpointless Reverse', IsUsing_Checkpointless_Reverse);
    if (newValue != IsUsing_Checkpointless_Reverse) { IsUsing_Checkpointless_Reverse = newValue; }
    
    newValue = UI::Checkbox('Icy Reverse', IsUsing_Ice_Reverse);
    if (newValue != IsUsing_Ice_Reverse) { IsUsing_Ice_Reverse = newValue; }
    
    newValue = UI::Checkbox('Icy Reverse Reactor', IsUsing_Ice_Reverse_Reactor);
    if (newValue != IsUsing_Ice_Reverse_Reactor) { IsUsing_Ice_Reverse_Reactor = newValue; }
    
    newValue = UI::Checkbox('Icy Short', IsUsing_Ice_Short);
    if (newValue != IsUsing_Ice_Short) { IsUsing_Ice_Short = newValue; }
    
    newValue = UI::Checkbox('Magnet Reverse', IsUsing_Magnet_Reverse);
    if (newValue != IsUsing_Magnet_Reverse) { IsUsing_Magnet_Reverse = newValue; }
    
    newValue = UI::Checkbox('Plastic Reverse', IsUsing_Plastic_Reverse);
    if (newValue != IsUsing_Plastic_Reverse) { IsUsing_Plastic_Reverse = newValue; }
    
    newValue = UI::Checkbox('Sky is the Finish Reverse', IsUsing_Sky_is_the_Finish_Reverse);
    if (newValue != IsUsing_Sky_is_the_Finish_Reverse) { IsUsing_Sky_is_the_Finish_Reverse = newValue; }
    
    newValue = UI::Checkbox('sw2u1l-cpu-f2d1r', IsUsing_sw2u1l_cpu_f2d1r);
    if (newValue != IsUsing_sw2u1l_cpu_f2d1r) { IsUsing_sw2u1l_cpu_f2d1r = newValue; }
    
    newValue = UI::Checkbox('Underwater Reverse', IsUsing_Underwater_Reverse);
    if (newValue != IsUsing_Underwater_Reverse) { IsUsing_Underwater_Reverse = newValue; }
    
    newValue = UI::Checkbox('Wet Plastic', IsUsing_Wet_Plastic);
    if (newValue != IsUsing_Wet_Plastic) { IsUsing_Wet_Plastic = newValue; }
    
    newValue = UI::Checkbox('Wet Wood', IsUsing_Wet_Wood);
    if (newValue != IsUsing_Wet_Wood) { IsUsing_Wet_Wood = newValue; }
    
    newValue = UI::Checkbox('Wet Icy Wood', IsUsing_Wet_Icy_Wood);
    if (newValue != IsUsing_Wet_Icy_Wood) { IsUsing_Wet_Icy_Wood = newValue; }
    
    newValue = UI::Checkbox('YEET Max-UP', IsUsing_Yeet_Max_Up);
    if (newValue != IsUsing_Yeet_Max_Up) { IsUsing_Yeet_Max_Up = newValue; }
    
    newValue = UI::Checkbox('YEET Puzzle', IsUsing_YEET_Puzzle);
    if (newValue != IsUsing_YEET_Puzzle) { IsUsing_YEET_Puzzle = newValue; }
    
    newValue = UI::Checkbox('YEET Random Puzzle', IsUsing_YEET_Random_Puzzle);
    if (newValue != IsUsing_YEET_Random_Puzzle) { IsUsing_YEET_Random_Puzzle = newValue; }
    
    newValue = UI::Checkbox('YEET Reverse', IsUsing_YEET_Reverse);
    if (newValue != IsUsing_YEET_Reverse) { IsUsing_YEET_Reverse = newValue; }

    if (UI::Button("Enable All multi settings")) { SelectAlteredMulti(); }

    if (UI::Button("Disable All multi settings")) { DeselectAlteredMulti(); }
}

void RenderAlterationalOther() { 
    UI::Text("All the altered nadeo 'other' alterations");

    bool newValue;

    newValue = UI::Checkbox('XX-But', IsUsing_XX_But);
    if (newValue != IsUsing_XX_But) { IsUsing_XX_But = newValue; }
    
    newValue = UI::Checkbox('Flat / 2D', IsUsing_Flat_2D);
    if (newValue != IsUsing_Flat_2D) { IsUsing_Flat_2D = newValue; }
    
    newValue = UI::Checkbox('a08', IsUsing_A08);
    if (newValue != IsUsing_A08) { IsUsing_A08 = newValue; }
    
    if (!isUsingStorageObjectOverAPI) {
        newValue = UI::Checkbox('Altered Camera', IsUsing_Altered_Camera);
        if (newValue != IsUsing_Altered_Camera) { IsUsing_Altered_Camera = newValue; }
    }

    newValue = UI::Checkbox('Antibooster', IsUsing_Antibooster);
    if (newValue != IsUsing_Antibooster) { IsUsing_Antibooster = newValue; }
    
    newValue = UI::Checkbox('Backwards', IsUsing_Backwards);
    if (newValue != IsUsing_Backwards) { IsUsing_Backwards = newValue; }
    
    if (isUsingStorageObjectOverAPI) {
        newValue = UI::Checkbox('Blind', IsUsing_Blind);
        if (newValue != IsUsing_Blind) { IsUsing_Blind = newValue; }
    }
    
    newValue = UI::Checkbox('Boosterless', IsUsing_Boosterless);
    if (newValue != IsUsing_Boosterless) { IsUsing_Boosterless = newValue; }
    
    newValue = UI::Checkbox('BOSS', IsUsing_BOSS);
    if (newValue != IsUsing_BOSS) { IsUsing_BOSS = newValue; }
    
    newValue = UI::Checkbox('Broken', IsUsing_Broken);
    if (newValue != IsUsing_Broken) { IsUsing_Broken = newValue; }
    
    newValue = UI::Checkbox('Bumper', IsUsing_Bumper);
    if (newValue != IsUsing_Bumper) { IsUsing_Bumper = newValue; }
    
    newValue = UI::Checkbox('Cacti / Ngolo', IsUsing_Ngolo_Cacti);
    if (newValue != IsUsing_Ngolo_Cacti) { IsUsing_Ngolo_Cacti = newValue; }
    
    newValue = UI::Checkbox("Checkpoin't", IsUsing_Checkpoin_t);
    if (newValue != IsUsing_Checkpoin_t) { IsUsing_Checkpoin_t = newValue; }
    
    newValue = UI::Checkbox('Cleaned', IsUsing_Cleaned);
    if (newValue != IsUsing_Cleaned) { IsUsing_Cleaned = newValue; }
    
    newValue = UI::Checkbox('Colours Combined', IsUsing_Colours_Combined);
    if (newValue != IsUsing_Colours_Combined) { IsUsing_Colours_Combined = newValue; }
    
    newValue = UI::Checkbox('CP Boost Swap', IsUsing_CP_Boost);
    if (newValue != IsUsing_CP_Boost) { IsUsing_CP_Boost = newValue; }
    
    newValue = UI::Checkbox('CP1 Kept', IsUsing_CP1_Kept);
    if (newValue != IsUsing_CP1_Kept) { IsUsing_CP1_Kept = newValue; }
    
    newValue = UI::Checkbox('CPfull', IsUsing_CPfull);
    if (newValue != IsUsing_CPfull) { IsUsing_CPfull = newValue; }
    
    newValue = UI::Checkbox('Checkpointless', IsUsing_Checkpointless);
    if (newValue != IsUsing_Checkpointless) { IsUsing_Checkpointless = newValue; }
    
    newValue = UI::Checkbox('CPlink', IsUsing_CPLink);
    if (newValue != IsUsing_CPLink) { IsUsing_CPLink = newValue; }
    
    newValue = UI::Checkbox('Got Rotated / CPs Rotated 90°', IsUsing_Got_Rotated_CPs_Rotated_90__);
    if (newValue != IsUsing_Got_Rotated_CPs_Rotated_90__) { IsUsing_Got_Rotated_CPs_Rotated_90__ = newValue; }
    
    newValue = UI::Checkbox('Earthquake', IsUsing_Earthquake);
    if (newValue != IsUsing_Earthquake) { IsUsing_Earthquake = newValue; }
    
    newValue = UI::Checkbox('Egocentrism', IsUsing_Egocentrism);
    if (newValue != IsUsing_Egocentrism) { IsUsing_Egocentrism = newValue; }
    
    newValue = UI::Checkbox('Fast', IsUsing_Fast);
    if (newValue != IsUsing_Fast) { IsUsing_Fast = newValue; }
    
    newValue = UI::Checkbox('Flipped', IsUsing_Flipped);
    if (newValue != IsUsing_Flipped) { IsUsing_Flipped = newValue; }
    
    newValue = UI::Checkbox('Holes', IsUsing_Holes);
    if (newValue != IsUsing_Holes) { IsUsing_Holes = newValue; }
    
    newValue = UI::Checkbox('Lunatic', IsUsing_Lunatic);
    if (newValue != IsUsing_Lunatic) { IsUsing_Lunatic = newValue; }
    
    newValue = UI::Checkbox('Mini RPG', IsUsing_Mini_RPG);
    if (newValue != IsUsing_Mini_RPG) { IsUsing_Mini_RPG = newValue; }
    
    newValue = UI::Checkbox('Mirrored', IsUsing_Mirrored);
    if (newValue != IsUsing_Mirrored) { IsUsing_Mirrored = newValue; }
    
    newValue = UI::Checkbox('Pool Hunters', IsUsing_Pool_Hunters);
    if (newValue != IsUsing_Pool_Hunters) { IsUsing_Pool_Hunters = newValue; }
    
    newValue = UI::Checkbox('Random', IsUsing_Random);
    if (newValue != IsUsing_Random) { IsUsing_Random = newValue; }
    
    newValue = UI::Checkbox('Ring CP', IsUsing_Ring_CP);
    if (newValue != IsUsing_Ring_CP) { IsUsing_Ring_CP = newValue; }
    
    newValue = UI::Checkbox('Sections Joined', IsUsing_Sections_joined);
    if (newValue != IsUsing_Sections_joined) { IsUsing_Sections_joined = newValue; }
    
    newValue = UI::Checkbox('Select DEL', IsUsing_Select_DEL);
    if (newValue != IsUsing_Select_DEL) { IsUsing_Select_DEL = newValue; }
    
    newValue = UI::Checkbox('Speedlimit', IsUsing_Speedlimit);
    if (newValue != IsUsing_Speedlimit) { IsUsing_Speedlimit = newValue; }
    
    if (isUsingStorageObjectOverAPI) {
        newValue = UI::Checkbox('Staircase', IsUsing_Staircase);
        if (newValue != IsUsing_Staircase) { IsUsing_Staircase = newValue; }
    }

    newValue = UI::Checkbox('Start 1-Down', IsUsing_Start_1_Down);
    if (newValue != IsUsing_Start_1_Down) { IsUsing_Start_1_Down = newValue; }
    
    newValue = UI::Checkbox('Supersized', IsUsing_Supersized);
    if (newValue != IsUsing_Supersized) { IsUsing_Supersized = newValue; }
    
    newValue = UI::Checkbox('Straight to the Finish', IsUsing_Straight_to_the_Finish);
    if (newValue != IsUsing_Straight_to_the_Finish) { IsUsing_Straight_to_the_Finish = newValue; }
    
    newValue = UI::Checkbox('Symmetrical', IsUsing_Symmetrical);
    if (newValue != IsUsing_Symmetrical) { IsUsing_Symmetrical = newValue; }
    
    newValue = UI::Checkbox('Tilted', IsUsing_Tilted);
    if (newValue != IsUsing_Tilted) { IsUsing_Tilted = newValue; }

    if (isUsingStorageObjectOverAPI) {
        newValue = UI::Checkbox('Walmart Mini', IsUsing_Walmart_Mini);
        if (newValue != IsUsing_Walmart_Mini) { IsUsing_Walmart_Mini = newValue; }
    }
    
    newValue = UI::Checkbox('YEET', IsUsing_YEET);
    if (newValue != IsUsing_YEET) { IsUsing_YEET = newValue; }
    
    newValue = UI::Checkbox('YEET Down', IsUsing_YEET_Down);
    if (newValue != IsUsing_YEET_Down) { IsUsing_YEET_Down = newValue; }

    if (UI::Button("Enable All other settings")) { SelectAlteredOther(); }

    if (UI::Button("Disable All other settings")) { DeselectAlteredOther(); }
}

void RenderExtra() { 
    UI::Text('All the altered nadeo extra alterations');

    bool newValue;

    newValue = UI::Checkbox('Training', IsUsing_Trainig);
    if (newValue != IsUsing_Trainig) { IsUsing_Trainig = newValue; }
    
    newValue = UI::Checkbox('Alterations of Official Competitions (TMGL, TMWT)', IsUsing_AllOfficialCompetitions);
    if (newValue != IsUsing_AllOfficialCompetitions) { IsUsing_AllOfficialCompetitions = newValue; }
    
    newValue = UI::Checkbox('Official Nadeo', IsUsing_OfficialNadeo);
    if (newValue != IsUsing_OfficialNadeo) { IsUsing_OfficialNadeo = newValue; }
    
    newValue = UI::Checkbox('Altered TOTD', IsUsing_AllTOTD);
    if (newValue != IsUsing_AllTOTD) { IsUsing_AllTOTD = newValue; }

    if (UI::Button("Enable All extra settings")) { SelectAlteredExtraCampaigns(); }

    if (UI::Button("Disable All extra settings")) { DeselectAlteredExtraCampaigns(); }
}