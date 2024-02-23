string g_saveLocationStoragePath = IO::FromStorageFolder("New-Sorting-System/");

void FileCheck() {
    CheckDirs();

    CheckIfFilesExist("Default");
    CheckIfFilesExist("Season");
    CheckIfFilesExist("Alteration");
}

array<string> nonExistingFiles;

void CheckIfFilesExist(string type) {
    array<string> filesToCheck;

    if (type == "Default") {
        filesToCheck = dataFiles;
        log("Checking default files", LogLevel::D, 18);
    } else if (type == "Season") {
        filesToCheck = seasonalFiles;
        log("Checking seasonal files", LogLevel::D, 21);
    } else if (type == "Alteration") {
        filesToCheck = alterationFiles;
        log("Checking alteration files", LogLevel::D, 24);
    } else {
        log("Unknown file type: " + type, LogLevel::Error, 26);
        return;
    }

    for (uint i = 0; i < filesToCheck.Length; i++) {
        string filePath = g_saveLocationStoragePath + filesToCheck[i];
        if (IO::FileExists(filePath)) {
            log("File exists: " + filePath, LogLevel::D, 33);
        } else {
            nonExistingFiles.InsertLast(filesToCheck[i]);
            log("File does not exist: " + filePath, LogLevel::D, 36);
        }
    }
}

void CheckDirs() {
    if(!IO::FolderExists(g_saveLocationStoragePath)) { // Creates a new folder with new sorting system
        log("Creating folder: " + g_saveLocationStoragePath, LogLevel::D, 43);
        IO::CreateFolder(g_saveLocationStoragePath);
    }

    if(!IO::FolderExists(g_saveLocationStoragePath + "By-Other/")) {
        log("Creating folder: " + g_saveLocationStoragePath + "By-Other/", LogLevel::D, 56);
        IO::CreateFolder(g_saveLocationStoragePath + "By-Other/");
    }
    if(!IO::FolderExists(g_saveLocationStoragePath + "By-Season/")) {
        log("Creating folder: " + g_saveLocationStoragePath + "By-Season/", LogLevel::D, 48);
        IO::CreateFolder(g_saveLocationStoragePath + "By-Season/");
    }
    if(!IO::FolderExists(g_saveLocationStoragePath + "By-Alteration/")) {
        log("Creating folder: " + g_saveLocationStoragePath + "By-Alteration/", LogLevel::D, 52);
        IO::CreateFolder(g_saveLocationStoragePath + "By-Alteration/");
    }
}