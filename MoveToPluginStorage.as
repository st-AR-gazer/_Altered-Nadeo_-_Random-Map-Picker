string pluginStorageDataPath = IO::FromStorageFolder("data.csv");
string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");
string checkFilePath = IO::FromStorageFolder("initCheck.txt");

void FileCheck() {
    if (!IO::FileExists(checkFilePath)) {
        log("initCheck file does not exist in plugin storage, moving data and currentInstalledVersion to PluginStorage", LogLevel::Warn);
        MoveFileToPluginStorage("data/data.csv", pluginStorageDataPath);
        MoveFileToPluginStorage("data/currentInstalledVersion.json", pluginStorageVersionPath);
        log("Files have been moved to storage", LogLevel::Info);
        
        CreateCheckFile();
        log("initCheck file created", LogLevel::Info);
    } else {
        log("initCheck file exists in plugin storage, not moving data", LogLevel::Info);
    }
}

void MoveFileToPluginStorage(const string &in originalPath, const string &in storagePath) {
    IO::FileSource originalFile(originalPath);
    string fileContents = originalFile.ReadToEnd();

    IO::File targetFile;
    targetFile.Open(storagePath, IO::FileMode::Write);
    targetFile.Write(fileContents);
    targetFile.Close();
}

void CreateCheckFile() {
    IO::File checkFile;
    checkFile.Open(checkFilePath, IO::FileMode::Write);
    checkFile.Close();
}
