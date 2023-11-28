string currentVersionFile = "currentInstalledVersion.json";
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest.json";

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
    req.Url = manifestUrl;

    auto response = req.Start().Get();

    if (response.IsSuccessful()) {
        ParseManifest(response.String());
    } else {
        print("Error fetching manifest: " + response.String());
    }
}

void ParseManifest(const string &in responseBody) {
    Json::Value manifest = Json::Parse(responseBody);
    if (manifest.GetType() != Json::Type::Object) {
        print("Failed to parse JSON.");
        return;
    }

    string latestVersion = manifest["latestVersion"];
    string url = manifest["url"];

    UpdateCurrentVersionIfDifferent(latestVersion, url);
}



void GetLatestFileInfo() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;

    auto response = req.Start().Get();

    if (response.IsSuccessful()) {
        ParseManifest(response.String());
    } else {
        print("Error fetching manifest: " + response.String());
    }
}

