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