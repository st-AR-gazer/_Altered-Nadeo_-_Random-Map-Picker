namespace Profiles {
    string profilesFolder = IO::FromStorageFolder("Profiles/");

    void Initialize() {
        if (!IO::FolderExists(profilesFolder)) {
            IO::CreateFolder(profilesFolder);
        }
    }

    void DownloadProfile(const string &in url) {
        Net::HttpRequest@ req = Net::HttpGet(url);
        req.Start();
        while (!req.Finished()) {
            yield();
        }
        if (req.ResponseCode() == 200) {
            int lastSlashIndex = url.LastIndexOf("/");
            string profileName = url.SubStr(lastSlashIndex + 1);
            IO::File file(profilesFolder + profileName, IO::FileMode::Write);
            file.Write(req.String());
            file.Close();
        }
    }

    void CreateNewProfile(const string &in name) {
        Json::Value newProfile = Json::Array();
        SaveProfile(name, newProfile);
    }

    void SaveProfile(const string &in name, const Json::Value &in profile) {
        IO::File file(profilesFolder + name + ".json", IO::FileMode::Write);
        file.Write(Json::Write(profile));
        file.Close();
    }

    array<string> GetLocalProfiles() {
        array<string> profiles = {};
        array<string> files = IO::IndexFolder(profilesFolder, false);
        for (uint i = 0; i < files.Length; i++) {
            if (files[i].EndsWith(".json")) {
                profiles.InsertLast(files[i].SubStr(profilesFolder.Length));
            }
        }
        return profiles;
    }

    void LoadProfile(const string &in name) {
        string path = profilesFolder + name;
        if (IO::FileExists(path)) {
            IO::File file(path, IO::FileMode::Read);
            string content = file.ReadToEnd();
            Json::Value profile = Json::Parse(content);
            file.Close();
            ApplyProfile(profile);
        }
    }

    void ApplyProfile(const Json::Value &in profile) {
        DeselectAllSettings();
        for (uint i = 0; i < profile.Length; i++) {
            string setting = profile[i];
            SetAlteration(setting, true);
        }
    }

    Json::Value GetUserSettingsForProfile() {
        Json::Value settings = Json::Array();
        Json::Value userSettings = GetUserSettings();

        // Add logic to flatten userSettings into a JSON array
        for (int i = 0; i < userSettings["Alteration"]["Surface"].GetKeys().Length; i++) {
            string key = userSettings["Alteration"]["Surface"].GetKeys()[i];
            if (userSettings["Alteration"]["Surface"][key]) {
                settings.Add(key);
            }
        }
        for (int i = 0; i < userSettings["Alteration"]["Effects"].GetKeys().Length; i++) {
            string key = userSettings["Alteration"]["Effects"].GetKeys()[i];
            if (userSettings["Alteration"]["Effects"][key]) {
                settings.Add(key);
            }
        }
        for (int i = 0; i < userSettings["Alteration"]["Finish Location"].GetKeys().Length; i++) {
            string key = userSettings["Alteration"]["Finish Location"].GetKeys()[i];
            if (userSettings["Alteration"]["Finish Location"][key]) {
                settings.Add(key);
            }
        }
        for (int i = 0; i < userSettings["Alteration"]["Environment"].GetKeys().Length; i++) {
            string key = userSettings["Alteration"]["Environment"].GetKeys()[i];
            if (userSettings["Alteration"]["Environment"][key]) {
                settings.Add(key);
            }
        }
        for (int i = 0; i < userSettings["Alteration"]["Multi"].GetKeys().Length; i++) {
            string key = userSettings["Alteration"]["Multi"].GetKeys()[i];
            if (userSettings["Alteration"]["Multi"][key]) {
                settings.Add(key);
            }
        }
        for (int i = 0; i < userSettings["Alteration"]["Other"].GetKeys().Length; i++) {
            string key = userSettings["Alteration"]["Other"].GetKeys()[i];
            if (userSettings["Alteration"]["Other"][key]) {
                settings.Add(key);
            }
        }
        for (int i = 0; i < userSettings["Alteration"]["Extra Campaigns"].GetKeys().Length; i++) {
            string key = userSettings["Alteration"]["Extra Campaigns"].GetKeys()[i];
            if (userSettings["Alteration"]["Extra Campaigns"][key]) {
                settings.Add(key);
            }
        }
        for (int i = 0; i < userSettings["Alteration"]["Seasons"].GetKeys().Length; i++) {
            string key = userSettings["Alteration"]["Seasons"].GetKeys()[i];
            if (userSettings["Alteration"]["Seasons"][key]) {
                settings.Add(key);
            }
        }

        return settings;
    }
}
