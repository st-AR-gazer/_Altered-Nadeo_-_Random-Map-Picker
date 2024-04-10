string g_dataFolder = IO::FromStorageFolder("Data/");

void FileAndFolderCheck() {
    CheckDirs();

    ShouldDeleteDownloadedManifest();
}

void CheckDirs() {
    if(!IO::FolderExists(g_dataFolder)) {
        log("Creating folder: " + g_dataFolder, LogLevel::D, 11);
        IO::CreateFolder(g_dataFolder);
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
