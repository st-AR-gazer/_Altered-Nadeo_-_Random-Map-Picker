string g_manifestUrl;

void ManifestCheck() {
    FetchManifest();
}

string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/manifest.json";
// string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/Test-Manifest-All-Instalations-STAR.json";
// string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/Test-Manifest-All-Instalations-Manual.json";

// string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");

void FetchManifest() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        // g_manifestJson = req.String(); // Useless as a global?
        log("Fetching manifest successful, code " + req.ResponseCode() + ": \n" + req.String(), LogLevel::Info, 22);
        ParseManifest(req.String());
    } else {
        log(req.ResponseCode() + " code — Error fetching manifest: \n" + req.String(), LogLevel::Error, 25);
    }
}

int latestVersion;
string g_urlFromManifest;
array<string> unUpdatedFiles;
int g_manifestVersion;
int g_currentInstalledVersion;
int g_manifestID = -1;

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) { log("Failed to parse JSON.", LogLevel::Error, 38); return; }

    g_manifestJson = manifest;

    latestVersion = manifest["latestVersion"];
    g_manifestUrl = manifest["url"];
    g_manifestVersion = manifest["latestVersion"];

    if (manifest["id"].GetType() != Json::Type::Number) { g_manifestID = -1; }
    else { g_manifestID = manifest["id"]; }

    // StoreManifestID(g_manifestID); // not in use...


    Json::Value newUpdateFiles = manifest["updatedFiles"];

    if (newUpdateFiles.HasKey("*")) {
        for (uint i = 0; i < alterationFiles.Length; i++) {
            unUpdatedFiles.InsertLast(alterationFiles[i]);
        }
        for (uint i = 0; i < dataFiles.Length; i++) {
            unUpdatedFiles.InsertLast(dataFiles[i]);
        }
        for (uint i = 0; i < seasonalFiles.Length; i++) {
            unUpdatedFiles.InsertLast(seasonalFiles[i]);
        }
    } else if (newUpdateFiles.GetType() == Json::Type::Array) {
        for (uint i = 0; i < newUpdateFiles.Length; i++) {
            unUpdatedFiles.InsertLast(newUpdateFiles[i]);
            // log("Unupdated file index[" + i + "]: " + unUpdatedFiles[i], LogLevel::Info, 67);
        }
    } else {
        log("newUpdateFiles is not an array or wildcard key.", LogLevel::Error, 70);
    }
    
    // log("Updating the URL", LogLevel::Info, 73); 
    // log("the manifest URL is: " + manifestUrl, LogLevel::Info, 74);
    string newUrl = manifest["url"];
    // log("The URL from the manifest has been updated", LogLevel::Info, 76);
    // log("the new URL is: " + newUrl, LogLevel::Info, 77);
    g_urlFromManifest = newUrl;

    UpdateCurrentVersionIfDifferent(latestVersion);
}

void UpdateCurrentVersionIfDifferent(const int &in latestVersion) {
    CheckCurrentInstalledVersionType();
    int currentInstalledVersion = GetCurrentInstalledVersion();
    g_currentInstalledVersion = currentInstalledVersion;
    
    log("this is the currentinstalledversion: " + currentInstalledVersion + "  this is the latest installed version: " + latestVersion, LogLevel::Info, 88);
    bool shouldUpdateCurrentInstalledVersion = g_manifestJson["updateInstalledVersion"];

    if ((currentInstalledVersion != latestVersion) && (!shouldUpdateCurrentInstalledVersion)) {
        log("Updating the current version: " + currentInstalledVersion + " to the most up-to-date version: " + latestVersion, LogLevel::Info, 92);
        UpdateVersionFile(latestVersion);
        DownloadFiles();
    } else {
        log("Current version is up-to-date.", LogLevel::Info, 96);
    }
}



int GetCurrentInstalledVersion() {
    IO::File file();
    file.Open(pluginStorageVersionPath, IO::FileMode::Read);
    string fileContents = file.ReadToEnd();
    file.Close();

    log("Current version file contents: " + fileContents, LogLevel::Info, 108);
    
    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object) {
        return currentVersionJson["latestVersion"];
    }

    return -1;
}

void UpdateVersionFile(const int &in latestVersion) {
    Json::Value json = Json::FromFile(pluginStorageVersionPath); 
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = latestVersion;
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + latestVersion, LogLevel::Info, 125);
    } else {
        log("JSON file does not have the expected structure." + " Json type is: \n" + json.GetType(), LogLevel::Error, 127);
    }
}

string g_idStoragePath = IO::FromStorageFolder("id");

// void StoreManifestID(int id) { // not in use...
//     if (id == -1) { log("Id is null", LogLevel::D, 134); return; }
    
//     if (!IO::FileExists(g_idStoragePath)) {
//         log("ID file does not exist, creating.", LogLevel::Info, 137);
//     } else {
//         log("ID file already exists, overwriting.", LogLevel::Info, 139);
//     }

//     IO::File file();
//     file.Open(g_idStoragePath, IO::FileMode::Write);
//     file.Write(id);
//     file.Close();
// }