const string tm_map_endpoint = "https://live-services.trackmania.nadeo.live/api/token/map/";

string globalMapUrl = "";
bool isWaitingForUrl = false;
bool isLoadingMapFromUID = false;

void SetFirstUid() {
    string map_uid = GetRandomUID();

    startnew(GetMapUrl, map_uid);

    globalMapUrl = tm_map_endpoint + map_uid;
}

void LoadMapFromUIDProxy() {
    if (!isLoadingMapFromUID) {
        isLoadingMapFromUID = true;
        startnew(LoadMapFromUID);
    }
}

void LoadMapFromUID() {
    string mapUID = GetRandomUID();
    if (mapUID.Length == 0) {
        log("No UID found", LogLevel::Error, 25);
        return;
    }

    isWaitingForUrl = true;
    startnew(GetMapUrl, mapUID);

    while (isWaitingForUrl) yield();

    if (globalMapUrl.Length == 0) {
        log("Failed to get map URL from UID", LogLevel::Error, 35);
        return;
    }

    PlayMap(globalMapUrl);
    isLoadingMapFromUID = false;
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
        log("TM API request returned response code " + req.ResponseCode(), LogLevel::Error, 54);
        log("Response body:", LogLevel::Error, 55);
        log(req.Body, LogLevel::Error, 56);
        return;
    }

    Json::Value res = Json::Parse(req.String());
    globalMapUrl = res["downloadUrl"];
    isWaitingForUrl = false;
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