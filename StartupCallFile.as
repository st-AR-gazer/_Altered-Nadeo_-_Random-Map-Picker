void Main() {
    CheckRequiredPermissions();
    log("Permission check completed", LogLevel::Info, 3);
    FileCheck();
    log("File check completed, checking for a new file version on CDN", LogLevel::Info, 5);
    sleep(1000);
    GetLatestFileInfo();
    log("CDN check completed, setting first UID", LogLevel::Info, 17);
    SetFirstUid();
}