string currentVersionFile = "currentInstalledVersion.json";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/manifest.json";
string url = "http://maniacdn.net/ar_/Alt-Map-Picker/data.csv";

string GetCurrentInstalledVersion() {
    if (IO::FileExists(currentVersionFile)) {
        IO::File file(currentVersionFile, IO::FileMode::Read);
        string fileContent;
        file.Read(fileContent);
        file.Close();

        Json::Value currentVersionJson = Json::Parse(fileContent);
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

    if (req.IsSuccessful()) {
        ParseManifest(req.String());
    } else {
        print("Error fetching manifest: " + req.String());
    }
}

void ParseManifest(const string &in reqBody) {
    Json::Value manifest = Json::Parse(reqBody);
    if (manifest.GetType() != Json::Type::Object) {
        print("Failed to parse JSON.");
        return;
    }

    string latestVersion = manifest["latestVersion"];
    string url = manifest["url"];

    UpdateCurrentVersionIfDifferent(latestVersion, url);
}

void UpdateCurrentVersionIfDifferent(const string &in latestVersion, url) {
    string currentInstalledVersion = GetCurrentInstalledVersion();

    if (currentInstalledVersion != latestVersion) {
        Json::Value newVersionJson;
        newVersionJson["installedVersion"] = latestVersion;

        IO::File file(currentVersionFile, IO::FileMode::Write);
        file.Write(Json::Write(newVersionJson));
        file.Close();

        print("Updated installed version to: " + latestVersion);
        print("Downloading lastest version from CDN: " + latestVersion);

        DownloadLatestData(url);
    } else {
        print("Current version is up-to-date.");
    }
}

void DownloadLatestData() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.IsSuccessful()) {

        auto data = req.String();

        StoreDatafile(data);
    } else {
        print("Error fetching datafile: " + req.String());
    }
}
void StoreDatafile(const string &in data) {
    string dataFilePath = "../data/data.csv";

    IO::File dataFile(dataFilePath, IO::FileMode::Write);

    if (dataFile.IsOpen()) {
        dataFile.Write(data);
        dataFile.Close();
        print("Data file updated successfully.");
    } else {
        print("Failed to open data file for writing.");
    }
}
