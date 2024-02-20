
void DownloadNewFiles() {
    DownloadDataLoop(BySeasonFilePath, seasonalFiles);
    DownloadDataLoop(ByAlterationFilePath, alterationFiles);
}