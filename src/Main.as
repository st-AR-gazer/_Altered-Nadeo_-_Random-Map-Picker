
const string tm_map_endpoint = "https://live-services.trackmania.nadeo.live/api/token/map/";

string globalMapUrl = "";
bool isWaitingForUrl = false;

void SetFirstUid() {
    string map_uid = GetRandomUID();

    startnew(GetMapUrl, map_uid);

    globalMapUrl = tm_map_endpoint + map_uid;
}

void GetMapUrl(const string &in map_uid) {
    NadeoServices::AddAudience("NadeoLiveServices");
    while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) {
        yield();
    }
    Net::HttpRequest@ req = NadeoServices::Get("NadeoLiveServices", tm_map_endpoint + map_uid);
    
    req.Start();
    while (!req.Finished()) yield();

    if (req.ResponseCode() != 200) {
        log("TM API request returned response code " + req.ResponseCode(), LogLevel::Error, 28);
        log("Response body:", LogLevel::Error, 29);
        log(req.Body, LogLevel::Error, 30);
        return;
    }

    Json::Value res = Json::Parse(req.String());
    globalMapUrl = res["downloadUrl"];
    isWaitingForUrl = false;
}

void PlayMap(const string &in map_uid) {
    if (!Permissions::PlayLocalMap()) {
        log("Lacking permissions to play local map", LogLevel::Warn, 41);
        return;
    }

    string map_url = globalMapUrl;

    globalMapUrl = "";
    isWaitingForUrl = true;

    startnew(GetMapUrl, map_uid);

    if (map_url.Length == 0) {
        log("Failed to get map URL", LogLevel::Error, 53);
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

void LoadNewMap() {
    string randomUID = GetRandomUID();
    if (randomUID != "") {
        log("UID found in file", LogLevel::Info, 78);
        const string map_uid = randomUID;
        PlayMap(map_uid);
    } else {
        log("No UIDs found in file", LogLevel::Error, 82);
    }
}

string GetRandomUID() {
    const array<string> uids = ReadUIDsFromFile(pluginStorageDataPath);

    if (uids.Length == 0) return "";
    int randomIndex = Math::Rand(0, uids.Length - 1);
    return uids[randomIndex];
}

string[] ReadUIDsFromFile(const string&in filePath) {
    array<string> uids;

    IO::File file(filePath, IO::FileMode::Read);

    while (!file.EOF()) {
        string line = file.ReadLine();
        if (line.Length > 0) {
            uids.InsertLast(line);
        }
    }
    file.Close();

    return uids;
}