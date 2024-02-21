void ManifestCheck() {
    FetchManifest();
}

string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";
// string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");

void FetchManifest() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        log("Fetching manifest successful: \n" + req.String(), LogLevel::Info, 18);
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: \n" + req.String(), LogLevel::Error, 21);
    }
}

string latestVersion;
string urlFromManifest;
array<string> unUpdatedFiles;

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) {
        log("Failed to parse JSON.", LogLevel::Error, 32);
        return;
    }

    latestVersion = manifest["latestVersion"];
    urlFromManifest;

    Json::Value newUpdateFiles = manifest["newUpdate"];
    if (newUpdateFiles.GetType() == Json::Type::Array) {
        for (uint i = 0; i < newUpdateFiles.Length; i++) {
            unUpdatedFiles.InsertLast(newUpdateFiles[i]);
            log("Unupdated file index[" + i + "]: " + unUpdatedFiles[i], LogLevel::Info, 43);
        }
    }
    
    log("Updating the URL, the local URL is: " + manifestUrl, LogLevel::Info, 47);
    string newUrl = manifest["url"];
    log("The URL has been updated, the new URL is: " + newUrl, LogLevel::Info, 49);
    urlFromManifest = newUrl;

    UpdateCurrentVersionIfDifferent(latestVersion);
}

void UpdateCurrentVersionIfDifferent(const string &in latestVersion) {
    string currentInstalledVersion = GetCurrentInstalledVersion();
    
    log("this is the currentinstalledversion: " + currentInstalledVersion + "  this is the latest installed version: " + latestVersion, LogLevel::Info, 58);

    if (currentInstalledVersion != latestVersion) {
        log("Updating the current version: " + currentInstalledVersion + " to the most up-to-date version: " + latestVersion, LogLevel::Info, 61);
        DownloadFiles();
    } else {
        log("Current version is up-to-date.", LogLevel::Info, 66);
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
