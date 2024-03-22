void LoadMapFromStorageObject() {
    string mapUrl = FetchRandomFileUrlFromFiles();

    if (mapUrl.Length == 0) {
        log("Failed to get map URL from storage objects", LogLevel::Error, 5);
        return;
    }

    PlayMap(mapUrl);
}

string FetchRandomFileUrlFromFiles() {
    array<string> fileNames = GetAllFilesBasedOnSettings();

    uint totalObjects = 0;
    for (uint i = 0; i < fileNames.Length; ++i) {
        Json::Value root = Json::FromFile(fileNames[i]);

        if (root.GetType() == Json::Type::Array && root.Length > 0) {
            totalObjects += root.Length;
        } else {
            log("Probably worked I guess xdd: " + fileNames[i], LogLevel::Info, 22);
        }
    }


    if (totalObjects == 0) {
        return "";
    }

    uint randomIndex = Math::Rand(0, totalObjects);
    uint currentIndex = 0;
    for (uint i = 0; i < fileNames.Length; ++i) {
        Json::Value root = Json::FromFile(fileNames[i]);
        if (root.GetType() == Json::Type::Array && currentIndex + root.Length > randomIndex) {
            uint localIndex = randomIndex - currentIndex;
            Json::Value selectedObject = root[localIndex];
            if (selectedObject.HasKey("fileUrl") && selectedObject["fileUrl"].GetType() == Json::Type::String) {
                return string(selectedObject["fileUrl"]);
            }
        }
        if (root.GetType() == Json::Type::Array) {
            currentIndex += root.Length;
        }
    }

    return "";
}

