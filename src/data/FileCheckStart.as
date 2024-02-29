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
        log("Checking default files", LogLevel::D, 33);
    } else if (type == "Season") {
        filesToCheck = seasonalFiles;
        log("Checking seasonal files", LogLevel::D, 36);
    } else if (type == "Alteration") {
        filesToCheck = alterationFiles;
        log("Checking alteration files", LogLevel::D, 39);
    } else {
        log("Unknown file type: " + type, LogLevel::Error, 41);
        return;
    }

    for (uint i = 0; i < filesToCheck.Length; i++) {
        string filePath = g_saveLocationStoragePath + GetCorrectLocation(type) + filesToCheck[i];
        if (IO::FileExists(filePath)) {
            // This log has been temporarily disabled to avoid spamming the log
            // log("File exists: " + filePath, LogLevel::D, 48);
        } else {
            nonExistingFilesArray.InsertLast(filesToCheck[i]);
            // This log has been temporarily disabled to avoid spamming the log
            // log("File does not exist: " + filePath, LogLevel::D, 51);
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
        log("Unknown file type: " + type, LogLevel::Error, 64);
        return "";
    }
}

void CheckDirs() {
    if(!IO::FolderExists(g_saveLocationStoragePath)) {
        log("Creating folder: " + g_saveLocationStoragePath, LogLevel::D, 71);
        IO::CreateFolder(g_saveLocationStoragePath);
    }

    if(!IO::FolderExists(g_saveLocationStoragePath + "By-Season/")) {
        log("Creating folder: " + g_saveLocationStoragePath + "By-Season/", LogLevel::D, 76);
        IO::CreateFolder(g_saveLocationStoragePath + "By-Season/");
    }
    if(!IO::FolderExists(g_saveLocationStoragePath + "By-Alteration/")) {
        log("Creating folder: " + g_saveLocationStoragePath + "By-Alteration/", LogLevel::D, 80);
        IO::CreateFolder(g_saveLocationStoragePath + "By-Alteration/");
    }
}