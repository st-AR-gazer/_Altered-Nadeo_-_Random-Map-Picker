string SaveLocationStoragePath = IO::FromStorageFolder("New-Sorting-System/");

void FileCheck() {
    CheckIfFilesExist("Default");
    CheckIfFilesExist("Season");
    CheckIfFilesExist("Alteration");
}

array<string> nonExistingFiles;

void CheckIfFilesExist(string type) {
    array<string> filesToCheck;

    switch(type) {
        case "Default":
            filesToCheck = dataFiles;
            log("Checking default files", LogLevel::D, 17);
            break;
        case "Season":
            filesToCheck = seasonalFiles;
            log("Checking seasonal files", LogLevel::D, 21);
            break;
        case "Alteration":
            filesToCheck = alterationFiles;
            log("Checking alteration files", LogLevel::D, 25);
            break;
        default:
            log("Unknown file type: " + type, LogLevel::Error, 28);
            return;
    }

    for (uint i = 0; i < filesToCheck.Length; i++) {
        string filePath = SaveLocationStoragePath + filesToCheck[i];
        if (IO::FileExists(filePath)) {
            log("File exists: " + filePath, LogLevel::D, 32);
        } else {
            nonExistingFiles.InsertLast(filesToCheck[i]);
        }
    }
}
