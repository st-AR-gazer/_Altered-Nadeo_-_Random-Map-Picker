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
            int lastSlashIndex = _Text::LastIndexOf(url, "/");
            string profileName = url.SubStr(lastSlashIndex + 1);
            IO::File file(profilesFolder + profileName, IO::FileMode::Write);
            file.Write(req.String());
            file.Close();
        }
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
        log("Loading profile: " + path, LogLevel::Info, 44, "LoadProfile");
        if (IO::FileExists(path)) {
            IO::File file(path, IO::FileMode::Read);
            string content = file.ReadToEnd();
            Json::Value profile = Json::Parse(content);
            file.Close();
            ApplyProfile(profile);
        }
    }

    void DeleteProfile(const string &in name) {
        string path = profilesFolder + name;
        if (IO::FileExists(path)) {
            IO::Delete(path);
        }
    }

    void ApplyProfile(const Json::Value &in profile) {
        DeselectAllSettings();
        Json::Value userSettings = GetUserSettings();

        for (uint i = 0; i < profile.Length; i++) {
            string setting = profile[i];
            if (userSettings["Alteration"]["Surface"].HasKey(setting)) {
                SetAlteration(setting, true);
            } else if (userSettings["Alteration"]["Effects"].HasKey(setting)) {
                SetAlteration(setting, true);
            } else if (userSettings["Alteration"]["Finish Location"].HasKey(setting)) {
                SetAlteration(setting, true);
            } else if (userSettings["Alteration"]["Environment"].HasKey(setting)) {
                SetAlteration(setting, true);
            } else if (userSettings["Alteration"]["Multi"].HasKey(setting)) {
                SetAlteration(setting, true);
            } else if (userSettings["Alteration"]["Other"].HasKey(setting)) {
                SetAlteration(setting, true);
            } else if (userSettings["Alteration"]["Extra Campaigns"].HasKey(setting)) {
                SetAlteration(setting, true);
            } else if (userSettings["Alteration"]["Seasons"].HasKey(setting)) {
                SetSeason(setting, true);
            }
        }
    }

    void AddSettingsToProfile(const Json::Value &in settingsObject, Json::Value &inout profile) {
        array<string> keys = settingsObject.GetKeys();
        for (uint i = 0; i < keys.Length; i++) {
            string key = keys[i];
            Json::Value settingValue = settingsObject[key];
            if (settingValue.GetType() == Json::Type::Boolean && bool(settingValue)) {
                profile.Add(key);
            }
        }
    }

    Json::Value GetUserSettingsForProfile() {
        Json::Value profile = Json::Array();
        Json::Value userSettings = GetUserSettings();

        AddSettingsToProfile(userSettings["Alteration"]["Surface"], profile);
        AddSettingsToProfile(userSettings["Alteration"]["Effects"], profile);
        AddSettingsToProfile(userSettings["Alteration"]["Finish Location"], profile);
        AddSettingsToProfile(userSettings["Alteration"]["Environment"], profile);
        AddSettingsToProfile(userSettings["Alteration"]["Multi"], profile);
        AddSettingsToProfile(userSettings["Alteration"]["Other"], profile);
        AddSettingsToProfile(userSettings["Alteration"]["Extra Campaigns"], profile);
        AddSettingsToProfile(userSettings["Alteration"]["Seasons"], profile);

        return profile;
    }
}
