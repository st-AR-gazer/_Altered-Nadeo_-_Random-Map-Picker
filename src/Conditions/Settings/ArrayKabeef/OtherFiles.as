array<string> GetOtherFiles() {
    array<string> filesToInclude;
    // ByAlteration sorting

    // Include all snow, all comp, but only comp, and all totd
    if (IsUsing_AllSnowDiscovery) {
        filesToInclude.InsertLast(seasonalFilePath + "AllSnowDiscovery.json");
    }
    if (IsUsing_AllRallyDiscovery) {
        filesToInclude.InsertLast(seasonalFilePath + "AllRallyDiscovery.json");
    }
    if (IsUsing_AllTOTD) {
        filesToInclude.InsertLast(seasonalFilePath + "AllTOTD.json");
    }
    if (IsUsing_AllOfficialCompetitions) {
        filesToInclude.InsertLast(seasonalFilePath + "AllOfficialCompetitions.json");
    }


    if (IsUsing__AllOfficialCompetitions) { // These are only the competition map, they do not have any alteration
        filesToInclude.InsertLast(alterationFilePath + "_AllOfficialCompetitions.json");
    }
    if (IsUsing_MapIsNotObtainable) {
        filesToInclude.InsertLast(alterationFilePath + "_MapIsNotObtainable.json");
    }
    if (IsUsing_OfficialNadeo) {
        filesToInclude.InsertLast(alterationFilePath + "_OfficialNadeo.json");
    }

    return filesToInclude;
}
