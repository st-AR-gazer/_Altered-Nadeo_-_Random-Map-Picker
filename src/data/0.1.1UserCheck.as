string checkFilePath2 = IO::FromStorageFolder("initCheck2.txt"); // File to check if the plugin has been initialized before the manifest version update. 
                                                                 // If it has been initialized, the local manifest file will be deleted. And it will be 
                                                                 // re-downloaded from the CDN later.

void ShouldDeleteDownloadedManifest() {
    if (!IO::FileExists(checkFilePath2)) {
        string localInstalledVersion = stringInstalledCurrentVersion();

        if ((localInstalledVersion == "0.0.0") || (localInstalledVersion == "0.0.1") || (localInstalledVersion == "0.0.2") || (localInstalledVersion == "0.0.3") || (localInstalledVersion == "0.0.4")) {
            log("Manifest file contains the old manifest structure, deleting local manifest (it will be re-added in about 2 sec xdd (probably))", 10, "ShouldDeleteDownloadedManifest");
            IO::Delete(IO::FromStorageFolder("currentInstalledVersion.json"));

            CreateCheckFile2();
        } else {
            log("YEK, this should only happen if it's your first install, 15, "ShouldDeleteDownloadedManifest");
            log("(this was added as a failsafe for the like 20 people who installed the plugin before the manifest change)", LogLevel::Error, 16, "ShouldDeleteDownloadedManifest");
            CreateCheckFile2();
        }

    } else {
        log("initCheck file exists in plugin storage, not moving data", 21, "ShouldDeleteDownloadedManifest");
    }
}

void CreateCheckFile2() {
    IO::File f;
    f.Open(checkFilePath2, IO::FileMode::Write);
    f.Close();
}

// string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");

string stringInstalledCurrentVersion() {
    DoesFileExist(pluginStorageVersionPath, true);

    IO::File file();
    file.Open(pluginStorageVersionPath, IO::FileMode::Read);
    string fileContents = file.ReadToEnd();
    file.Close();
    
    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object) {
        return currentVersionJson["latestVersion"];
    }

    return "";
}