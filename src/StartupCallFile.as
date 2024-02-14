void Main() {
    PopulateSeasonalFilesArray();
    CheckRequiredPermissions();
    log("Permission check completed", LogLevel::InfoG, 3);
    FileCheck();
    log("File check completed, checking for a new file version on CDN", LogLevel::InfoG, 5);
    sleep(1000);
    GetLatestFileInfo();
    log("CDN check completed, setting first UID", LogLevel::InfoG, 8);
    SetFirstUid();
    log("First UID set, plugin is now available, and can be propperly used, oly basic functionality can be set", LogLevel::InfoG, 10);
}