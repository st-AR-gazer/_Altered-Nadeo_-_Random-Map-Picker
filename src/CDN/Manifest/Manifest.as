string g_manifestUrl;
string g_urlFromManifest;
string g_idStoragePath = IO::FromStorageFolder("id");
// string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json"); // In DefaultData.as
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/manifest.json";

int g_manifestVersion;
int g_currentInstalledVersion;
int g_manifestID = -1;
array<string> unUpdatedFiles;

void ManifestCheck() {
    FetchManifest();
}

void FetchManifest() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: " + req.ResponseCode(), LogLevel::Error, 27);
    }
}

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) {
        log("Failed to parse JSON.", LogLevel::Error, 34);
        return;
    }

    g_manifestVersion = manifest["latestVersion"];
    // g_urlFromManifest = manifest["url"];
    
    // if (manifest["id"].GetType() == Json::Type::Number) {
    //     g_manifestID = manifest["id"];
    // }

    UpdateCurrentVersionIfDifferent(g_manifestVersion);
}

void UpdateCurrentVersionIfDifferent(const int &in latestVersion) {
    int currentInstalledVersion = GetCurrentInstalledVersion();
    g_currentInstalledVersion = currentInstalledVersion;
    
    if (currentInstalledVersion != latestVersion/* || !IO::FileExists("Data/consolidated_maps.json") || !IO::FileExists("Data/data.csv")*/) {
        DownloadDataFromCDN();
        UpdateVersionFile(latestVersion);
    }
}

// string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json"); // In MoveDefaultData.as

int GetCurrentInstalledVersion() {

    IO::File file;
    file.Open(pluginStorageVersionPath, IO::FileMode::Read);
    string fileContents = file.ReadToEnd();
    file.Close();

    Json::Value json = Json::Parse(fileContents);

    if (json.GetType() == Json::Type::Object) {
        return json["latestVersion"];
    }

    log("JSON is not an object. JSON is: " + tostring(json.GetType()), LogLevel::Error, 73);
    return -1;
}

void UpdateVersionFile(const int &in latestVersion) {
    Json::Value json = Json::Object();
    json["latestVersion"] = latestVersion;
    Json::ToFile(pluginStorageVersionPath, json);
}
