string SaveLocationStoragePath = IO::FromStorageFolder("New-Sorting-System/");

void FileCheck() {
    CheckIfFilesExist("Default");
    CheckIfFilesExist("Season");
    CheckIfFilesExist("Alteration");
}

array<string> nonExistingFiles;

void CheckIfFilesExist(string type) {
    if (type == "Default") {
        for (uint i = 0; i < dataFiles.Length; i++) {
            string filePath = SaveLocationStoragePath + dataFiles[i];
            if (IO::FileExists(filePath)) {
                log("File exists: " + filePath, LogLevel::D, 14);
            } else {
                nonExistingFiles.InsertLast(dataFiles[i]);
            }
        }
    }
    else if (type == "Season") {
        for (uint i = 0; i < seasonalFiles.Length; i++) {
            string filePath = SaveLocationStoragePath + seasonalFiles[i];
            if (IO::FileExists(filePath)) {
                log("File exists: " + filePath, LogLevel::D, 24);
            } else {
                nonExistingFiles.InsertLast(seasonalFiles[i]);
            }
        }
    }
    else if (type == "Alteration") {
        for (uint i = 0; i < alterationFiles.Length; i++) {
            string filePath = SaveLocationStoragePath + alterationFiles[i];
            if (IO::FileExists(filePath)) {
                log("File exists: " + filePath, LogLevel::D, 34);
            } else {
                nonExistingFiles.InsertLast(alterationFiles[i]);
            }
        }
    }
}