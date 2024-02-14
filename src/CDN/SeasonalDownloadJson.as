string seasonalFilePath = "http://maniacdn.net/ar_/Alt-Map-Picker/New-Sorting-System/By-Season/";

array<string> seasonalFiles;

void PopulateSeasonalFilesArray() {
    seasonalFiles.InsertLast("spring2020.json");
    seasonalFiles.InsertLast("summer2020.json");
    seasonalFiles.InsertLast("fall2020.json");
    seasonalFiles.InsertLast("winter2021.json");
    seasonalFiles.InsertLast("spring2021.json");
    seasonalFiles.InsertLast("summer2021.json");
    seasonalFiles.InsertLast("fall2021.json");
    seasonalFiles.InsertLast("winter2022.json");
    seasonalFiles.InsertLast("spring2022.json");
    seasonalFiles.InsertLast("summer2022.json");
    seasonalFiles.InsertLast("fall2022.json");
    seasonalFiles.InsertLast("winter2023.json");
    seasonalFiles.InsertLast("spring2023.json");
    seasonalFiles.InsertLast("summer2023.json");
    seasonalFiles.InsertLast("fall2023.json");
    seasonalFiles.InsertLast("winter2024.json");
    seasonalFiles.InsertLast("spring2024.json");
    seasonalFiles.InsertLast("summer2024.json");
    seasonalFiles.InsertLast("fall2024.json");
    seasonalFiles.InsertLast("winter2025.json");
    seasonalFiles.InsertLast("spring2025.json");
    seasonalFiles.InsertLast("summer2025.json");
    seasonalFiles.InsertLast("fall2025.json");
    seasonalFiles.InsertLast("winter2026.json");
    seasonalFiles.InsertLast("spring2026.json");
    seasonalFiles.InsertLast("summer2026.json");
    seasonalFiles.InsertLast("fall2026.json");
}

void DownloadSeasonalDataLoop() {
    for (uint i = 0; i < seasonalFiles.Length; i++) {
        string url = seasonalFilePath + seasonalFiles[i];
        log("Downloading seasonal data from: " + url, LogLevel::Info, 73);
        DownloadSeasonalData(url, seasonalFiles[i]);
        sleep(5000);
    }
}

void DownloadSeasonalData(const string &in url, const string &in fileName) {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        auto data = req.String();
        log("Fetching new data successful: " + url, LogLevel::Info, 81);
        StoreDatafile(data, fileName);
    } else {
        log("Error fetching datafile from: " + url, LogLevel::Error, 84);
    }
}


void StoreDatafile(const string &in data, const string &in fileName) {
    string filePath = IO::FromStorageFolder("SeasonalSorting/" + fileName);

    IO::File file;
    file.Open(filePath, IO::FileMode::Write);
    file.Write(data);
    file.Close();
    
    log("Attempted to store datafile: " + filePath, LogLevel::Info, 100);
}



void UpdateVersionFile() {
    Json::Value json = Json::FromFile(pluginStorageVersionPath);
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = seasonalFiles[seasonalFiles.get_Length() - 1];
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + seasonalFiles[seasonalFiles.get_Length() - 1], LogLevel::Info, 103);
    } else {
        log("JSON file does not have the expected structure.", LogLevel::Error, 105);
    }
}
