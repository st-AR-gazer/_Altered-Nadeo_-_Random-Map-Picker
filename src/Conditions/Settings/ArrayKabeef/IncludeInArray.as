string alterationFilePath = IO::FromStorageFolder("New-Sorting-System/ByAlteration/");
string seasonalFilePath = IO::FromStorageFolder("New-Sorting-System/BySeason/");
string otherFilePath = IO::FromStorageFolder("New-Sorting-System/Other/");

array<string> GetAllFilesBasedOnSettings() {
    array<string> allFiles;

    allFiles.InsertLast(GetSeasonalFiles());
    allFiles.InsertLast(GetAlterationFiles());
    allFiles.InsertLast(GetOtherFiles());

    allFiles = RemoveDuplicates(allFiles);

    return allFiles;
}

array<string> RemoveDuplicates(const array<string>& input) {
    array<string> unique;
    dictionary seen;
    for (uint i = 0; i < input.length; ++i) {
        if (!seen.exists(input[i])) {
            unique.InsertLast(input[i]);
            seen[input[i]] = true;
        }
    }
    return unique;
}
