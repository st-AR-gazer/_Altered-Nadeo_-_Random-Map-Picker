[Setting category="General" name="Download new files" description="If enabled, the plugin will download new files from CDN"];
bool shouldDownloadNewFiles = true;

bool toOpenMap = false;
uint64 startTime;

void Main() {
    // log("Main func has started", LogLevel::Info, 8, "Main");
    
    NadeoServices::AddAudience("NadeoClubServices");
    while (!NadeoServices::IsAuthenticated("NadeoClubServices")) { yield(); }
    startTime = Time::Now;

    if (!CheckRequiredPermissions()) {return;}
    PopulateAlterationsArrays();

    FileAndFolderCheck(); // This checks if the files are present, and if not, it will add the not present files to the nonExistingFiles array
    log("Local file check completed, fixing some files", 18, "Main");

    if (Time::Now - startTime > 20) {
        yield();
        startTime = Time::Now;
    }
    CheckCurrentInstalledVersionType(); // On legacy installs it will change the local string version to the new int format
    MoveDefaultDataFile(); // By default only the data file is installed, everything is built around using it from plugin-storage so we have to move it there first.
    GetLineCount(IO::FromStorageFolder("Data/data.csv")); // Sets the linecount, to be used in rendermenu func
    
    FetchManifest(); // This will check if the manifest file is up to date, and if not, it will download the new one, and update the local data
    log("Manifest check completed", LogLevel::InfoG, 29, "Main");

    // log("CDN check completed for new file", LogLevel::InfoG, 31, "Main");

    if (Time::Now - startTime > 20) {
        yield();
        startTime = Time::Now;
    }
    LoadMapsFromConsolidatedFile();

    while (true) {
        if (toOpenMap) {
            toOpenMap = false;
            if (useStorageObjectOverUID && IO::FileExists(IO::FromStorageFolder("Data/consolidated_maps.json"))) {
                LoadMapFromStorageObject();
            }
            if (!useStorageObjectOverUID) {
                LoadMapFromUID();
            }
        }
        yield();
        startTime = Time::Now;
    }   
}
