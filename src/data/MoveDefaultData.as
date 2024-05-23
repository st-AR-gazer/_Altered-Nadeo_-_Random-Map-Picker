string pluginStorageDataPath = IO::FromStorageFolder("Data/data.csv");

string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");
string checkFilePath = IO::FromStorageFolder("initDefaultDataCheck.txt"); 


void MoveDefaultDataFile() {
    if (!IO::FileExists(checkFilePath) || !IO::FileExists(pluginStorageDataPath)) {
        log("initCheck file does not exist in plugin storage, moving data and currentInstalledVersion to PluginStorage", 9, "MoveDefaultDataFile");
        MoveFileToPluginStorage("src/DefaultData/data.csv", pluginStorageDataPath);
        MoveFileToPluginStorage("src/DefaultData/defaultInstalledVersion.json", pluginStorageVersionPath);
        log("Files have been moved to storage", LogLevel::Info, 12, "MoveDefaultDataFile");
        
        CreateDefaultDataCheckFile();
        log("initDefaultDataCheckFile created", LogLevel::Info, 15, "MoveDefaultDataFile");
    } else {
        log("initDefaultDataCheckFile exists in plugin storage, not moving data", 17, "MoveDefaultDataFile");
    }
}

void MoveFileToPluginStorage(const string &in originalPath, const string &in storagePath) {
    IO::FileSource originalFile(originalPath);
    string fileContents = originalFile.ReadToEnd();
    log("Moving the file content", LogLevel::Info, 24, "MoveFileToPluginStorage");
    log("The content:\n" + /*fileContents +*/ "The filecontents are not included since it clogs log... xdd...", LogLevel::Info, 25, "MoveFileToPluginStorage");
    // log("The content:\n" + fileContents, LogLevel::Info, 26, "MoveFileToPluginStorage");

    IO::File targetFile;
    targetFile.Open(storagePath, IO::FileMode::Write);
    targetFile.Write(fileContents);
    targetFile.Close();

    log("Finished moving the file", LogLevel::Info, 33, "MoveFileToPluginStorage");
}

void CreateDefaultDataCheckFile() {
    IO::File checkFile;
    checkFile.Open(checkFilePath, IO::FileMode::Write);
    checkFile.Close();
}



void CheckCurrentInstalledVersionType() {
    DoesFileExist(pluginStorageVersionPath, true);

    IO::File file();
    file.Open(pluginStorageVersionPath, IO::FileMode::Read);
    string fileContents = file.ReadToEnd();
    file.Close();
    
    Json::Value currentVersionJson = Json::Parse(fileContents);

    if (currentVersionJson.GetType() == Json::Type::Object) {
        if (currentVersionJson.HasKey("latestVersion")) {
            if (currentVersionJson["latestVersion"].GetType() == Json::Type::String) {
                log("Your version is a string, setting it to an int by using the default 'currentInstall' in defaultData (only happens on logacy installs)", 57, "CheckCurrentInstalledVersionType");
                MoveFileToPluginStorage("src/DefaultData/defaultInstalledVersion.json", pluginStorageVersionPath);
            }
            // log("Your version is an int, no need to change it", 60, "CheckCurrentInstalledVersionType");
        }
        // log("Your version is an object, setting it to an int by using the default 'currentInstall' in defaultData (only happens on logacy installs)", 62, "CheckCurrentInstalledVersionType");
    }
    // log("Your version is not an object :YEK:", LogLevel::Error, 64, "CheckCurrentInstalledVersionType");
}