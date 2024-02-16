namespace Legacy {

string pluginStorageDataPath = IO::FromStorageFolder("data.csv");
string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");
string checkFilePath = IO::FromStorageFolder("initCheck.txt");

void FileCheck() {
    if (!IO::FileExists(checkFilePath) or !IO::FileExists(pluginStorageDataPath)) {
        log("initCheck file does not exist in plugin storage, moving data and currentInstalledVersion to PluginStorage", LogLevel::Warn, 9);
        MoveFileToPluginStorage("src/Legacy/data/data.csv", pluginStorageDataPath);
        MoveFileToPluginStorage("src/Legacy/data/currentInstalledVersion.json", pluginStorageVersionPath);
        log("Files have been moved to storage", LogLevel::Info, 12);
        
        CreateCheckFile();
        log("initCheck file created", LogLevel::Info, 15);
    } else {
        log("initCheck file exists in plugin storage, not moving data", LogLevel::Info, 17);
    }
}

void MoveFileToPluginStorage(const string &in originalPath, const string &in storagePath) {
    IO::FileSource originalFile(originalPath);
    string fileContents = originalFile.ReadToEnd();
    log("Moving the file content\n" + "The content:\n" + fileContents, LogLevel::Info, 24);

    IO::File targetFile;
    targetFile.Open(storagePath, IO::FileMode::Write);
    targetFile.Write(fileContents);
    targetFile.Close();

    log("Finished moving the file", LogLevel::Info, 31);
}

void CreateCheckFile() {
    IO::File checkFile;
    checkFile.Open(checkFilePath, IO::FileMode::Write);
    checkFile.Close();
}

}
