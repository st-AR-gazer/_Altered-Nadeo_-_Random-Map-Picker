
// void DownloadLatestData(const string &in latestVersion) {
//     Net::HttpRequest req;
//     req.Method = Net::HttpMethod::Get;
//     req.Url = url;
    
//     req.Start();

//     while (!req.Finished()) yield();

//     if (req.ResponseCode() == 200) {
//         auto data = req.String();

//         log("Fetching new data successful: " + "[DATA] - Just imagine that there are some uids here", LogLevel::Info, 83);
//         StoreDatafile(data, latestVersion);
//     } else {
//         log("Error fetching datafile: " + req.String(), LogLevel::Error, 86);
//     }
// }

void DownloadNewFiles() {
    DownloadSeasonalData();
    DownloadAlterationData();
}