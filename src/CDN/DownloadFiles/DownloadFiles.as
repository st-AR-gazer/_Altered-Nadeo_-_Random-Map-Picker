string baseDataUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/Data/";
string localSaveLocation = IO::FromStorageFolder("Data/");

void DownloadConsolidatedMapFile() {
    if (g_manifestVersion != g_currentInstalledVersion) {
        log("Manifest Version does not match local version, updating the local file with the version specified in the manifest.", LogLevel::Warn, 6);
    } else {
        return;
    }

    if (!shouldDownloadNewFiles) return;
    
    DownloadData(baseDataUrl + "consolidated_maps.json", "consolidated_maps.json", localSaveLocation);
    log("Attempted to download the consolidated maps JSON file", LogLevel::Info, 14);

    DownloadData(baseDataUrl + "data.csv", "data.csv", localSaveLocation);
    log("Attempted to download the data.csv file", LogLevel::Info, 17);
}

void DownloadData(const string &in url, const string &in fileName, const string &in localSaveLocation) {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = url;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        auto data = req.String();
        StoreDatafile(data, fileName, localSaveLocation);
    } else {
        log("Response code " + req.ResponseCode() + " Error URL: " + url, LogLevel::Error, 33);
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

    log("Data written to file: " + fullFilePathName, LogLevel::Info, 50);
}
