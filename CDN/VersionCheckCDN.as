string currentVersionFile = "CDN/currentInstalledVersion.json";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";
string url = "aaaa";
// string currentVersionFileNEWTEST = "CDN/currentInstalledVersionNEW.json";
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
    print("url is: " + url);
    string url = manifest["url"];
    print("new url is: " + url);

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

string GetCurrentInstalledVersion() {
    IO::FileSource file(currentVersionFile);

    string fileContents = file.ReadToEnd();

    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object) {
        return currentVersionJson["latestVersion"];
    }

    return "";
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
    /*IO::File dataFile;
    dataFile.Open("data/data.csv", IO::FileMode::Write);
    dataFile.Write(data);
    dataFile.Close();

    Json::Value newVersionJson;
    newVersionJson["installedVersion"] = latestVersion;

    IO::File versionFile;
    versionFile.Open(currentVersionFile, IO::FileMode::Write);
    versionFile.Write(Json::Write(newVersionJson));
    versionFile.Close();*/
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