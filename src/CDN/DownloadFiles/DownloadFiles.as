string NewSortingSystemUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/New-Sorting-System/";
// string OldSortingSystemUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/";

string localSaveLocation = IO::FromStorageFolder("New-Storage-System");

// By-Data
// By-Alteration
// By-Season

void DownloadFiles() {
    // if (g_manifestUrl != "")
    //      { NewSortingSystemUrl = g_manifestUrl; NewSortingSystemUrl = NewSortingSystemUrl + "New-Sorting-System/"; } 
    // else { t_dataSortingSystemUrl = OldSortingSystemUrl; }

                   //Old Sorting System is deprecated
                   /*t_dataSortingSystemUrl + "data.csv"*/
    DownloadDataLoop(NewSortingSystemUrl + "By-Other/", dataFiles, localSaveLocation + "ByOther/");
    log("Attempted to downloaded all 'other' files", LogLevel::Info, 20);
    
    
    // Should maybe set first UID here if the bug from the ported code still persists
    DownloadDataLoop(NewSortingSystemUrl + "By-Season/", seasonalFiles, localSaveLocation + "BySeason/");
    log("Attempted to downloaded all season files", LogLevel::Info, 10);
    
    DownloadDataLoop(NewSortingSystemUrl + "By-Alteration/", alterationFiles, localSaveLocation + "ByAlteration/");
    log("Attempted to downloaded all alteration files", LogLevel::Info, 13);
}

void DownloadDataLoop(const string &in baseUrl, const array<string> &in files, const string &in localSaveLocation) {
    for (uint i = 0; i < files.Length; i++) {
        string url = baseUrl + files[i];
        log("Downloading data from: " + url, LogLevel::Info, 27);
        DownloadData(url, files[i], localSaveLocation);
        sleep(5000);
    }
}

void DownloadData(const string &in url, const string &in fileName, const string &in localSaveLocation) {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        auto data = req.String();
        log("Fetching new data successful: " + url, LogLevel::Info, 44);
        StoreDatafile(data, fileName, localSaveLocation);
    } else {
        array<string> errorFilesThatDidNotDownloadPropperly = {url, req.ResponseCode().String(), req.String(), fileName};
        log("File that returned an error: " + fileName, LogLevel::Error, 46);
        log("Error code: " + req.ResponseCode(), LogLevel::Error, 47);
        log("Error response: " + req.String(), LogLevel::Error, 48);
        log("Error fetching datafile from: " + url, LogLevel::Error, 47); // Keep this after removing the rest?
        print("\n");
    }
}

void StoreDatafile(const string &in data, const string &in fileName, const string &in filePath) {
    string fullFilePathName = filePath + fileName;

    IO::File file;
    file.Open(fullFilePathName, IO::FileMode::Write);
    file.Write(data);
    file.Close();
    
    log("Attempted to store the viewing file at: " + fullFilePathName, LogLevel::Info, 60);
}

void UpdateVersionFile(array<string>@ files) {
    Json::Value json = Json::FromFile(pluginStorageVersionPath);
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = files[files.Length - 1];
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + files[files.Length - 1], LogLevel::Info, 69);
    } else {
        log("JSON file does not have the expected structure.", LogLevel::Error, 71);
    }
}

// Add when calling UpdateVersionFile, add corret file array 
// UpdateVersionFile(dataFiles);
// UpdateVersionFile(alterationFiles);
// UpdateVersionFile(seasonFiles);