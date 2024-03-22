string alterationFilePath = IO::FromStorageFolder("New-Sorting-System/ByAlteration/");
string seasonalFilePath = IO::FromStorageFolder("New-Sorting-System/BySeason/");
string otherFilePath = IO::FromStorageFolder("New-Sorting-System/ByOther/");

array<string> GetAllFilesBasedOnSettings() {
    array<string> allFiles;

    array<string> seasonalFiles = GetSeasonalFiles();
    for (uint i = 0; i < seasonalFiles.Length; ++i) {
        allFiles.InsertLast(seasonalFiles[i]);
    }

    array<string> alterationFiles = GetAlterationFiles();
    for (uint i = 0; i < alterationFiles.Length; ++i) {
        allFiles.InsertLast(alterationFiles[i]);
    }

    array<string> otherFiles = GetOtherFiles();
    for (uint i = 0; i < otherFiles.Length; ++i) {
        allFiles.InsertLast(otherFiles[i]);
    }

    allFiles = RemoveDuplicates(allFiles);

    return allFiles;
}


array<string> RemoveDuplicates(const array<string>& input) {
    array<string> unique;
    dictionary seen;
    for (uint i = 0; i < input.Length; ++i) {
        if (!seen.Exists(input[i])) {
            unique.InsertLast(input[i]);
            seen[input[i]] = true;
        }
    }
    return unique;
}
