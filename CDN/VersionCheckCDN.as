string currentVersionFile = "CDN/currentInstalledVersion.json";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/manifest.json";
string url = "http://maniacdn.net/ar_/Alt-Map-Picker/data.csv";
string currentVersionFileNEWTEST = "CDN/currentInstalledVersionNEW.json";


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

    auto test = GetCurrentInstalledVersion();

    print(test);



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

    // // PREVIOUS OPEN IS WRONG CHANGE TO THIS:
    // IO::File infoFile(currentVersionFile);
    //     currentVersionFile.Open(IO::FileMode::Read);
    //     mapFile.Open(IO::FileMode::Read);
    // //

    // if (dataFile.IsOpen()) {
    //     dataFile.Write(data);
    //     dataFile.Close();
    //     log("Data file updated successfully.", LogLevel::Info);
    // } else {
    //     log("Failed to open data file for writing.", LogLevel::Error);
    // }
}
