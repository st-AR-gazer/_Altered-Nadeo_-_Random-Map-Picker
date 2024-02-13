string seasonalFilePath = "http://maniacdn.net/ar_/Alt-Map-Picker/New-Sorting-System/By-Season/";

string[] seasonalFiles = {
    "spring2020.json",
    "summer2020.json",
    "fall2020.json",
    "winter2021.json",
    "spring2021.json",
    "summer2021.json",
    "fall2021.json",
    "winter2022.json",
    "spring2022.json",
    "summer2022.json",
    "fall2022.json",
    "winter2023.json",
    "spring2023.json",
    "summer2023.json",
    "fall2023.json",
    "winter2024.json",
    "spring2024.json",
    "summer2024.json",
    "fall2024.json",
    "winter2025.json",
    "spring2025.json",
    "summer2025.json",
    "fall2025.json",
    "winter2026.json",
    "spring2026.json",
    "summer2026.json",
    "fall2026.json"
};

void DownloadSeasonalDataLoop() {
    for (int i = 0; i < seasonalFiles.Length(); i++) {
        string url = seasonalFilePath + seasonalFiles[i];
        if seasonalFiles[i] == null or seasonalFiles[i].Length() == 0 {
            log("Null has been reached, assuming end of altered seasonal maps" + url, LogLevel::Info, 73);
            break;
        }
        log("Downloading seasonal data from: " + url, LogLevel::Info, 73);
        DownloadSeasonalData(url);
        sleep(5000);
    }
}

void DownloadSeasonalData(const string& in url) {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        auto data = req.String();

        log("Fetching new data successful: " + "$f0f" if(data.Length) print("[DATA]");, LogLevel::Info, 81);
        StoreDatafile(data);
    } else {
        log("Error fetching datafile: " + req.String(), LogLevel::Error, 84);
    }
}

void StoreDatafile(const string& in data) {
    IO::File file;
    file.Open(pluginStorageDataPath, IO::FileMode::Write);
    file.Write(data);
    file.Close();

    UpdateVersionFile();
}

void UpdateVersionFile() {
    Json::Value json = Json::FromFile(pluginStorageVersionPath); 
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = seasonalFiles[seasonalFiles.length() - 1];
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + seasonalFiles[seasonalFiles.length() - 1], LogLevel::Info, 103);
    } else {
        log("JSON file does not have the expected structure.\n" + " Json type is: \n" + json.GetType(), LogLevel::Error, 105);
    }
}