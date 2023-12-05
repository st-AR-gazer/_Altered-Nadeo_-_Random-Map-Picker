string currentVersionFile = "CDN/currentInstalledVersion.json";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";
string url = "http://maniacdn.net/ar_/Alt-Map-Picker/data.csv";
// string currentVersionFileNEWTEST = "CDN/currentInstalledVersionNEW.json";
string latestVersion;

string GetCurrentInstalledVersion() {
    IO::FileSource file(currentVersionFile);

    string fileContents = file.ReadToEnd();

    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object) {
        return currentVersionJson["latestVersion"];
    }

    return "";
}

void GetLatestFileInfo() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req != null) {
        print(req.String());
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
    string url = manifest["url"];

    UpdateCurrentVersionIfDifferent(latestVersion);
}

void UpdateCurrentVersionIfDifferent(const string &in latestVersion) {
    string currentInstalledVersion = GetCurrentInstalledVersion();

    if (currentInstalledVersion != latestVersion) {
        log("Updating the current version: " + currentInstalledVersion + " to the most up-to-date version: " + latestVersion, LogLevel::Info);
        DownloadLatestData();
    } else {
        log("Current version is up-to-date.", LogLevel::Info);
    }
}

void DownloadLatestData() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req != null) {
        auto data = req.String();

        StoreDatafile(data);
    } else {
        log("Error fetching datafile: " + req.String(), LogLevel::Error);
    }
}
/*void StoreDatafile(const string &in data) {
    string jsonStr = Json::Write(data);

    IO::File file;
    file.Open("CDN/CurrentInstalledVersion.json", IO::FileMode::Write);
    bool writeSuccess = file.Write(jsonStr) > 0;
    file.WriteLine();
    file.Close();

    if (writeSuccess) {
        log("Written data to CDN/CurrentInstalledVersion.json", LogLevel::Info);
    } else {
        log("Failed to write data to CDN/CurrentInstalledVersion.json", LogLevel::Error);
        return;
    }

    Json::Value newVersionJson;
    newVersionJson["installedVersion"] = latestVersion;

    IO::File versionFile(currentVersionFile, IO::FileMode::Write);
    writeSuccess = versionFile.Write(Json::Write(newVersionJson)) > 0;
    versionFile.Close();

    if (writeSuccess) {
        log("Updated installed version file: " + currentVersionFile, LogLevel::Info);
    } else {
        log("Failed to write updated version to " + currentVersionFile, LogLevel::Error);
        return;
    }

    log("Updated installed version to: " + latestVersion, LogLevel::Info);
    log("Downloading lastest version from CDN: " + latestVersion, LogLevel::Info);
}*/

void StoreDatafile(const string &in data) {
    uint64 originalDataFileSize = IO::FileSize("data/data.csv");
    string originalInstalledVersion = GetCurrentInstalledVersion(currentVersionFile); 

    IO::File dataFile;
    if (dataFile.Open("data/data.csv", IO::FileMode::Write)) {
        dataFile.Write(data);
        dataFile.Close();
        log("Attempted to write data to data/data.csv", LogLevel::Info);
    } else {
        log("Failed to open data/data.csv for writing", LogLevel::Error);
        return;
    }

    Json::Value newVersionJson;
    newVersionJson["installedVersion"] = latestVersion;

    IO::File versionFile;
    if (versionFile.Open(currentVersionFile, IO::FileMode::Write)) {
        versionFile.Write(Json::Write(newVersionJson));
        versionFile.Close();
        log("Attempted to update installed version file: " + currentVersionFile, LogLevel::Info);
    } else {
        log("Failed to open " + currentVersionFile + " for writing", LogLevel::Error);
        return;
    }

    uint64 newDataFileSize = IO::FileSize("data/data.csv");

    if (newDataFileSize != originalDataFileSize) {
        log("Data file size changed, data update was likely successful.", LogLevel::Info);
    } else {
        log("Data file size unchanged, data update may have failed.", LogLevel::Error);
    }

    string newInstalledVersion = GetCurrentInstalledVersion(currentVersionFile); 
    if (newInstalledVersion == latestVersion) {
        log("Updated installed version matches the latest version: " + latestVersion, LogLevel::Info);
    } else {
        log("Mismatch in version numbers. Latest: " + latestVersion + ", Installed: " + newInstalledVersion, LogLevel::Error);
    }
}

string GetCurrentInstalledVersion(const string &in filePath) {
    IO::FileSource versionFile(filePath);
    string fileContents = versionFile.ReadToEnd();
    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object && currentVersionJson.HasKey("installedVersion")) {
        return currentVersionJson["installedVersion"];
    }
    return "";
}


/*
void StoreDatafile(const string &in data) {
    string jsonStr = Json::Write(data);

    IO::File file;

    file.Open("CDN/CurrentInstalledVersion.json", IO::FileMode::Write);

    file.Write(jsonStr);

    file.WriteLine();

    file.Close();
}
*/