string NewSortingSystemUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/New-Sorting-System/";

// By-Data
// By-Alteration
// By-Season

void DownlaodFiles() {
    DownloadDataLoop(NewSortingSystemUrl + "By-Data/", dataFiles);
    // Should maybe set first UID here if the bug from the last code still persists
    log("Downloaded all data files", LogLevel::Info, 33);
    DownloadDataLoop(NewSortingSystemUrl + "By-Season/", seasonFiles);
    log("Downloaded all season files", LogLevel::Info, 35)
    DownloadDataLoop(NewSortingSystemUrl + "By-Alteration/", alterationFiles);
    log("Downloaded all alteration files", LogLevel::Info, 37);
}

void DownloadDataLoop(const string &in baseUrl, const array<string> &in files) {
    for (uint i = 0; i < files.Length; i++) {
        string url = baseUrl + files[i];
        log("Downloading data from: " + url, LogLevel::Info, 41);
        DownloadData(url, files[i]);
        sleep(5000);
    }
}

void DownloadData(const string &in url, const string &in fileName) {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        auto data = req.String();
        log("Fetching new data successful: " + url, LogLevel::Info, 58);
        StoreDatafile(data, fileName);
    } else {
        log("Error fetching datafile from: " + url, LogLevel::Error, 61);
    }
}


void StoreDatafile(const string &in data, const string &in fileName) {
    string filePath = IO::FromStorageFolder("Sorting/" + fileName);

    IO::File file;
    file.Open(filePath, IO::FileMode::Write);
    file.Write(data);
    file.Close();
    
    log("Attempted to store datafile: " + filePath, LogLevel::Info, 74);
}



void UpdateVersionFile() {
    Json::Value json = Json::FromFile(pluginStorageVersionPath);
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = Files[Files.get_Length() - 1];
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + Files[Files.get_Length() - 1], LogLevel::Info, 85);
    } else {
        log("JSON file does not have the expected structure.", LogLevel::Error, 87);
    }
}


