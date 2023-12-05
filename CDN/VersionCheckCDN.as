string pluginStorageDataPath = IO::FromStorageFolder("data.csv");
string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");
string url = "http://maniacdn.net/ar_/Alt-Map-Picker/data.csv";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";

string latestVersion;


void GetLatestFileInfo() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req != null) {
        log("Feching manifest successfull: \n" + req.String(), LogLevel::Info);
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: " + req.String(), LogLevel::Error);
    }
}

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) {
        log("Failed to parse JSON.", LogLevel::Error);
        return;
    }

    string latestVersion = manifest["latestVersion"];
    
    log("Updating the url, the local url is: " + url, LogLevel::Info);
    string url = manifest["url"];
    log("The url has been updated, the new url is: " + url, LogLevel::Info);

    UpdateCurrentVersionIfDifferent(latestVersion);
}

void UpdateCurrentVersionIfDifferent(const string &in latestVersion) {
    string currentInstalledVersion = GetCurrentInstalledVersion();

    if (currentInstalledVersion != latestVersion) {
        log("Updating the current version: " + currentInstalledVersion + " to the most up-to-date version: " + latestVersion, LogLevel::Info);
        DownloadLatestData(latestVersion);
    } else {
        log("Current version is up-to-date.", LogLevel::Info);
    }
}

string GetCurrentInstalledVersion() {
    IO::FileSource file(pluginStorageVersionPath);

    string fileContents = file.ReadToEnd();
    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object) {
        return currentVersionJson["latestVersion"];
    }

    return "";
}

void DownloadLatestData(const string &in latestVersion) {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req != null) {
        auto data = req.String();
        log("Fetching new data successful: \n" + "[data]", LogLevel::Info);
        StoreDatafile(data, latestVersion);
    } else {
        log("Error fetching datafile: " + req.String(), LogLevel::Error);
    }
}

void StoreDatafile(const string &in data, const string &in latestVersion) {
    IO::File file;
    file.Open(pluginStorageDataPath, IO::FileMode::Write);
    file.Write(data);
    file.Close();

    UpdateVersionFile(latestVersion);
}

void UpdateVersionFile(const string &in latestVersion) {
    Json::Value json = Json::FromFile(pluginStorageVersionPath); 
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = latestVersion;
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + latestVersion, LogLevel::Info);
    } else {
        log("JSON file does not have the expected structure.", LogLevel::Error);
    }
} 