void Main() {
    log("Main func has started", LogLevel::Info, 2);
    
    NadeoServices::AddAudience("NadeoClubServices");
    while (!NadeoServices::IsAuthenticated("NadeoClubServices")) { yield(); }

    CheckRequiredPermissions();
    log("Permission check completed", LogLevel::InfoG, 8);
    
    LegacyFileCheck();
    log("Legacy file check completed, checking for a new file version on CDN", LogLevel::InfoG, 11);
    NewFileCheck();
    log("New file check completed, checking for a new file version on CDN", LogLevel::InfoG, 13);

    sleep(1000);
    FetchAndUpdateManifest();
    GetLatestFileInfo();
    log("CDN check completed for old file", LogLevel::InfoG, 15);
    DownloadNewFiles();
    log("CDN check completed for new files", LogLevel::InfoG, 16);
    log("setting first UID", LogLevel::Info, 17);

    PopulateSeasonalFilesArray();
    log("Seasonal files array populated", LogLevel::InfoG, 18);
    PopulateAlterationsFilesArray();
    log("Alterations files array populated", LogLevel::InfoG, 20);

    SetFirstUid();
    log("First UID set, the base version of plugin is now available, and can be propperly used, only basic functionality can be set", LogLevel::InfoG, 23);
}