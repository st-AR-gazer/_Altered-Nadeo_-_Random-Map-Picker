[Setting category="General" name="Download new files" description="If enabled, the plugin will download new files from CDN"];
bool shouldDownloadNewFiles = true;

void Main() {
    // log("Main func has started", LogLevel::Info, 5);
    
    NadeoServices::AddAudience("NadeoClubServices");
    while (!NadeoServices::IsAuthenticated("NadeoClubServices")) { yield(); }

    CheckRequiredPermissions();
    PopulateAlterationsArrays();
    
    FileAndFolderCheck(); // This checks if the files are present, and if not, it will add the not present files to the nonExistingFiles array
    log("Local file check completed, fixing some files", LogLevel::InfoG, 14);

    sleep(500);
    CheckCurrentInstalledVersionType(); // On legacy installs it will change the local string version to the new int format
    MoveDefaultDataFile(); // By default only the data file is installed, everything is built around using it from plugin-storage so we have to move it there first.
    g_lineCount = GetLineCount(IO::FromStorageFolder("Data/data.csv")); // Sets the linecount, to be used in rendermenu func
    
    ManifestCheck(); // This will check if the manifest file is up to date, and if not, it will download the new one, and update the local data
    log("Manifest check completed", LogLevel::InfoG, 22);
    sleep(500);
    
    log("CDN check completed for new file", LogLevel::InfoG, 25);

    sleep(500);

    SetFirstUid();
    log("First UID set, the base version of plugin is now available, and can be propperly used, only basic functionality can be set", LogLevel::InfoG, 30);
}

void Update(float dt) {
    // CheckForSeasonSettingsChange(); // Might add automatic select / deselect in the future (if you select a season, it will deselect the other ones)
}