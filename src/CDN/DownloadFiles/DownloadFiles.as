string NewSortingSystemUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/New-Sorting-System/";
// string OldSortingSystemUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/";

string localSaveLocation = IO::FromStorageFolder("New-Sorting-System/");

// By-Data
// By-Alteration
// By-Season

// string g_idStoragePath = IO::FromStorageFolder("id");

void DownloadFiles() {
    if (g_manifestUrl != g_currentInstalledVersion) { log("Manifest Verstion does not match local version, updating the local files with the files spesified in the maniftest.", LogLevel::Warn, 9); } else  { return; }
    
    // if (g_manifestJson["id"] == g_idStoragePath) { log("Manifest ID matches local ID, no need to update.", LogLevel::Info, 9); return; }
    
    // if (g_manifestUrl != "")
    //      { NewSortingSystemUrl = g_manifestUrl; NewSortingSystemUrl = NewSortingSystemUrl + "New-Sorting-System/"; } 
    // else { t_dataSortingSystemUrl = OldSortingSystemUrl; }

                   //Old Sorting System is deprecated
                   /*t_dataSortingSystemUrl + "data.csv"*/
    // FetchManifest();
    
    DownloadDataLoop(NewSortingSystemUrl + "By-Other/", dataFiles, localSaveLocation + "ByOther/");
    log("Attempted to downloaded all 'other' files", LogLevel::Info, 18);
    
    
    // Should maybe set first UID here if the bug from the ported code still persists
    DownloadDataLoop(NewSortingSystemUrl + "By-Season/", seasonalFiles, localSaveLocation + "BySeason/");
    log("Attempted to downloaded all season files", LogLevel::Info, 23);
    
    DownloadDataLoop(NewSortingSystemUrl + "By-Alteration/", alterationFiles, localSaveLocation + "ByAlteration/");
    log("Attempted to downloaded all alteration files", LogLevel::Info, 26);
}

void DownloadDataLoop(const string &in baseUrl, const array<string> &in files, const string &in localSaveLocation) {
    bool updateAllFiles = g_manifestJson["updatedFiles"].HasKey("*") && g_manifestJson["updatedFiles"]["*"] == "*";
    for (uint i = 0; i < files.Length; i++) {
        string localFilePath = localSaveLocation + files[i];
        if (unUpdatedFiles.Find(files[i]) != -1 || updateAllFiles/* || g_manifestJson["updatedFiles"].HasKey(files[i])*/) {
            if (!IO::FileExists(localFilePath)) {
                string url = baseUrl + files[i];
                log("Downloading updated file from: " + url, LogLevel::Info, 37);
                DownloadData(url, files[i], localSaveLocation);
                sleep(5000);
            } else {
                log("File already exists, skipping download: " + localFilePath, LogLevel::Info, 41);
            }
        } else {
            log("File not listed as updated in manifest, skipping download: " + files[i], LogLevel::Info, 44);
        }
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
        log("Fetching new data successful: " + url, LogLevel::Info, 60);
        StoreDatafile(data, fileName, localSaveLocation);
    } else {
        array<string> errorFilesThatDidNotDownloadPropperly = {url, "" + req.ResponseCode(), req.String(), fileName};
        log("File that returned an error: " + fileName, LogLevel::Error, 64);
        log("Error code: " + req.ResponseCode(), LogLevel::Error, 65);
        log("Error response: " + req.String(), LogLevel::Error, 66);
        log("Error fetching datafile from: " + url, LogLevel::Error, 67); // Keep this after removing the rest?
        print("\n");
    }
}

void StoreDatafile(const string &in data, const string &in fileName, const string &in filePath) {
    string directory = filePath;
    if (!IO::FolderExists(directory)) {
        IO::CreateFolder(directory);
    }

    string fullFilePathName = filePath + fileName;

    IO::File file;
    file.Open(fullFilePathName, IO::FileMode::Write);
    file.Write(data);
    file.Close();

    log("Data written to file: " + fullFilePathName, LogLevel::Info, 85);
}

void UpdateVersionFile(array<string>@ files) {
    Json::Value json = Json::FromFile(pluginStorageVersionPath);
    
    if (json.GetType() == Json::Type::Object) {
        json["latestVersion"] = files[files.Length - 1];
        Json::ToFile(pluginStorageVersionPath, json);
        log("Updated to the most recent version: " + files[files.Length - 1], LogLevel::Info, 94);
    } else {
        log("JSON file does not have the expected structure.", LogLevel::Error, 96);
    }
}

// Add when calling UpdateVersionFile, add corret file array 
// UpdateVersionFile(dataFiles);
// UpdateVersionFile(alterationFiles);
// UpdateVersionFile(seasonFiles);