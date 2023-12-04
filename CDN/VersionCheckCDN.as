string currentVersionFile = "currentInstalledVersion.json";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/manifest.json";
string url = "http://maniacdn.net/ar_/Alt-Map-Picker/data.csv";

string GetCurrentInstalledVersion() {
    if (IO::FileExists(currentVersionFile)) {
        IO::File file(currentVersionFile, IO::FileMode::Read);
        
        string infoFile;
        IO::File infoFile(file);
        infoFile.Open(IO::FileMode::Read);
        infoFile.Read(infoFile);
        infoFile.Close();

        Json::Value currentVersionJson = Json::Parse(infoFile);
        if (currentVersionJson.GetType() == Json::Type::Object) {
            return currentVersionJson["installedVersion"];
        }
    }
    return "";
}

// 

void GetLatestFileInfo() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req != null) {
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
        Json::Value newVersionJson;
        newVersionJson["installedVersion"] = latestVersion;

        IO::File file(currentVersionFile, IO::FileMode::Write);
        file.Write(Json::Write(newVersionJson));
        file.Close();

        log("Updated installed version to: " + latestVersion, LogLevel::Info);
        log("Downloading lastest version from CDN: " + latestVersion, LogLevel::Info);

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
void StoreDatafile(const string &in data) {
    string dataFilePath = "../data/data.csv";

    IO::File dataFile(dataFilePath, IO::FileMode::Write);

<<<<<<< HEAD
    print("Got to datafile");
    // if (dataFile.IsOpen()) {
    //     dataFile.Write(data);
    //     dataFile.Close();
    //     log("Data file updated successfully.", LogLevel::Info);
    // } else {
    //     log("Failed to open data file for writing.", LogLevel::Error);
    // }
=======
    // PREVIOUS OPEN IS WRONG CHANGE TO THIS:
    IO::File infoFile(currentVersionFile);
        currentVersionFile.Open(IO::FileMode::Read);
        mapFile.Open(IO::FileMode::Read);
    //

    if (dataFile.IsOpen()) {
        dataFile.Write(data);
        dataFile.Close();
        log("Data file updated successfully.", LogLevel::Info);
    } else {
        log("Failed to open data file for writing.", LogLevel::Error);
    }
>>>>>>> bb5b513620a26e54ba08608ae1bdd5f364215102
}
