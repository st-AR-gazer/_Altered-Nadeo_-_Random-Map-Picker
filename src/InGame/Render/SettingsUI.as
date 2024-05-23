bool placeholderValue;
bool showInterface;

int activeTab = 0;

string g_searchBar = "";

void RenderInterface() {
    if (!showInterface) return;

    if (UI::Begin(_LinCol::ColorizeString("Altered") + " " + _LinCol::ColorizeString("Nadeo") + "\\$z Random Map Picker", showInterface, UI::WindowFlags::AlwaysAutoResize)) {

        if (useStorageObjectOverUID && !IO::FileExists(IO::FromStorageFolder("Data/consolidated_maps.json"))) {
            UI::Text("Using Storage Object is disabled untill consolidated_maps.json is downloaded from ManiaCDN.");
        } 
        if (UI::Button("Open Map")) {
            toOpenMap = true;
        }

        UI::Separator();

        g_searchBar = UI::InputText("##Alteration Search Bar", g_searchBar, UI::InputTextFlags::None);
        UI::SameLine();
        if (UI::Button("Search " + Icons::Search)) activeTab = 15;
        UI::SameLine();
        if (UI::Button("Clear Search " + Icons::TimesCircleO)) g_searchBar = "";

        UI::Separator();

        // Active TABS

        // Row 1: Main Settings
    //  if (UI::Button("General Settings")) activeTab = 0;
    //  UI::SameLine();

        if (UI::Button("General Alteration Settings")) activeTab = 0;
        UI::SameLine();
        if (UI::Button("General Settings")) activeTab = 1;
        UI::SameLine();
        if (UI::Button("Profiles")) activeTab = 98;
        if (shouldOpenDevTab) {
            UI::SameLine();
            if (UI::Button("~Dev")) activeTab = 99;
        }

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

        UI::Separator();

        switch (activeTab) {
            case 1:
                RenderGeneralSettings();
                break;
            case 0:
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
            case 15:
                RenderSearch();
                break;

            case 98:
                RenderProfiles();
                break;
            case 99:
                RenderDev();
                break;
            
        }
    }
    UI::End();
}


void RenderDev() {
    UI::Text("Some dings for diagnosing issues and such");

    if (UI::Button("Copy User settings to clipboard")) {
        Json::Value settings = GetUserSettings();

        string settingsStr = _Json::PrettyPrint(settings);

        IO::SetClipboard(settingsStr);
    }
}

string profileURL = "";
string profileName = "";

void RenderProfiles() {
    UI::Text("Download profiles from URL: ");
    profileURL = UI::InputText("Profile URL", profileURL, UI::InputTextFlags::None);
    if (UI::Button("Download Profile")) {
        Profiles::DownloadProfile(profileURL);
    }
    UI::Separator();

    UI::Text("Create or save profile with current settings: ");
    SimpleTooltip("The profile is created from your current settings.");
    profileName = UI::InputText("Profile Name", profileName, UI::InputTextFlags::None);
    if (UI::Button("Save Current Settings as Profile")) {
        Json::Value settings = Profiles::GetUserSettingsForProfile();
        Profiles::SaveProfile(profileName, settings);
    }
    UI::Separator();

    UI::Text("List of Local Profiles: ");
    array<string> profiles = Profiles::GetLocalProfiles();
    for (uint i = 0; i < profiles.Length; i++) {
        UI::Text("Load Profile " + profiles[i] + ": ");
        if (UI::Button("Load " + profiles[i])) {
            Profiles::LoadProfile(profiles[i]);
        }
    }

    UI::Separator();
    if (UI::Button("Open Profile Folder")) {
        _IO::OpenFolder(IO::FromStorageFolder("Profiles/"));
    }
}

void RenderGeneralSettings() { 
    UI::Text("All the altered nadeo general settings");

    bool newValue;

    newValue = UI::Checkbox('Check for manifest updates', checkForUpdates);
    if (newValue != checkForUpdates) { checkForUpdates = newValue; }
    
    newValue = UI::Checkbox('Open DEV Tab', shouldOpenDevTab);
    if (newValue != shouldOpenDevTab) { shouldOpenDevTab = newValue; }
    
}

void RenderGeneralAlterationSettings() { 
    UI::Text("All the altered nadeo general alteration settings");

    bool newValue;

    newValue = UI::Checkbox("Use Storage Object Over UID", useStorageObjectOverUID);
    if (newValue != useStorageObjectOverUID) { useStorageObjectOverUID = newValue; }
    SimpleTooltip("If enabled, the plugin will use the 'consolidated_maps.json' file to extract the URL. This means that when toggled off this setting will not allow you to select what alteration you want.");

    newValue = UI::Checkbox('CumulativeSelections', shoulduseCumulativeSelections);
    if (newValue != shoulduseCumulativeSelections) { shoulduseCumulativeSelections = newValue; }

    UI::Separator();

    // set maximum AT / gold / silver / bronze times
    UI::Text("Score Settings:");
    SimpleTooltip("The default values are set to '-1' this represents the maximum score possible.");
    IsUsing_authorScoreMin = UI::InputInt("Minimum Author Score", IsUsing_authorScoreMin);
    IsUsing_authorScoreMax = UI::InputInt("Maximum Author Score", IsUsing_authorScoreMax);
    IsUsing_goldScoreMin = UI::InputInt("Minimum Gold Score", IsUsing_goldScoreMin);
    IsUsing_goldScoreMax = UI::InputInt("Maximum Gold Score", IsUsing_goldScoreMax);
    IsUsing_silverScoreMin = UI::InputInt("Minimum Silver Score", IsUsing_silverScoreMin);
    IsUsing_silverScoreMax = UI::InputInt("Maximum Silver Score", IsUsing_silverScoreMax);
    IsUsing_bronzeScoreMin = UI::InputInt("Minimum Bronze Score", IsUsing_bronzeScoreMin);
    IsUsing_bronzeScoreMax = UI::InputInt("Maximum Bronze Score", IsUsing_bronzeScoreMax);
    // 

    if (UI::Button("Enable All settings")) {
        SelectAllSettings();
    }

    if (UI::Button("Disable All settings")) {
        DeselectAllSettings();
    }
}

void SimpleTooltip(const string &in msg) {
    if (UI::IsItemHovered()) {
        UI::SetNextWindowSize(400, 0, UI::Cond::Appearing);
        UI::BeginTooltip();
        UI::TextWrapped(msg);
        UI::EndTooltip();
    }
}


// ###################################### Seasons #############################################################

// ############################################################################################################
void RenderWinter() { 
    UI::Text('All "Winter" Alterations');

    RenderS_Winter2021();
    RenderS_Winter2022();
    RenderS_Winter2023();
    RenderS_Winter2024();
    RenderS_Winter2025();

    if (UI::Button("Enable All winter maps settings")) { SelectWinter(); }
    if (UI::Button("Disable All winter maps settings")) { DeselectWinter(); }
}

void RenderS_Winter2021() { IsUsing_Winter2021Maps = UI::Checkbox("Winter 2021", IsUsing_Winter2021Maps); }
void RenderS_Winter2022() { IsUsing_Winter2022Maps = UI::Checkbox("Winter 2022", IsUsing_Winter2022Maps); }
void RenderS_Winter2023() { IsUsing_Winter2023Maps = UI::Checkbox("Winter 2023", IsUsing_Winter2023Maps); }
void RenderS_Winter2024() { IsUsing_Winter2024Maps = UI::Checkbox("Winter 2024", IsUsing_Winter2024Maps); }
void RenderS_Winter2025() { IsUsing_Winter2025Maps = UI::Checkbox("Winter 2025", IsUsing_Winter2025Maps); }
// ############################################################################################################


// ############################################################################################################
void RenderSpring() { 
    UI::Text('All "Spring" Alterations');

    RenderS_Spring2020();
    RenderS_Spring2021();
    RenderS_Spring2022();
    RenderS_Spring2023();
    RenderS_Spring2024();
    RenderS_Spring2025();

    if (UI::Button("Enable All spring maps settings")) { SelectSpring(); }
    if (UI::Button("Disable All spring maps settings")) { DeselectSpring(); }
}

void RenderS_Spring2020() { IsUsing_Spring2020Maps = UI::Checkbox("Spring 2020", IsUsing_Spring2020Maps); }
void RenderS_Spring2021() { IsUsing_Spring2021Maps = UI::Checkbox("Spring 2021", IsUsing_Spring2021Maps); }
void RenderS_Spring2022() { IsUsing_Spring2022Maps = UI::Checkbox("Spring 2022", IsUsing_Spring2022Maps); }
void RenderS_Spring2023() { IsUsing_Spring2023Maps = UI::Checkbox("Spring 2023", IsUsing_Spring2023Maps); }
void RenderS_Spring2024() { IsUsing_Spring2024Maps = UI::Checkbox("Spring 2024", IsUsing_Spring2024Maps); }
void RenderS_Spring2025() { IsUsing_Spring2025Maps = UI::Checkbox("Spring 2025", IsUsing_Spring2025Maps); }
// ############################################################################################################


// ############################################################################################################
void RenderSummer() { 
    UI::Text('All "Summer" Alterations');

    RenderS_Summer2020();
    RenderS_Summer2021();
    RenderS_Summer2022();
    RenderS_Summer2023();
    RenderS_Summer2024();
    RenderS_Summer2025();

    if (UI::Button("Enable All summer maps settings")) { SelectSummer(); }
    if (UI::Button("Disable All summer maps settings")) { DeselectSummer(); }
}

void RenderS_Summer2020() { IsUsing_Summer2020Maps = UI::Checkbox("Summer 2020", IsUsing_Summer2020Maps); }
void RenderS_Summer2021() { IsUsing_Summer2021Maps = UI::Checkbox("Summer 2021", IsUsing_Summer2021Maps); }
void RenderS_Summer2022() { IsUsing_Summer2022Maps = UI::Checkbox("Summer 2022", IsUsing_Summer2022Maps); }
void RenderS_Summer2023() { IsUsing_Summer2023Maps = UI::Checkbox("Summer 2023", IsUsing_Summer2023Maps); }
void RenderS_Summer2024() { IsUsing_Summer2024Maps = UI::Checkbox("Summer 2024", IsUsing_Summer2024Maps); }
void RenderS_Summer2025() { IsUsing_Summer2025Maps = UI::Checkbox("Summer 2025", IsUsing_Summer2025Maps); }
// ############################################################################################################


// ############################################################################################################
void RenderFall() { 
    UI::Text('All "Fall" Alterations');

    RenderS_Fall2020();
    RenderS_Fall2021();
    RenderS_Fall2022();
    RenderS_Fall2023();
    RenderS_Fall2024();

    if (UI::Button("Enable All fall maps settings")) { SelectFall(); }
    if (UI::Button("Disable All fall maps settings")) { DeselectFall(); }
}

void RenderS_Fall2020() { IsUsing_Fall2020Maps = UI::Checkbox("Fall 2020", IsUsing_Fall2020Maps); }
void RenderS_Fall2021() { IsUsing_Fall2021Maps = UI::Checkbox("Fall 2021", IsUsing_Fall2021Maps); }
void RenderS_Fall2022() { IsUsing_Fall2022Maps = UI::Checkbox("Fall 2022", IsUsing_Fall2022Maps); }
void RenderS_Fall2023() { IsUsing_Fall2023Maps = UI::Checkbox("Fall 2023", IsUsing_Fall2023Maps); }
void RenderS_Fall2024() { IsUsing_Fall2024Maps = UI::Checkbox("Fall 2024", IsUsing_Fall2024Maps); }
// ############################################################################################################


// ############################################################################################################
void RenderSeasonalOther() {
    UI::Text("All the altered nadeo seasonal alterations");

    RenderS_SOfficialNadeo();
    RenderS_STOTD();
    RenderS_STraining();
    RenderS_SOfficialCompetitions();

    if (UI::Button("Enable All seasonal maps settings")) { DeselectOrSelectAllSeasons(true); }
    if (UI::Button("Disable All seasonal maps settings")) { DeselectOrSelectAllSeasons(false); }
}

void RenderS_SOfficialNadeo() {        IsUsing_OfficialNadeo =           UI::Checkbox("Official Nadeo", IsUsing_OfficialNadeo); }
void RenderS_STOTD() {                 IsUsing_AllTOTD =                 UI::Checkbox("TOTD", IsUsing_AllTOTD); }
void RenderS_STraining() {             IsUsing_Trainig =                 UI::Checkbox("Training", IsUsing_Trainig); }
void RenderS_SOfficialCompetitions() { IsUsing_AllOfficialCompetitions = UI::Checkbox("Official Competitions", IsUsing_AllOfficialCompetitions); }
// ############################################################################################################


// ############################################################################################################
void RenderDiscoveryCampaigns() {
    UI::Text("All the altered nadeo car discovery campaign alterations");

    RenderS_SnowDiscovery();
    RenderS_RallyDiscovery();

    if (UI::Button("Enable All discovery campaign settings")) { SelectDiscoveryCampaigns(); }
    if (UI::Button("Disable All discovery campaign settings")) { DeselectDiscoveryCampaigns(); }
}

void RenderS_SnowDiscovery() {  IsUsing_AllSnowDiscovery =  UI::Checkbox("Snow Discovery", IsUsing_AllSnowDiscovery); }
void RenderS_RallyDiscovery() { IsUsing_AllRallyDiscovery = UI::Checkbox("Rally Discovery", IsUsing_AllRallyDiscovery); }
// ############################################################################################################


// ###################################### ALTERATIONS #########################################################


// ############################################################################################################
void RenderSurfaces() {
    UI::Text("All the altered nadeo surface alterations");

    RenderS_Dirt();
    RenderS_Fast_Magnet();
    RenderS_Flooded();
    RenderS_Grass();
    RenderS_Ice();
    RenderS_Magnet();
    RenderS_Mixed();
    RenderS_Better_Mixed();
    RenderS_Penalty();
    RenderS_Plastic();
    RenderS_Road();
    RenderS_Road_Dirt();
    RenderS_Bobsleigh();
    RenderS_Pipe();
    RenderS_Platform();
    RenderS_Sausage();
    RenderS_Surfaceless();
    RenderS_Underwater();

    if (UI::Button("Enable All surface settings")) { SelectAlteredSurface(); }
    if (UI::Button("Disable All surface settings")) { DeselectAlteredSurface(); }
}

void RenderS_Dirt() {         IsUsing_Dirt =         UI::Checkbox("Dirt", IsUsing_Dirt); }
void RenderS_Fast_Magnet() {  IsUsing_Fast_Magnet =  UI::Checkbox("Fast Magnet", IsUsing_Fast_Magnet); }
void RenderS_Flooded() {      IsUsing_Flooded =      UI::Checkbox("Flooded", IsUsing_Flooded); }
void RenderS_Grass() {        IsUsing_Grass =        UI::Checkbox("Grass", IsUsing_Grass); }
void RenderS_Ice() {          IsUsing_Ice =          UI::Checkbox("Ice", IsUsing_Ice); }
void RenderS_Magnet() {       IsUsing_Magnet =       UI::Checkbox("Magnet", IsUsing_Magnet); }
void RenderS_Mixed() {        IsUsing_Mixed =        UI::Checkbox("Mixed", IsUsing_Mixed); }
void RenderS_Better_Mixed() { IsUsing_Better_Mixed = UI::Checkbox("Better Mixed", IsUsing_Better_Mixed); }
void RenderS_Penalty() {      IsUsing_Penalty =      UI::Checkbox("Penalty", IsUsing_Penalty); }
void RenderS_Plastic() {      IsUsing_Plastic =      UI::Checkbox("Plastic", IsUsing_Plastic); }
void RenderS_Road() {         IsUsing_Road =         UI::Checkbox("Road", IsUsing_Road); }
void RenderS_Road_Dirt() {    IsUsing_Road_Dirt =    UI::Checkbox("Road-Dirt", IsUsing_Road_Dirt); }
void RenderS_Bobsleigh() {    IsUsing_Bobsleigh =    UI::Checkbox("Bobsleigh", IsUsing_Bobsleigh); }
void RenderS_Pipe() {         IsUsing_Pipe =         UI::Checkbox("Pipe", IsUsing_Pipe); }
void RenderS_Platform() {     IsUsing_Platform =     UI::Checkbox("Platform", IsUsing_Platform); }
void RenderS_Sausage() {      IsUsing_Sausage =      UI::Checkbox("Sausage", IsUsing_Sausage); }
void RenderS_Surfaceless() {  IsUsing_Surfaceless =  UI::Checkbox("Surfaceless", IsUsing_Surfaceless); }
void RenderS_Underwater() {   IsUsing_Underwater =   UI::Checkbox("Underwater", IsUsing_Underwater); }
// ############################################################################################################


// ############################################################################################################
void RenderEffects() { 
    UI::Text('All the altered nadeo effect alterations');

    RenderS_Cruise();
    RenderS_Fragile();
    RenderS_Freewheel();
    RenderS_Glider();
    RenderS_No_Brakes();
    RenderS_No_Effects();
    RenderS_No_Grip();
    RenderS_No_Steer();
    RenderS_Random_Dankness();
    RenderS_Random_Effects();
    RenderS_Reactor();
    RenderS_Reactor_Down();
    RenderS_RNG_Booster();
    RenderS_Slowmo();
    RenderS_Wet_Wheels();
    RenderS_Worn_Tires();

    if (UI::Button("Enable All effect settings")) { SelectAlteredEffects(); }
    if (UI::Button("Disable All effect settings")) { DeselectAlteredEffects(); }
}

void RenderS_Cruise() {          IsUsing_Cruise =          UI::Checkbox("Cruise", IsUsing_Cruise); }
void RenderS_Fragile() {         IsUsing_Fragile =         UI::Checkbox("Fragile", IsUsing_Fragile); }
void RenderS_Freewheel() {       IsUsing_Freewheel =       UI::Checkbox("Freewheel", IsUsing_Freewheel); }
void RenderS_Glider() {          IsUsing_Glider =          UI::Checkbox("Glider", IsUsing_Glider); }
void RenderS_No_Brakes() {       IsUsing_No_Brakes =       UI::Checkbox("No-Brake", IsUsing_No_Brakes); }
void RenderS_No_Effects() {      IsUsing_No_Effects =      UI::Checkbox("No-Effect", IsUsing_No_Effects); }
void RenderS_No_Grip() {         IsUsing_No_Grip =         UI::Checkbox("No-Grip", IsUsing_No_Grip); }
void RenderS_No_Steer() {        IsUsing_No_Steer =        UI::Checkbox("No-Steer", IsUsing_No_Steer); }
void RenderS_Random_Dankness() { IsUsing_Random_Dankness = UI::Checkbox("Random Dankness", IsUsing_Random_Dankness); }
void RenderS_Random_Effects() {  IsUsing_Random_Effects =  UI::Checkbox("Random Effects", IsUsing_Random_Effects); }
void RenderS_Reactor() {         IsUsing_Reactor =         UI::Checkbox("Reactor", IsUsing_Reactor); }
void RenderS_Reactor_Down() {    IsUsing_Reactor_Down =    UI::Checkbox("Reactor Down", IsUsing_Reactor_Down); }
void RenderS_RNG_Booster() {     IsUsing_RNG_Booster =     UI::Checkbox("RNG-Booster", IsUsing_RNG_Booster); }
void RenderS_Slowmo() {          IsUsing_Slowmo =          UI::Checkbox("Slowmo", IsUsing_Slowmo); }
void RenderS_Wet_Wheels() {      IsUsing_Wet_Wheels =      UI::Checkbox("Wet Wheels", IsUsing_Wet_Wheels); }
void RenderS_Worn_Tires() {      IsUsing_Worn_Tires =      UI::Checkbox("Worn Tires", IsUsing_Worn_Tires); }
// ############################################################################################################


// ############################################################################################################
void RenderFinishLocation() { 
    UI::Text('All the altered nadeo finish location alterations');

    RenderS_1Down();
    RenderS_1Back();
    RenderS_1Left();
    RenderS_1Right();
    RenderS_1Up();
    RenderS_2Up();
    RenderS_Better_Reverse();
    RenderS_CP1_is_End();
    RenderS_Floor_Fin();
    RenderS_Manslaughter();
    RenderS_No_Gear_5();
    RenderS_Podium();
    RenderS_Puzzle();
    RenderS_Reverse();
    RenderS_Roofing();
    RenderS_Short();
    RenderS_Sky_is_the_Finish();
    RenderS_There_and_Back_Boomerang();
    RenderS_YEP_Tree_Puzzle();
    RenderS_Inclined();

    if (UI::Button("Enable All finish location settings")) { SelectAlteredFinishLocation(); }
    if (UI::Button("Disable All finish location settings")) { DeselectAlteredFinishLocation(); }
}

void RenderS_1Down() {                    IsUsing_1Down                    = UI::Checkbox("1-Down", IsUsing_1Down); }
void RenderS_1Back() {                    IsUsing_1Back                    = UI::Checkbox("1-Back / 1-Forwards", IsUsing_1Back); }
void RenderS_1Left() {                    IsUsing_1Left                    = UI::Checkbox("1-Left", IsUsing_1Left); }
void RenderS_1Right() {                   IsUsing_1Right                   = UI::Checkbox("1-Right", IsUsing_1Right); }
void RenderS_1Up() {                      IsUsing_1Up                      = UI::Checkbox("1-UP", IsUsing_1Up); }
void RenderS_2Up() {                      IsUsing_2Up                      = UI::Checkbox("2-UP", IsUsing_2Up); }
void RenderS_Better_Reverse() {           IsUsing_Better_Reverse           = UI::Checkbox("Better Reverse", IsUsing_Better_Reverse); }
void RenderS_CP1_is_End() {               IsUsing_CP1_is_End               = UI::Checkbox("CP1 is End", IsUsing_CP1_is_End); }
void RenderS_Floor_Fin() {                IsUsing_Floor_Fin                = UI::Checkbox("Floor Fin", IsUsing_Floor_Fin); }
void RenderS_Manslaughter() {             IsUsing_Manslaughter             = UI::Checkbox("Manslaoughter", IsUsing_Manslaughter); }
void RenderS_No_Gear_5() {                IsUsing_No_Gear_5                = UI::Checkbox("No-Gear-5", IsUsing_No_Gear_5); }
void RenderS_Podium() {                   IsUsing_Podium                   = UI::Checkbox("Podium", IsUsing_Podium); }
void RenderS_Puzzle() {                   IsUsing_Puzzle                   = UI::Checkbox("Puzzle", IsUsing_Puzzle); }
void RenderS_Reverse() {                  IsUsing_Reverse                  = UI::Checkbox("Reverse", IsUsing_Reverse); }
void RenderS_Roofing() {                  IsUsing_Roofing                  = UI::Checkbox("Roofing", IsUsing_Roofing); }
void RenderS_Short() {                    IsUsing_Short                    = UI::Checkbox("Short", IsUsing_Short); }
void RenderS_Sky_is_the_Finish() {        IsUsing_Sky_is_the_Finish        = UI::Checkbox("Sky is the Finish", IsUsing_Sky_is_the_Finish); }
void RenderS_There_and_Back_Boomerang() { IsUsing_There_and_Back_Boomerang = UI::Checkbox("There and Back", IsUsing_There_and_Back_Boomerang); }
void RenderS_YEP_Tree_Puzzle() {          IsUsing_YEP_Tree_Puzzle          = UI::Checkbox("YEP-Tree Puzzle", IsUsing_YEP_Tree_Puzzle); }
void RenderS_Inclined() {                 IsUsing_Inclined                 = UI::Checkbox("Inclined", IsUsing_Inclined); }
// ############################################################################################################


// ############################################################################################################
void RenderEnviroments() { 
    UI::Text('All the altered nadeo envimix alterations');

    RenderS_Stadium_();
    RenderS_Stadium_Wet_Wood();
    RenderS_Snow_();
    RenderS_Snow_Carswitch();
    RenderS_Snow_Checkpointless();
    RenderS_Snow_Icy();
    RenderS_Snow_Underwater();
    RenderS_Snow_Wet_Plastic();
    RenderS_Snow_Wood();
    RenderS_Rally_();
    RenderS_Rally_CP1_is_End();
    RenderS_Rally_Underwater();

    if (UI::Button("Enable All enviroment settings")) { SelectAlteredEnviroments(); }
    if (UI::Button("Disable All enviroment settings")) { DeselectAlteredEnviroments(); }
}

void RenderS_Stadium_() {            IsUsing_Stadium_ =            UI::Checkbox("[Stadium]", IsUsing_Stadium_); }
void RenderS_Stadium_Wet_Wood() {    IsUsing_Stadium_Wet_Wood =    UI::Checkbox("[Stadium] Wet Wood", IsUsing_Stadium_Wet_Wood); }
void RenderS_Snow_() {               IsUsing_Snow_ =               UI::Checkbox("[Snow]", IsUsing_Snow_); }
void RenderS_Snow_Carswitch() {      IsUsing_Snow_Carswitch =      UI::Checkbox("[Snow] Carswitch", IsUsing_Snow_Carswitch); }
void RenderS_Snow_Checkpointless() { IsUsing_Snow_Checkpointless = UI::Checkbox("[Snow] Checkpointless", IsUsing_Snow_Checkpointless); }
void RenderS_Snow_Icy() {            IsUsing_Snow_Icy =            UI::Checkbox("[Snow] Icy", IsUsing_Snow_Icy); }
void RenderS_Snow_Underwater() {     IsUsing_Snow_Underwater =     UI::Checkbox("[Snow] Underwater", IsUsing_Snow_Underwater); }
void RenderS_Snow_Wet_Plastic() {    IsUsing_Snow_Wet_Plastic =    UI::Checkbox("[Snow] Wet-Plastic", IsUsing_Snow_Wet_Plastic); }
void RenderS_Snow_Wood() {           IsUsing_Snow_Wood =           UI::Checkbox("[Snow] Wood", IsUsing_Snow_Wood); }
void RenderS_Rally_() {              IsUsing_Rally_ =              UI::Checkbox("[Rally]", IsUsing_Rally_); }
void RenderS_Rally_CP1_is_End() {    IsUsing_Rally_CP1_is_End =    UI::Checkbox("[Rally] CP1 is End", IsUsing_Rally_CP1_is_End); }
void RenderS_Rally_Underwater() {    IsUsing_Rally_Underwater =    UI::Checkbox("[Rally] Underwater", IsUsing_Rally_Underwater); }
// ############################################################################################################


// ############################################################################################################
void RenderMulti() { 
    UI::Text('All the altered nadeo multi alterations');

    RenderS_100WetIcyWood();
    RenderS_Checkpointless_Reverse();
    RenderS_Icy_Reactor();
    RenderS_Ice_Reverse();
    RenderS_Ice_Reverse_Reactor();
    RenderS_Ice_Short();
    RenderS_Magnet_Reverse();
    RenderS_Plastic_Reverse();
    RenderS_Sky_is_the_Finish_Reverse();
    RenderS_sw2u1l_cpu_f2d1r();
    RenderS_Underwater_Reverse();
    RenderS_Wet_Plastic();
    RenderS_Wet_Wood();
    RenderS_Wet_Icy_Wood();
    RenderS_Yeet_Max_Up();
    RenderS_YEET_Puzzle();
    RenderS_YEET_Random_Puzzle();
    RenderS_YEET_Reverse();

    if (UI::Button("Enable All multi settings")) { SelectAlteredMulti(); }
    if (UI::Button("Disable All multi settings")) { DeselectAlteredMulti(); }
}

void RenderS_100WetIcyWood() {             IsUsing_100WetIcyWood =             UI::Checkbox("100% Wet-Icy-Wood", IsUsing_100WetIcyWood); }
void RenderS_Checkpointless_Reverse() {    IsUsing_Checkpointless_Reverse =    UI::Checkbox("Checkpointless Reverse", IsUsing_Checkpointless_Reverse); }
void RenderS_Icy_Reactor() {               IsUsing_Icy_Reactor =               UI::Checkbox("Icy Reactor", IsUsing_Icy_Reactor); }
void RenderS_Ice_Reverse() {               IsUsing_Ice_Reverse =               UI::Checkbox("Ice Reverse", IsUsing_Ice_Reverse); }
void RenderS_Ice_Reverse_Reactor() {       IsUsing_Ice_Reverse_Reactor =       UI::Checkbox("Ice Reverse Reactor", IsUsing_Ice_Reverse_Reactor); }
void RenderS_Ice_Short() {                 IsUsing_Ice_Short =                 UI::Checkbox("Ice Short", IsUsing_Ice_Short); }
void RenderS_Magnet_Reverse() {            IsUsing_Magnet_Reverse =            UI::Checkbox("Magnet Reverse", IsUsing_Magnet_Reverse); }
void RenderS_Plastic_Reverse() {           IsUsing_Plastic_Reverse =           UI::Checkbox("Plastic Reverse", IsUsing_Plastic_Reverse); }
void RenderS_Sky_is_the_Finish_Reverse() { IsUsing_Sky_is_the_Finish_Reverse = UI::Checkbox("Sky is the Finish Reverse", IsUsing_Sky_is_the_Finish_Reverse); }
void RenderS_sw2u1l_cpu_f2d1r() {          IsUsing_sw2u1l_cpu_f2d1r =          UI::Checkbox("sw2u1l-cpu-f2d1r", IsUsing_sw2u1l_cpu_f2d1r); }
void RenderS_Underwater_Reverse() {        IsUsing_Underwater_Reverse =        UI::Checkbox("Underwater Reverse", IsUsing_Underwater_Reverse); }
void RenderS_Wet_Plastic() {               IsUsing_Wet_Plastic =               UI::Checkbox("Wet Plastic", IsUsing_Wet_Plastic); }
void RenderS_Wet_Wood() {                  IsUsing_Wet_Wood =                  UI::Checkbox("Wet Wood", IsUsing_Wet_Wood); }
void RenderS_Wet_Icy_Wood() {              IsUsing_Wet_Icy_Wood =              UI::Checkbox("Wet-Icy-Wood", IsUsing_Wet_Icy_Wood); }
void RenderS_Yeet_Max_Up() {               IsUsing_Yeet_Max_Up =               UI::Checkbox("Yeet Max Up", IsUsing_Yeet_Max_Up); }
void RenderS_YEET_Puzzle() {               IsUsing_YEET_Puzzle =               UI::Checkbox("YEET Puzzle", IsUsing_YEET_Puzzle); }
void RenderS_YEET_Random_Puzzle() {        IsUsing_YEET_Random_Puzzle =        UI::Checkbox("YEET Random Puzzle", IsUsing_YEET_Random_Puzzle); }
void RenderS_YEET_Reverse() {              IsUsing_YEET_Reverse =              UI::Checkbox("YEET Reverse", IsUsing_YEET_Reverse); }
// ############################################################################################################


// ############################################################################################################
void RenderAlterationalOther() { 
    UI::Text("All the altered nadeo 'other' alterations");

    RenderS_XX_But();
    RenderS_Flat_2D();
    RenderS_A08();
    RenderS_Altered_Camera();
    RenderS_Antibooster();
    RenderS_Backwards();
    RenderS_Blind();
    RenderS_Boosterless();
    RenderS_BOSS();
    RenderS_Broken();
    RenderS_Bumper();
    RenderS_Ngolo_Cacti();
    RenderS_No_Cut();
    RenderS_Checkpoin_t();
    RenderS_Cleaned();
    RenderS_Colours_Combined();
    RenderS_CP_Boost();
    RenderS_CP1_Kept();
    RenderS_CPfull();
    RenderS_Checkpointless();
    RenderS_CPLink();
    RenderS_Got_Rotated_CPs_Rotated_90__();
    RenderS_Earthquake();
    RenderS_Egocentrism();
    RenderS_Fast();
    RenderS_Flipped();
    // RenderS_Hard(); // Is actally Lunatic
    RenderS_Ground_Clippers();
    RenderS_Holes();
    RenderS_Lunatic();
    RenderS_Mini_RPG();
    RenderS_Mirrored();
    RenderS_Pool_Hunters();
    RenderS_Random();
    RenderS_Ring_CP();
    RenderS_Scuba_Diving();
    RenderS_Sections_joined();
    RenderS_Select_DEL();
    RenderS_Speedlimit();
    RenderS_Staircase();
    RenderS_Start_1_Down();
    RenderS_Supersized();
    RenderS_Straight_to_the_Finish();
    RenderS_Stunt();
    RenderS_Symmetrical();
    RenderS_Tilted();
    RenderS_Walmart_Mini();
    RenderS_YEET();
    RenderS_YEET_Down();

    if (UI::Button("Enable All other settings")) { SelectAlteredOther(); }
    if (UI::Button("Disable All other settings")) { DeselectAlteredOther(); }
}

void RenderS_XX_But() {                     IsUsing_XX_But =                     UI::Checkbox("XX-But", IsUsing_XX_But); }
void RenderS_Flat_2D() {                    IsUsing_Flat_2D =                    UI::Checkbox("Flat 2D", IsUsing_Flat_2D); }
void RenderS_A08() {                        IsUsing_A08 =                        UI::Checkbox("A08", IsUsing_A08); }
void RenderS_Altered_Camera() {             IsUsing_Altered_Camera =             UI::Checkbox("Altered Camera", IsUsing_Altered_Camera); }
void RenderS_Antibooster() {                IsUsing_Antibooster =                UI::Checkbox("Antibooster", IsUsing_Antibooster); }
void RenderS_Backwards() {                  IsUsing_Backwards =                  UI::Checkbox("Backwards", IsUsing_Backwards); }
void RenderS_Blind() {                      IsUsing_Blind =                      UI::Checkbox("Blind", IsUsing_Blind); }
void RenderS_Boosterless() {                IsUsing_Boosterless =                UI::Checkbox("Boosterless", IsUsing_Boosterless); }
void RenderS_BOSS() {                       IsUsing_BOSS =                       UI::Checkbox("BOSS", IsUsing_BOSS); }
void RenderS_Broken() {                     IsUsing_Broken =                     UI::Checkbox("Broken", IsUsing_Broken); }
void RenderS_Bumper() {                     IsUsing_Bumper =                     UI::Checkbox("Bumper", IsUsing_Bumper); }
void RenderS_Ngolo_Cacti() {                IsUsing_Ngolo_Cacti =                UI::Checkbox("Ngolo Cacti", IsUsing_Ngolo_Cacti); }
void RenderS_No_Cut() {                     IsUsing_No_Cut =                     UI::Checkbox("No Cut", IsUsing_No_Cut); }
void RenderS_Checkpoin_t() {                IsUsing_Checkpoin_t =                UI::Checkbox("Checkpoin-t", IsUsing_Checkpoin_t); }
void RenderS_Cleaned() {                    IsUsing_Cleaned =                    UI::Checkbox("Cleaned", IsUsing_Cleaned); }
void RenderS_Colours_Combined() {           IsUsing_Colours_Combined =           UI::Checkbox("Colours Combined", IsUsing_Colours_Combined); }
void RenderS_CP_Boost() {                   IsUsing_CP_Boost =                   UI::Checkbox("CP-Boost", IsUsing_CP_Boost); }
void RenderS_CP1_Kept() {                   IsUsing_CP1_Kept =                   UI::Checkbox("CP1 Kept", IsUsing_CP1_Kept); }
void RenderS_CPfull() {                     IsUsing_CPfull =                     UI::Checkbox("CPfull", IsUsing_CPfull); }
void RenderS_Checkpointless() {             IsUsing_Checkpointless =             UI::Checkbox("Checkpointless", IsUsing_Checkpointless); }
void RenderS_CPLink() {                     IsUsing_CPLink =                     UI::Checkbox("CPLink", IsUsing_CPLink); }
void RenderS_Got_Rotated_CPs_Rotated_90__() { IsUsing_Got_Rotated_CPs_Rotated_90__ = UI::Checkbox("Got Rotated CPs Rotated 90°", IsUsing_Got_Rotated_CPs_Rotated_90__); }
void RenderS_Earthquake() {                 IsUsing_Earthquake =                 UI::Checkbox("Earthquake", IsUsing_Earthquake); }
void RenderS_Egocentrism() {                IsUsing_Egocentrism =                UI::Checkbox("Egocentrism", IsUsing_Egocentrism); }
void RenderS_Fast() {                       IsUsing_Fast =                       UI::Checkbox("Fast", IsUsing_Fast); }
void RenderS_Flipped() {                    IsUsing_Flipped =                    UI::Checkbox("Flipped", IsUsing_Flipped); }
void RenderS_Ground_Clippers() {            IsUsing_Ground_Clippers =            UI::Checkbox("Ground Clippers", IsUsing_Ground_Clippers); }
// void RenderS_Hard() {                       IsUsing_Hard =                       UI::Checkbox("Hard", IsUsing_Hard); } // Is actally Lunatic
void RenderS_Holes() {                      IsUsing_Holes =                      UI::Checkbox("Holes", IsUsing_Holes); }
void RenderS_Lunatic() {                    IsUsing_Lunatic =                    UI::Checkbox("Lunatic", IsUsing_Lunatic); }
void RenderS_Mini_RPG() {                   IsUsing_Mini_RPG =                   UI::Checkbox("Mini-RPG", IsUsing_Mini_RPG); }
void RenderS_Mirrored() {                   IsUsing_Mirrored =                   UI::Checkbox("Mirrored", IsUsing_Mirrored); }
void RenderS_Pool_Hunters() {               IsUsing_Pool_Hunters =               UI::Checkbox("Pool Hunters", IsUsing_Pool_Hunters); }
void RenderS_Random() {                     IsUsing_Random =                     UI::Checkbox("Random", IsUsing_Random); }
void RenderS_Ring_CP() {                    IsUsing_Ring_CP =                    UI::Checkbox("Ring CP", IsUsing_Ring_CP); }
void RenderS_Scuba_Diving() {               IsUsing_Scuba_Diving =               UI::Checkbox("Scuba Diving", IsUsing_Scuba_Diving); }
void RenderS_Sections_joined() {            IsUsing_Sections_joined =            UI::Checkbox("Sections joined", IsUsing_Sections_joined); }
void RenderS_Select_DEL() {                 IsUsing_Select_DEL =                 UI::Checkbox("Select DEL", IsUsing_Select_DEL); }
void RenderS_Speedlimit() {                 IsUsing_Speedlimit =                 UI::Checkbox("Speedlimit", IsUsing_Speedlimit); }
void RenderS_Staircase() {                  IsUsing_Staircase =                  UI::Checkbox("Staircase", IsUsing_Staircase); }
void RenderS_Start_1_Down() {               IsUsing_Start_1_Down =               UI::Checkbox("Start 1 Down", IsUsing_Start_1_Down); }
void RenderS_Supersized() {                 IsUsing_Supersized =                 UI::Checkbox("Supersized", IsUsing_Supersized); }
void RenderS_Straight_to_the_Finish() {     IsUsing_Straight_to_the_Finish =     UI::Checkbox("Straight to the Finish", IsUsing_Straight_to_the_Finish); }
void RenderS_Stunt() {                      IsUsing_Stunt =                      UI::Checkbox("Stunt", IsUsing_Stunt); }
void RenderS_Symmetrical() {                IsUsing_Symmetrical =                UI::Checkbox("Symmetrical", IsUsing_Symmetrical); }
void RenderS_Tilted() {                     IsUsing_Tilted =                     UI::Checkbox("Tilted", IsUsing_Tilted); }
void RenderS_Walmart_Mini() {               IsUsing_Walmart_Mini =               UI::Checkbox("Walmart Mini", IsUsing_Walmart_Mini); }
void RenderS_YEET() {                       IsUsing_YEET =                       UI::Checkbox("YEET", IsUsing_YEET); }
void RenderS_YEET_Down() {                  IsUsing_YEET_Down =                  UI::Checkbox("YEET Down", IsUsing_YEET_Down); }
// ############################################################################################################


// ############################################################################################################
void RenderExtra() { 
    UI::Text('All the altered nadeo extra alterations');


    RenderS_STraining();
    RenderS_SOfficialCompetitions();
    RenderS_SOfficialNadeo();
    RenderS_STOTD();
    // They are set up under the seasonal section
    RenderS_AOfficialCompetitions();

    if (UI::Button("Enable All extra settings")) { SelectAlteredExtraCampaigns(); }
    if (UI::Button("Disable All extra settings")) { DeselectAlteredExtraCampaigns(); }
}

void RenderS_AOfficialCompetitions() { IsUsing__AllOfficialCompetitions = UI::Checkbox("Official Competitions (With alterations)", IsUsing__AllOfficialCompetitions); }
// ############################################################################################################




funcdef void RENDER_FUNC();

array<string> alterationNames;
array<RENDER_FUNC@> alterationFuncs;

void PopulateAlterationsArrays() {
    alterationNames = {};
    alterationFuncs = {};

    // Surfaces
    alterationNames.InsertLast("Dirt");
    alterationFuncs.InsertLast(@RenderS_Dirt);
    alterationNames.InsertLast("Fast Magnet");
    alterationFuncs.InsertLast(@RenderS_Fast_Magnet);
    alterationNames.InsertLast("Flooded");
    alterationFuncs.InsertLast(@RenderS_Flooded);
    alterationNames.InsertLast("Grass");
    alterationFuncs.InsertLast(@RenderS_Grass);
    alterationNames.InsertLast("Ice");
    alterationFuncs.InsertLast(@RenderS_Ice);
    alterationNames.InsertLast("Magnet");
    alterationFuncs.InsertLast(@RenderS_Magnet);
    alterationNames.InsertLast("Mixed");
    alterationFuncs.InsertLast(@RenderS_Mixed);
    alterationNames.InsertLast("Better Mixed");
    alterationFuncs.InsertLast(@RenderS_Better_Mixed);
    alterationNames.InsertLast("Penalty");
    alterationFuncs.InsertLast(@RenderS_Penalty);
    alterationNames.InsertLast("Plastic");
    alterationFuncs.InsertLast(@RenderS_Plastic);
    alterationNames.InsertLast("Road");
    alterationFuncs.InsertLast(@RenderS_Road);
    alterationNames.InsertLast("Road Dirt");
    alterationFuncs.InsertLast(@RenderS_Road_Dirt);
    alterationNames.InsertLast("Bobsleigh");
    alterationFuncs.InsertLast(@RenderS_Bobsleigh);
    alterationNames.InsertLast("Pipe");
    alterationFuncs.InsertLast(@RenderS_Pipe);
    alterationNames.InsertLast("Platform");
    alterationFuncs.InsertLast(@RenderS_Platform);
    alterationNames.InsertLast("Sausage");
    alterationFuncs.InsertLast(@RenderS_Sausage);
    alterationNames.InsertLast("Surfaceless");
    alterationFuncs.InsertLast(@RenderS_Surfaceless);
    alterationNames.InsertLast("Underwater");
    alterationFuncs.InsertLast(@RenderS_Underwater);

    // Effects
    alterationNames.InsertLast("Cruise");
    alterationFuncs.InsertLast(@RenderS_Cruise);
    alterationNames.InsertLast("Fragile");
    alterationFuncs.InsertLast(@RenderS_Fragile);
    alterationNames.InsertLast("Freewheel");
    alterationFuncs.InsertLast(@RenderS_Freewheel);
    alterationNames.InsertLast("Glider");
    alterationFuncs.InsertLast(@RenderS_Glider);
    alterationNames.InsertLast("No-Brakes");
    alterationFuncs.InsertLast(@RenderS_No_Brakes);
    alterationNames.InsertLast("No-Effects");
    alterationFuncs.InsertLast(@RenderS_No_Effects);
    alterationNames.InsertLast("No-Grip");
    alterationFuncs.InsertLast(@RenderS_No_Grip);
    alterationNames.InsertLast("No-Steer");
    alterationFuncs.InsertLast(@RenderS_No_Steer);
    alterationNames.InsertLast("Random Dankness");
    alterationFuncs.InsertLast(@RenderS_Random_Dankness);
    alterationNames.InsertLast("Random Effects");
    alterationFuncs.InsertLast(@RenderS_Random_Effects);
    alterationNames.InsertLast("Reactor");
    alterationFuncs.InsertLast(@RenderS_Reactor);
    alterationNames.InsertLast("Reactor Down");
    alterationFuncs.InsertLast(@RenderS_Reactor_Down);
    alterationNames.InsertLast("RNG Booster");
    alterationFuncs.InsertLast(@RenderS_RNG_Booster);
    alterationNames.InsertLast("Slowmo");
    alterationFuncs.InsertLast(@RenderS_Slowmo);
    alterationNames.InsertLast("Wet Wheels");
    alterationFuncs.InsertLast(@RenderS_Wet_Wheels);
    alterationNames.InsertLast("Worn Tires");
    alterationFuncs.InsertLast(@RenderS_Worn_Tires);
    
    // Finish Locations
    alterationNames.InsertLast("1-Down");
    alterationFuncs.InsertLast(@RenderS_1Down);
    alterationNames.InsertLast("1-Back / 1-Forwards");
    alterationFuncs.InsertLast(@RenderS_1Back);
    alterationNames.InsertLast("1-Left");
    alterationFuncs.InsertLast(@RenderS_1Left);
    alterationNames.InsertLast("1-Right");
    alterationFuncs.InsertLast(@RenderS_1Right);
    alterationNames.InsertLast("1-UP");
    alterationFuncs.InsertLast(@RenderS_1Up);
    alterationNames.InsertLast("2-UP");
    alterationFuncs.InsertLast(@RenderS_2Up);
    alterationNames.InsertLast("Better Reverse");
    alterationFuncs.InsertLast(@RenderS_Better_Reverse);
    alterationNames.InsertLast("CP1 is End");
    alterationFuncs.InsertLast(@RenderS_CP1_is_End);
    alterationNames.InsertLast("Floor Fin");
    alterationFuncs.InsertLast(@RenderS_Floor_Fin);
    alterationNames.InsertLast("Manslaoughter");
    alterationFuncs.InsertLast(@RenderS_Manslaughter);
    alterationNames.InsertLast("No-Gear-5");
    alterationFuncs.InsertLast(@RenderS_No_Gear_5);
    alterationNames.InsertLast("Podium");
    alterationFuncs.InsertLast(@RenderS_Podium);
    alterationNames.InsertLast("Puzzle");
    alterationFuncs.InsertLast(@RenderS_Puzzle);
    alterationNames.InsertLast("Reverse");
    alterationFuncs.InsertLast(@RenderS_Reverse);
    alterationNames.InsertLast("Roofing");
    alterationFuncs.InsertLast(@RenderS_Roofing);
    alterationNames.InsertLast("Short");
    alterationFuncs.InsertLast(@RenderS_Short);
    alterationNames.InsertLast("Sky is the Finish");
    alterationFuncs.InsertLast(@RenderS_Sky_is_the_Finish);
    alterationNames.InsertLast("There and Back");
    alterationFuncs.InsertLast(@RenderS_There_and_Back_Boomerang);
    alterationNames.InsertLast("YEP-Tree Puzzle");
    alterationFuncs.InsertLast(@RenderS_YEP_Tree_Puzzle);
    alterationNames.InsertLast("Inclined");
    alterationFuncs.InsertLast(@RenderS_Inclined);

    // Enviroments
    alterationNames.InsertLast("[Stadium]");
    alterationFuncs.InsertLast(@RenderS_Stadium_);
    alterationNames.InsertLast("[Stadium] Wet Wood");
    alterationFuncs.InsertLast(@RenderS_Stadium_Wet_Wood);
    alterationNames.InsertLast("[Snow]");
    alterationFuncs.InsertLast(@RenderS_Snow_);
    alterationNames.InsertLast("[Snow] Carswitch");
    alterationFuncs.InsertLast(@RenderS_Snow_Carswitch);
    alterationNames.InsertLast("[Snow] Checkpointless");
    alterationFuncs.InsertLast(@RenderS_Snow_Checkpointless);
    alterationNames.InsertLast("[Snow] Icy");
    alterationFuncs.InsertLast(@RenderS_Snow_Icy);
    alterationNames.InsertLast("[Snow] Underwater");
    alterationFuncs.InsertLast(@RenderS_Snow_Underwater);
    alterationNames.InsertLast("[Snow] Wet-Plastic");
    alterationFuncs.InsertLast(@RenderS_Snow_Wet_Plastic);
    alterationNames.InsertLast("[Snow] Wood");
    alterationFuncs.InsertLast(@RenderS_Snow_Wood);
    alterationNames.InsertLast("[Rally]");
    alterationFuncs.InsertLast(@RenderS_Rally_);
    alterationNames.InsertLast("[Rally] CP1 is End");
    alterationFuncs.InsertLast(@RenderS_Rally_CP1_is_End);
    alterationNames.InsertLast("[Rally] Underwater");
    alterationFuncs.InsertLast(@RenderS_Rally_Underwater);
    
    // Multi
    alterationNames.InsertLast("100% Wet-Icy-Wood");
    alterationFuncs.InsertLast(@RenderS_100WetIcyWood);
    alterationNames.InsertLast("Checkpointless Reverse");
    alterationFuncs.InsertLast(@RenderS_Checkpointless_Reverse);
    alterationNames.InsertLast("Icy Reactor");
    alterationFuncs.InsertLast(@RenderS_Icy_Reactor);
    alterationNames.InsertLast("Ice Reverse");
    alterationFuncs.InsertLast(@RenderS_Ice_Reverse);
    alterationNames.InsertLast("Ice Reverse Reactor");
    alterationFuncs.InsertLast(@RenderS_Ice_Reverse_Reactor);
    alterationNames.InsertLast("Ice Short");
    alterationFuncs.InsertLast(@RenderS_Ice_Short);
    alterationNames.InsertLast("Magnet Reverse");
    alterationFuncs.InsertLast(@RenderS_Magnet_Reverse);
    alterationNames.InsertLast("Plastic Reverse");
    alterationFuncs.InsertLast(@RenderS_Plastic_Reverse);
    alterationNames.InsertLast("Sky is the Finish Reverse");
    alterationFuncs.InsertLast(@RenderS_Sky_is_the_Finish_Reverse);
    alterationNames.InsertLast("sw2u1l-cpu-f2d1r");
    alterationFuncs.InsertLast(@RenderS_sw2u1l_cpu_f2d1r);
    alterationNames.InsertLast("Underwater Reverse");
    alterationFuncs.InsertLast(@RenderS_Underwater_Reverse);
    alterationNames.InsertLast("Wet Plastic");
    alterationFuncs.InsertLast(@RenderS_Wet_Plastic);
    alterationNames.InsertLast("Wet Wood");
    alterationFuncs.InsertLast(@RenderS_Wet_Wood);
    alterationNames.InsertLast("Wet-Icy-Wood");
    alterationFuncs.InsertLast(@RenderS_Wet_Icy_Wood);
    alterationNames.InsertLast("Yeet Max Up");
    alterationFuncs.InsertLast(@RenderS_Yeet_Max_Up);
    alterationNames.InsertLast("YEET Puzzle");
    alterationFuncs.InsertLast(@RenderS_YEET_Puzzle);
    alterationNames.InsertLast("YEET Random Puzzle");
    alterationFuncs.InsertLast(@RenderS_YEET_Random_Puzzle);
    alterationNames.InsertLast("YEET Reverse");
    alterationFuncs.InsertLast(@RenderS_YEET_Reverse);

    // Other
    alterationNames.InsertLast("XX-But");
    alterationFuncs.InsertLast(@RenderS_XX_But);
    alterationNames.InsertLast("Flat 2D");
    alterationFuncs.InsertLast(@RenderS_Flat_2D);
    alterationNames.InsertLast("A08");
    alterationFuncs.InsertLast(@RenderS_A08);
    alterationNames.InsertLast("Altered Camera");
    alterationFuncs.InsertLast(@RenderS_Altered_Camera);
    alterationNames.InsertLast("Antibooster");
    alterationFuncs.InsertLast(@RenderS_Antibooster);
    alterationNames.InsertLast("Backwards");
    alterationFuncs.InsertLast(@RenderS_Backwards);
    alterationNames.InsertLast("Blind");
    alterationFuncs.InsertLast(@RenderS_Blind);
    alterationNames.InsertLast("Boosterless");
    alterationFuncs.InsertLast(@RenderS_Boosterless);
    alterationNames.InsertLast("BOSS");
    alterationFuncs.InsertLast(@RenderS_BOSS);
    alterationNames.InsertLast("Broken");
    alterationFuncs.InsertLast(@RenderS_Broken);
    alterationNames.InsertLast("Bumper");
    alterationFuncs.InsertLast(@RenderS_Bumper);
    alterationNames.InsertLast("Ngolo Cacti");
    alterationFuncs.InsertLast(@RenderS_Ngolo_Cacti);
    alterationNames.InsertLast("No Cut");
    alterationFuncs.InsertLast(@RenderS_No_Cut);
    alterationNames.InsertLast("Checkpoin-t");
    alterationFuncs.InsertLast(@RenderS_Checkpoin_t);
    alterationNames.InsertLast("Cleaned");
    alterationFuncs.InsertLast(@RenderS_Cleaned);
    alterationNames.InsertLast("Colours Combined");
    alterationFuncs.InsertLast(@RenderS_Colours_Combined);
    alterationNames.InsertLast("CP-Boost");
    alterationFuncs.InsertLast(@RenderS_CP_Boost);
    alterationNames.InsertLast("CP1 Kept");
    alterationFuncs.InsertLast(@RenderS_CP1_Kept);
    alterationNames.InsertLast("CPfull");
    alterationFuncs.InsertLast(@RenderS_CPfull);
    alterationNames.InsertLast("Checkpointless");
    alterationFuncs.InsertLast(@RenderS_Checkpointless);
    alterationNames.InsertLast("CPLink");
    alterationFuncs.InsertLast(@RenderS_CPLink);
    alterationNames.InsertLast("Got Rotated CPs Rotated 90°");
    alterationFuncs.InsertLast(@RenderS_Got_Rotated_CPs_Rotated_90__);
    alterationNames.InsertLast("Earthquake");
    alterationFuncs.InsertLast(@RenderS_Earthquake);
    alterationNames.InsertLast("Egocentrism");
    alterationFuncs.InsertLast(@RenderS_Egocentrism);
    alterationNames.InsertLast("Fast");
    alterationFuncs.InsertLast(@RenderS_Fast);
    alterationNames.InsertLast("Flipped");
    alterationFuncs.InsertLast(@RenderS_Flipped);
    alterationNames.InsertLast("Ground Clippers");
    alterationFuncs.InsertLast(@RenderS_Ground_Clippers);
    // alterationNames.InsertLast("Hard");        // Is actally Lunatic
    // alterationFuncs.InsertLast(@RenderS_Hard); // Is actally Lunatic
    alterationNames.InsertLast("Holes");
    alterationFuncs.InsertLast(@RenderS_Holes);
    alterationNames.InsertLast("Lunatic");
    alterationFuncs.InsertLast(@RenderS_Lunatic);
    alterationNames.InsertLast("Mini-RPG");
    alterationFuncs.InsertLast(@RenderS_Mini_RPG);
    alterationNames.InsertLast("Mirrored");
    alterationFuncs.InsertLast(@RenderS_Mirrored);
    alterationNames.InsertLast("Pool Hunters");
    alterationFuncs.InsertLast(@RenderS_Pool_Hunters);
    alterationNames.InsertLast("Random");
    alterationFuncs.InsertLast(@RenderS_Random);
    alterationNames.InsertLast("Ring CP");
    alterationFuncs.InsertLast(@RenderS_Ring_CP);
    alterationNames.InsertLast("Scuba Diving");
    alterationFuncs.InsertLast(@RenderS_Scuba_Diving);
    alterationNames.InsertLast("Sections joined");
    alterationFuncs.InsertLast(@RenderS_Sections_joined);
    alterationNames.InsertLast("Select DEL");
    alterationFuncs.InsertLast(@RenderS_Select_DEL);
    alterationNames.InsertLast("Speedlimit");
    alterationFuncs.InsertLast(@RenderS_Speedlimit);
    alterationNames.InsertLast("Staircase");
    alterationFuncs.InsertLast(@RenderS_Staircase);
    alterationNames.InsertLast("Start 1 Down");
    alterationFuncs.InsertLast(@RenderS_Start_1_Down);
    alterationNames.InsertLast("Supersized");
    alterationFuncs.InsertLast(@RenderS_Supersized);
    alterationNames.InsertLast("Straight to the Finish");
    alterationFuncs.InsertLast(@RenderS_Straight_to_the_Finish);
    alterationNames.InsertLast("Stunt");
    alterationFuncs.InsertLast(@RenderS_Stunt);
    alterationNames.InsertLast("Symmetrical");
    alterationFuncs.InsertLast(@RenderS_Symmetrical);
    alterationNames.InsertLast("Tilted");
    alterationFuncs.InsertLast(@RenderS_Tilted);
    alterationNames.InsertLast("Walmart Mini");
    alterationFuncs.InsertLast(@RenderS_Walmart_Mini);
    alterationNames.InsertLast("YEET");
    alterationFuncs.InsertLast(@RenderS_YEET);
    alterationNames.InsertLast("YEET Down");
    alterationFuncs.InsertLast(@RenderS_YEET_Down);

    // Extra
    alterationNames.InsertLast("Official Nadeo");
    alterationFuncs.InsertLast(@RenderS_SOfficialNadeo);
    alterationNames.InsertLast("TOTD");
    alterationFuncs.InsertLast(@RenderS_STOTD);
    alterationNames.InsertLast("Training");
    alterationFuncs.InsertLast(@RenderS_STraining);
    alterationNames.InsertLast("Official Competitions");
    alterationFuncs.InsertLast(@RenderS_SOfficialCompetitions);

    alterationNames.InsertLast("Snow Discovery");
    alterationFuncs.InsertLast(@RenderS_SnowDiscovery);
    alterationNames.InsertLast("Rally Discovery");
    alterationFuncs.InsertLast(@RenderS_RallyDiscovery);

    // Seasonal
    alterationNames.InsertLast("Spring 2020");
    alterationFuncs.InsertLast(@RenderS_Spring2020);
    alterationNames.InsertLast("Spring 2021");
    alterationFuncs.InsertLast(@RenderS_Spring2021);
    alterationNames.InsertLast("Spring 2022");
    alterationFuncs.InsertLast(@RenderS_Spring2022);
    alterationNames.InsertLast("Spring 2023");
    alterationFuncs.InsertLast(@RenderS_Spring2023);
    alterationNames.InsertLast("Spring 2024");
    alterationFuncs.InsertLast(@RenderS_Spring2024);
    alterationNames.InsertLast("Spring 2025");
    alterationFuncs.InsertLast(@RenderS_Spring2025);

    alterationNames.InsertLast("Summer 2020");
    alterationFuncs.InsertLast(@RenderS_Summer2020);
    alterationNames.InsertLast("Summer 2021");
    alterationFuncs.InsertLast(@RenderS_Summer2021);
    alterationNames.InsertLast("Summer 2022");
    alterationFuncs.InsertLast(@RenderS_Summer2022);
    alterationNames.InsertLast("Summer 2023");
    alterationFuncs.InsertLast(@RenderS_Summer2023);
    alterationNames.InsertLast("Summer 2024");
    alterationFuncs.InsertLast(@RenderS_Summer2024);
    alterationNames.InsertLast("Summer 2025");
    alterationFuncs.InsertLast(@RenderS_Summer2025);

    alterationNames.InsertLast("Fall 2020");
    alterationFuncs.InsertLast(@RenderS_Fall2020);
    alterationNames.InsertLast("Fall 2021");
    alterationFuncs.InsertLast(@RenderS_Fall2021);
    alterationNames.InsertLast("Fall 2022");
    alterationFuncs.InsertLast(@RenderS_Fall2022);
    alterationNames.InsertLast("Fall 2023");
    alterationFuncs.InsertLast(@RenderS_Fall2023);
    alterationNames.InsertLast("Fall 2024");
    alterationFuncs.InsertLast(@RenderS_Fall2024);
    
    alterationNames.InsertLast("Winter 2021");
    alterationFuncs.InsertLast(@RenderS_Winter2021);
    alterationNames.InsertLast("Winter 2022");
    alterationFuncs.InsertLast(@RenderS_Winter2022);
    alterationNames.InsertLast("Winter 2023");
    alterationFuncs.InsertLast(@RenderS_Winter2023);
    alterationNames.InsertLast("Winter 2024");
    alterationFuncs.InsertLast(@RenderS_Winter2024);
}

void RenderSearch() {
    if (g_searchBar.Length == 0) return;

    UI::Text("Search Results:");
    for (uint i = 0; i < alterationNames.Length; i++) {
        if (alterationNames[i].ToLower().Contains(g_searchBar.ToLower())) {
            alterationFuncs[i]();
        }
    }
}