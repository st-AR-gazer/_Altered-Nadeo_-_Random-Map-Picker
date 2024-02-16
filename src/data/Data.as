string pluginStorageDataPath = IO::FromStorageFolder("data.csv");
string pluginStorageVersionPath = IO::FromStorageFolder("currentInstalledVersion.json");

void NewFileCheck() {
    if (!IO::FileExists(checkFilePath) or !IO::FileExists(pluginStorageDataPath)) {
        log("initCheck file does not exist in plugin storage, moving data and currentInstalledVersion to PluginStorage", LogLevel::Warn, 7);
        
        CreateCheckFile();
        log("initCheck file created", LogLevel::Info, 13);
    } else {
        log("initCheck file exists in plugin storage, not moving data", LogLevel::Info, 15);
    }
}