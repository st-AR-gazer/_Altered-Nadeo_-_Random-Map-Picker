string currentVersionFile = "CDN/currentInstalledVersion.json";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";
string url = "http://maniacdn.net/ar_/Alt-Map-Picker/data.csv";
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
    log("Updating the url, the local url is: " + url, LogLevel::Info);
    string url = manifest["url"];
    log("The url has been updated, the new url is: " + url, LogLevel::Info);

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
        log("Feching new data successfull: \n" + "[the data would be here, but there's a lot of it and I'm lazy...]", LogLevel::Info);
        StoreDatafile(data);
    } else {
        log("Error fetching datafile: " + req.String(), LogLevel::Error);
    }
}

void StoreDatafile(const string &in data) {
    /*string newDataFileContents = Json::Write(data);

    IO::File file;

    file.Open("data/data copy.csv", IO::FileMode::Write);

    file.Write(newDataFileContents);

    file.Close();*/



    Json::Value newVersionJson;
    newVersionJson["installedVersion"] = latestVersion; // Ensure latestVersion is valid here

    IO::File versionFile;
    if (versionFile.Open(currentVersionFile, IO::FileMode::Write)) {
        versionFile.Write(Json::Write(newVersionJson));
        versionFile.Close();
    } else {
        // Handle the error of not being able to open the file
    }
}



/*
void StoreDatafile(const string &in data) {

}
*/