string g_manifestUrl;

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
        log("Fetching manifest successful, code " + req.ResponseCode() + ": \n" + req.String(), LogLevel::Info, 20);
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: \n" + req.String(), LogLevel::Error, 23);
    }
}

string latestVersion;
string g_urlFromManifest;
array<string> unUpdatedFiles;

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) {
        log("Failed to parse JSON.", LogLevel::Error, 34);
        return;
    }

    latestVersion = manifest["latestVersion"];
    g_manifestUrl = manifest["url"];

    Json::Value newUpdateFiles = manifest["newUpdate"];
    if (newUpdateFiles.GetType() == Json::Type::Array) {
        for (uint i = 0; i < newUpdateFiles.Length; i++) {
            unUpdatedFiles.InsertLast(newUpdateFiles[i]);
            log("Unupdated file index[" + i + "]: " + unUpdatedFiles[i], LogLevel::Info, 45);
        }
    }
    
    log("Updating the URL", logLevel::Info, 49); 
    log("the manifest URL is: " + manifestUrl, LogLevel::Info, 50);
    string newUrl = manifest["url"];
    log("The URL from the manifest has been updated", logLevel::Info, 50) 
    log("the new URL is: " + newUrl, LogLevel::Info, 53);
    g_urlFromManifest = newUrl;

    UpdateCurrentVersionIfDifferent(latestVersion);
}

void UpdateCurrentVersionIfDifferent(const string &in latestVersion) {
    string currentInstalledVersion = GetCurrentInstalledVersion();
    
    log("this is the currentinstalledversion: " + currentInstalledVersion + "  this is the latest installed version: " + latestVersion, LogLevel::Info, 62);

    if (currentInstalledVersion != latestVersion) {
        log("Updating the current version: " + currentInstalledVersion + " to the most up-to-date version: " + latestVersion, LogLevel::Info, 65);
        UpdateVersionFile(latestVersion);
        DownloadFiles();
    } else {
        log("Current version is up-to-date.", LogLevel::Info, 69);
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

void UpdateVersionFile(const string &in latestVersion) {
    Json::Value json = Json::FromFile(pluginStorageVersionPath); 
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = latestVersion;
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + latestVersion, LogLevel::Info, 94);
    } else {
        log("JSON file does not have the expected structure." + " Json type is: \n" + json.GetType(), LogLevel::Error, 96);
    }
}