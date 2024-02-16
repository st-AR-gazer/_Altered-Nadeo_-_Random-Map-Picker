// ManifestUpdater.as
string manifestUrl = "http://maniacdn.net/ar_/Alt-Map-Picker/manifest/latestInstalledVersion.json";

void FetchAndUpdateManifest() {
    Net::HttpRequest req;
    req.Method = Net::HttpMethod::Get;
    req.Url = manifestUrl;
    
    req.Start();

    while (!req.Finished()) yield();

    if (req.ResponseCode() == 200) {
        log("Fetching manifest successful: \n" + req.String(), LogLevel::Info, 16);
        ParseManifest(req.String());
    } else {
        log("Error fetching manifest: \n" + req.String(), LogLevel::Error, 19);
    }
}