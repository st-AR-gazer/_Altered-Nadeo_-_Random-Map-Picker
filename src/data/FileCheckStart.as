string g_saveLocationStoragePath = IO::FromStorageFolder("New-Sorting-System/");

// Arrays to hold non-existing files for each category
array<string> nonExistingDefaultFiles;
array<string> nonExistingSeasonalFiles;
array<string> nonExistingAlterationFiles;

void FileCheck() {
    CheckDirs();

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
        string filePath = g_saveLocationStoragePath + GetCorrectLocation(type) + filesToCheck[i];
        if (IO::FileExists(filePath)) {
            log("File exists: " + filePath, LogLevel::D, 33);
        } else {
            nonExistingFilesArray.InsertLast(filesToCheck[i]);
            log("File does not exist: " + filePath, LogLevel::D, 36);
        }
    }
}

void GetCorrectLocation(string type) {
    if (type == "Default") {
        return "By-Other/";
    } else if (type == "Season") {
        return "By-Season/";
    } else if (type == "Alteration") {
        return "By-Alteration/";
    } else {
        log("Unknown file type: " + type, LogLevel::Error, 26);
        return "";
    }
}

void CheckDirs() {
    if(!IO::FolderExists(g_saveLocationStoragePath)) {
        log("Creating folder: " + g_saveLocationStoragePath, LogLevel::D, 43);
        IO::CreateFolder(g_saveLocationStoragePath);
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