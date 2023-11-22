
const string tm_map_endpoint = "https://live-services.trackmania.nadeo.live/api/token/map/";
// string map_uid = "91jOho3e0DKB7NlYpzBLOxjeoCm";

string GetMapUrl(const string &in map_uid) {
    // Net::HttpRequest@ req = NadeoServices::Get("NadeoLiveServices", tm_map_endpoint + map_uid);
    // req.Start();
    // while (!req.Finished()) yield();

    // if (req.ResponseCode() != 200) {
    //     log("TM API request returned response code " + req.ResponseCode(), LogLevel::Error);
    //     log("Response body:", LogLevel::Error);
    //     log(req.Body, LogLevel::Error);
    //     return "";
    // }

    // Json::Value res = Json::Parse(req.String());
    string url = tm_map_endpoint + map_uid;//res["downloadUrl"];
    return url;
}


void PlayMap(const string &in map_uid) {
    // this code with slight modifications from
    // https://github.com/XertroV/tm-unbeaten-ats, licensed under the Unlicense

    if (!Permissions::PlayLocalMap()) {
        log("Lacking permissions to play local map", LogLevel::Warn);
        return;
    }

    string map_url = GetMapUrl(map_uid);
    if (map_url == "") return;

    // circumvent possible main menu bug when the in-game menu is visible
    CTrackMania@ app = cast<CTrackMania@>(GetApp());
    if (app.Network.PlaygroundClientScriptAPI.IsInGameMenuDisplayed) {
        app.Network.PlaygroundInterfaceScriptHandler.CloseInGameMenu(CGameScriptHandlerPlaygroundInterface::EInGameMenuResult::Quit);
    }
    app.BackToMainMenu();
    while (!app.ManiaTitleControlScriptAPI.IsReady) yield();

    app.ManiaTitleControlScriptAPI.PlayMap(map_url, "", "");
}








void LoadNewMap() {
    array<string> uids = ReadUIDsFromFile("data.csv");
    string randomUID = GetRandomUID(uids);
    if (randomUID != "") {
        PlayMap(randomUID);
    } else {
        log("No UIDs found in file", LogLevel::Error);
    }
}
string GetRandomUID(const array<string> &in uids) {
    if (uids.Length == 0) return "";
    int randomIndex = Math::Rand(0, uids.Length - 1);
    return uids[randomIndex];
}

string[] ReadUIDsFromFile(const string&in filePath) {
    array<string> uids;

    IO::FileSource fileSource(filePath);

    while (!fileSource.EOF()) {
        string line = fileSource.ReadLine();
        if (line.Length > 0) {
            uids.InsertLast(line);
        }
    }
    
    return uids;
}
