string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";
string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");

void FetchAndUpdateManifest() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        log("Fetching manifest successful: \n" + req.String(), LogLevel::Info, 13);
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: \n" + req.String(), LogLevel::Error, 16);
    }
}

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) {
        log("Failed to parse JSON.", LogLevel::Error, 28);
        return;
    }

    string latestVersion = manifest["latestVersion"];
    
    log("Updating the URL, the local URL is: " + url, LogLevel::Info, 34);
    string newUrl = manifest["url"];
    log("The URL has been updated, the new URL is: " + newUrl, LogLevel::Info, 36);

    UpdateCurrentVersionIfDifferent(latestVersion);
}

void UpdateCurrentVersionIfDifferent(const string &in latestVersion) {
    string currentInstalledVersion = GetCurrentInstalledVersion();
    
    log("this is the currentinstalledversion: " + currentInstalledVersion + "  this is the latest installed version: " + latestVersion, LogLevel::Info, 44);

    if (currentInstalledVersion != latestVersion) {
        log("Updating the current version: " + currentInstalledVersion + " to the most up-to-date version: " + latestVersion, LogLevel::Info, 47);
        DownloadLatestData(latestVersion);
        log("Downloading seasonal data.", LogLevel::Info, 49);
        DownloadSeasonalData(latestVersion);
    } else {
        log("Current version is up-to-date.", LogLevel::Info, 52);
    }
}

string GetCurrentInstalledVersion() {
    IO::File file();
    file.Open(pluginStorageVersionPath, IO::FileMode::Read);
    string fileContents = file.ReadToEnd();
    file.Close();
    
    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object) {
        return currentVersionJson["latestVersion"];
    }

    return "";
}

