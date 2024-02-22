// To be added // Get random StorageObject from json files, add render function so users can check a box for what alteration / season of alteration they want



string FetchRandomFileUrlFromFiles() {
    array<string> fileNames = GetAllFilesBasedOnSettings();

    uint totalObjects = 0;
    for (uint i = 0; i < fileNames.Length; ++i) {
        Json::Value root = Json::FromFile(fileNames[i]);
        totalObjects += root.Length;
    }

    uint randomIndex = Math::Rand(0, totalObjects);
    uint currentIndex = 0;
    for (uint i = 0; i < fileNames.Length; ++i) {
        Json::Value root = Json::FromFile(fileNames[i]);

        if (currentIndex + root.Length > randomIndex) {
            uint localIndex = randomIndex - currentIndex;
            Json::Value selectedObject = root[localIndex];
            if (selectedObject.HasKey("fileUrl") && selectedObject["fileUrl"].GetType() == Json::Type::String) {
                return string(selectedObject["fileUrl"]);
            } else {
                return "";
            }
        }
        currentIndex += root.Length;
    }

    return "";
}


void PlayMap(const string &in map_uid) {
    

    string map_url = FetchRandomFileUrlFromFiles();

    globalMapUrl = "";
    isWaitingForUrl = true;

    startnew(GetMapUrl, map_uid);

    if (map_url.Length == 0) {
        log("Failed to get map URL", LogLevel::Error, 46);
        return;
    }

    startnew(PlayMapCoroutine, map_url);
}
void PlayMapCoroutine(const string &in map_url) {
    CTrackMania@ app = cast<CTrackMania@>(GetApp());
    if (app.Network.PlaygroundClientScriptAPI.IsInGameMenuDisplayed) {
        app.Network.PlaygroundInterfaceScriptHandler.CloseInGameMenu(CGameScriptHandlerPlaygroundInterface::EInGameMenuResult::Quit);
    }
    app.BackToMainMenu();

    while (!app.ManiaTitleControlScriptAPI.IsReady) yield();

    NotifyInfo("Started playing map");

    app.ManiaTitleControlScriptAPI.PlayMap(map_url, "", "");
}


