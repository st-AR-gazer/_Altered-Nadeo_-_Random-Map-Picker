string g_manifestUrl;

void ManifestCheck() {
    FetchManifest();
}

string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";
string manifestUrlTEST = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/Test-Manifest-All-Instalations-STAR.json";
// string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");

void FetchManifest() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrlTEST;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        // g_manifestJson = req.String(); // Useless as a global?
        log("Fetching manifest successful, code " + req.ResponseCode() + ": \n" + req.String(), LogLevel::Info, 21);
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: \n" + req.String(), LogLevel::Error, 24);
    }
}

int latestVersion;
string g_urlFromManifest;
array<string> unUpdatedFiles;
string g_manifestVersion;
string g_currentInstalledVersion;
int g_manifestID = -1;

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) { log("Failed to parse JSON.", LogLevel::Error, 35); return; }

    g_manifestJson = manifest;

    latestVersion = manifest["latestVersion"];
    g_manifestUrl = manifest["url"];
    g_manifestVersion = manifest["latestVersion"];

    if (manifest["id"].GetType() != Json::Type::Number) { g_manifestID = -1; }
    else { g_manifestID = manifest["id"]; }

    StoreManifestID(g_manifestID); // not in use...

    Json::Value newUpdateFiles = manifest["newUpdate"];
    if (newUpdateFiles.GetType() == Json::Type::Array) {
        for (uint i = 0; i < newUpdateFiles.Length; i++) {
            unUpdatedFiles.InsertLast(newUpdateFiles[i]);
            // log("Unupdated file index[" + i + "]: " + unUpdatedFiles[i], LogLevel::Info, 46);
        }
    }
    
    // log("Updating the URL", LogLevel::Info, 50); 
    // log("the manifest URL is: " + manifestUrl, LogLevel::Info, 51);
    string newUrl = manifest["url"];
    // log("The URL from the manifest has been updated", LogLevel::Info, 53);
    // log("the new URL is: " + newUrl, LogLevel::Info, 54);
    g_urlFromManifest = newUrl;

    UpdateCurrentVersionIfDifferent(latestVersion);
}

void UpdateCurrentVersionIfDifferent(const string &in latestVersion) {
    string currentInstalledVersion = GetCurrentInstalledVersion();
    g_currentInstalledVersion = currentInstalledVersion;
    
    log("this is the currentinstalledversion: " + currentInstalledVersion + "  this is the latest installed version: " + latestVersion, LogLevel::Info, 63);

    if (currentInstalledVersion != latestVersion) {
        log("Updating the current version: " + currentInstalledVersion + " to the most up-to-date version: " + latestVersion, LogLevel::Info, 66);
        UpdateVersionFile(latestVersion);
        DownloadFiles();
    } else {
        log("Current version is up-to-date.", LogLevel::Info, 70);
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
        log("Updated to the most recent version: " + latestVersion, LogLevel::Info, 95);
    } else {
        log("JSON file does not have the expected structure." + " Json type is: \n" + json.GetType(), LogLevel::Error, 97);
    }
}

string g_idStoragePath = IO::FromStorageFolder("id");

void StoreManifestID(int id) { // not in use...
    if (id == -1) { log("Id is null", LogLevel::D, 112); return; }
    
    if (!IO::FileExists(g_idStoragePath)) {
        log("ID file does not exist, creating.", LogLevel::Info, 106);
    } else {
        log("ID file already exists, overwriting.", LogLevel::Info, 104);
    }

    IO::File file();
    file.Open(g_idStoragePath, IO::FileMode::Write);
    file.Write(id);
    file.Close();
}