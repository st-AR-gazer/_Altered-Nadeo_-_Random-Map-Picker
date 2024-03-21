string g_saveLocationStoragePath = IO::FromStorageFolder("New-Sorting-System/");

// Arrays to hold non-existing files for each category
array<string> nonExistingDefaultFiles;
array<string> nonExistingSeasonalFiles;
array<string> nonExistingAlterationFiles;

void FileCheck() {
    CheckDirs();

    ShouldDeleteDownloadedManifest();

    CheckDefaultFiles();
    CheckSeasonalFiles();
    CheckAlterationFiles();
}

void CheckDefaultFiles() {
    CheckIfFilesExist("Default", nonExistingDefaultFiles);
}

void CheckSeasonalFiles() {
    CheckIfFilesExist("Season", nonExistingSeasonalFiles);
}

void CheckAlterationFiles() {
    CheckIfFilesExist("Alteration", nonExistingAlterationFiles);
}

void CheckIfFilesExist(string type, array<string>& nonExistingFilesArray) {
    array<string> filesToCheck;

    if (type == "Default") {
        filesToCheck = dataFiles;
        log("Checking default files", LogLevel::D, 35);
    } else if (type == "Season") {
        filesToCheck = seasonalFiles;
        log("Checking seasonal files", LogLevel::D, 38);
    } else if (type == "Alteration") {
        filesToCheck = alterationFiles;
        log("Checking alteration files", LogLevel::D, 41);
    } else {
        log("Unknown file type: " + type, LogLevel::Error, 43);
        return;
    }

    for (uint i = 0; i < filesToCheck.Length; i++) {
        string filePath = g_saveLocationStoragePath + GetCorrectLocation(type) + filesToCheck[i];
        if (IO::FileExists(filePath)) {
            // This log has been temporarily disabled to avoid spamming the log
            // log("File exists: " + filePath, LogLevel::D, 51);
        } else {
            nonExistingFilesArray.InsertLast(filesToCheck[i]);
            // This log has been temporarily disabled to avoid spamming the log
            // log("File does not exist: " + filePath, LogLevel::D, 55);
        }
    }
}

string GetCorrectLocation(string type) {
    if (type == "Default") {
        return "By-Other/";
    } else if (type == "Season") {
        return "By-Season/";
    } else if (type == "Alteration") {
        return "By-Alteration/";
    } else {
        log("Unknown file type: " + type, LogLevel::Error, 68);
        return "";
    }
}

void CheckDirs() {
    if(!IO::FolderExists(g_saveLocationStoragePath)) {
        log("Creating folder: " + g_saveLocationStoragePath, LogLevel::D, 75);
        IO::CreateFolder(g_saveLocationStoragePath);
    }

    if(!IO::FolderExists(g_saveLocationStoragePath + "By-Season/")) {
        log("Creating folder: " + g_saveLocationStoragePath + "By-Season/", LogLevel::D, 80);
        IO::CreateFolder(g_saveLocationStoragePath + "By-Season/");
    }
    if(!IO::FolderExists(g_saveLocationStoragePath + "By-Alteration/")) {
        log("Creating folder: " + g_saveLocationStoragePath + "By-Alteration/", LogLevel::D, 84);
        IO::CreateFolder(g_saveLocationStoragePath + "By-Alteration/");
    }
}


string checkFilePath2 = IO::FromStorageFolder("initCheck2.txt"); // File to check if the plugin has been initialized before the manifest version update. 
                                                                 // If it has been initialized, the local manifest file will be deleted. And it will be 
                                                                 // re-downloaded from the CDN later.

void ShouldDeleteDownloadedManifest() {
    if (!IO::FileExists(checkFilePath2)) {
        string localInstalledVersion = stringInstalledCurrentVersion();

        if ((localInstalledVersion == "0.0.0") || (localInstalledVersion == "0.0.1") || (localInstalledVersion == "0.0.2") || (localInstalledVersion == "0.0.3") || (localInstalledVersion == "0.0.4")) {
            log("Manifest file contains the old manifest structure, deleting local manifest (it will be re-added in about 2 sec xdd (probably))", LogLevel::Info, 99);
            IO::Delete(IO::FromStorageFolder("currentInstalledVersion.json"));

            CreateCheckFile2();
        } else {
            log("YEK, this should only happen if it's your first install, please ignore this if it is :ok:", LogLevel::Error, 104);
            log("(this was added as a failsafe for the like 20 people who installed the plugin before the manifest change)", LogLevel::Error, 105);
            CreateCheckFile2();
        }

    } else {
        log("initCheck file exists in plugin storage, not moving data", LogLevel::Info, 110);
    }
}

string stringInstalledCurrentVersion() {
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

void CreateCheckFile2() {
    IO::File f;
    f.Open(checkFilePath2, IO::FileMode::Write);
    f.Close();
}