[Setting category="General" name="Download new files" description="If enabled, the plugin will download new files from CDN"];
bool shouldDownloadNewFiles = true;

void Main() {
    log("Main func has started", LogLevel::Info, 5);
    
    NadeoServices::AddAudience("NadeoClubServices");
    while (!NadeoServices::IsAuthenticated("NadeoClubServices")) { yield(); }

    CheckRequiredPermissions();

    PopulateArrays(); // Hacky way to avoid inline arrays, thanks XertroV
    log("Arrays populated", LogLevel::Info, 14);
    
    FileCheck(); // This checks if the files are present, and if not, it will add the not present files to the nonExistingFiles array
    log("Local file check completed, fixing some files", LogLevel::InfoG, 17);

    ManifestCheck(); // This will check if the manifest file is up to date, and if not, it will download the new one, and update the local data
    sleep(1000);
    log("Manifest check completed", LogLevel::InfoG, 21);

    sleep(1000);
    MoveDefaultDataFile(); // By default only the data file is installed, everything is built around using it from plugin-storage so we have to move it there first.
    g_lineCount = GetLineCount("src/DefaultData/data.csv"); // Sets the linecount, to be used in rendermenu func // Fix it so that it actually goes to the correct IO::
    if (shouldDownloadNewFiles) DownloadFiles();
    log("CDN check completed for new file", LogLevel::InfoG, 25);

    sleep(1000);

    SetFirstUid();
    log("First UID set, the base version of plugin is now available, and can be propperly used, only basic functionality can be set", LogLevel::InfoG, 41);
}

void Update(float dt) {
    CheckForSeasonSettingsChange();
}