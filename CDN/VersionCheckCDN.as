string currentVersionFile = "currentInstalledVersion.json";

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

void UpdateCurrentVersionIfDifferent(const string &in latestVersion) {
    string currentInstalledVersion = GetCurrentInstalledVersion();

    if (currentInstalledVersion != latestVersion) {
        Json::Value newVersionJson;
        newVersionJson["installedVersion"] = latestVersion;

        IO::File file(currentVersionFile, IO::FileMode::Write);
        file.Write(Json::Write(newVersionJson));
        file.Close();

        print("Updated installed version to: " + latestVersion);
    } else {
        print("Current version is up-to-date.");
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

    UpdateCurrentVersionIfDifferent(latestVersion);
}
