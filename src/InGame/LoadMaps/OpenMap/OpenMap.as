string g_currentMapType;

void PlayMap(const string &in map_url) {
    if (map_url.Length == 0) {
        log("Map URL is empty", LogLevel::Error, 5, "PlayMap");
        return;
    }

    PlayMapCoroutine(map_url, g_currentMapType);
}

void PlayMapCoroutine(const string &in map_url, string Mode = "race") {
    if (!CheckRequiredPermissions()) { return; } // Important to check permissions right before they are required for something, do not rely on something a previous prems check :ok:

    CTrackMania@ app = cast<CTrackMania@>(GetApp());
    if (app.Network.PlaygroundClientScriptAPI.IsInGameMenuDisplayed) {
        app.Network.PlaygroundInterfaceScriptHandler.CloseInGameMenu(CGameScriptHandlerPlaygroundInterface::EInGameMenuResult::Quit);
    }
    app.BackToMainMenu();

    while (!app.ManiaTitleControlScriptAPI.IsReady) {
        yield();
        startTime = Time::Now;
    }

    NotifyInfo("Started playing map");

    if (Mode == "race") { Mode = "Trackmania\\TM_PlayMap_Local"; }
    if (Mode == "stunt") { Mode = "Trackmania\\TM_StuntSolo_Local"; }

    app.ManiaTitleControlScriptAPI.PlayMap(map_url, Mode, "");
}
