void Main() {
    CheckRequiredPermissions();
    log("Permission check completed", LogLevel::InfoG, 3);
    FileCheck();
    log("File check completed, checking for a new file version on CDN", LogLevel::InfoG, 5);
    sleep(1000);
    GetLatestFileInfo();
    log("CDN check completed, setting first UID", LogLevel::InfoG, 17);
    SetFirstUid();
    log("First UID set, plugin is now available, and can be propperly used", LogLevel::InfoG, 17);
}