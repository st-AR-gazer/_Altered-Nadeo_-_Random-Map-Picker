void PlayMap(const string &in map_url) {
    if (map_url.Length == 0) {
        log("Map URL is empty", LogLevel::Error, 3);
        return;
    }

    PlayMapCoroutine(map_url);
}

void PlayMapCoroutine(const string &in map_url) {
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

    app.ManiaTitleControlScriptAPI.PlayMap(map_url, "", "");
}
