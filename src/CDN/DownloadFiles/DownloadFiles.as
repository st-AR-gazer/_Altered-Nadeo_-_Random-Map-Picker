string NewSortingSystemUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/New-Sorting-System/";
string OldSortingSystemUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/";

// By-Data
// By-Alteration
// By-Season

void DownloadFiles() {
    DownloadDataLoop(NewSortingSystemUrl + "By-Data/", dataFiles);
    // Should maybe set first UID here if the bug from the ported code still persists
    log("Downloaded all data files", LogLevel::Info, 10);
    DownloadDataLoop(NewSortingSystemUrl + "By-Season/", seasonalFiles);
    log("Downloaded all season files", LogLevel::Info, 12);

    if (g_manifestUrl !is null && g_manifestUrl != "") 
         { NewSortingSystemUrl = g_manifestUrl; NewSortingSystemUrl = NewSortingSystemUrl + "New-Sorting-System/"; } 
    else { NewSortingSystemUrl = OldSortingSystemUrl; }

    DownloadDataLoop(NewSortingSystemUrl + "data.csv", alterationFiles);
    log("Downloaded all alteration files", LogLevel::Info, 14);
}

void DownloadDataLoop(const string &in baseUrl, const array<string> &in files) {
    for (uint i = 0; i < files.Length; i++) {
        string url = baseUrl + files[i];
        log("Downloading data from: " + url, LogLevel::Info, 20);
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
        log("Fetching new data successful: " + url, LogLevel::Info, 37);
        StoreDatafile(data, fileName);
    } else {
        log("Error fetching datafile from: " + url, LogLevel::Error, 40);
    }
}


void StoreDatafile(const string &in data, const string &in fileName) {
    string filePath = IO::FromStorageFolder("Sorting/" + fileName);

    IO::File file;
    file.Open(filePath, IO::FileMode::Write);
    file.Write(data);
    file.Close();
    
    log("Attempted to store datafile: " + filePath, LogLevel::Info, 53);
}

void UpdateVersionFile(array<string>@ files) {
    Json::Value json = Json::FromFile(pluginStorageVersionPath);
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = files[files.Length - 1];
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + files[files.Length - 1], LogLevel::Info, 62);
    } else {
        log("JSON file does not have the expected structure.", LogLevel::Error, 64);
    }
}

// Add when calling UpdateVersionFile, add corret file array 
// UpdateVersionFile(dataFiles);
// UpdateVersionFile(alterationFiles);
// UpdateVersionFile(seasonFiles);