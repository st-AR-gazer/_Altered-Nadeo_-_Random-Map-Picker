string g_dataFolder = IO::FromStorageFolder("Data/");
string g_profilesFolder = IO::FromStorageFolder("Profiles/");

void FileAndFolderCheck() {
    CheckDirs();

    ShouldDeleteDownloadedManifest();
}

void CheckDirs() {
    if (!IO::FolderExists(g_dataFolder)) {
        log("Creating folder: " + g_dataFolder, LogLevel::D, 11);
        IO::CreateFolder(g_dataFolder);
    }
    if (!IO::FolderExists(g_profilesFolder)) {
        log("Creating folder: " + g_profilesFolder, LogLevel::D, 11);
        IO::CreateFolder(g_profilesFolder);
    }
}

void DoesFileExist(const string &in path, bool createFile) {
    if (IO::FileExists(path)) {
        log("File exists, not overwriting: " + path, LogLevel::Info, 18);
        return;
    }
    if (createFile) {
        IO::File f;
        f.Open(path, IO::FileMode::Write);
        f.Close();
    }
}
