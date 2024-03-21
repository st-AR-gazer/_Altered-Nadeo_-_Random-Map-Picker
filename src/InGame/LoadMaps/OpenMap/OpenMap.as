void PlayMap(const string &in map_url) {
    if (map_url.Length == 0) {
        log("Map URL is empty", LogLevel::Error);
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
