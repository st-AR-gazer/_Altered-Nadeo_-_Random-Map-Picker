array<string> GetSeasonalFiles() {
    array<string> filesToInclude;

    if (IsUsing_OnlyWinterMaps) {
        filesToInclude.InsertLast(seasonalFilePath + "Winter2021.json");
        filesToInclude.InsertLast(seasonalFilePath + "Winter2022.json");
        filesToInclude.InsertLast(seasonalFilePath + "Winter2023.json");
        filesToInclude.InsertLast(seasonalFilePath + "Winter2024.json");
        filesToInclude.InsertLast(seasonalFilePath + "Winter2025.json");
    }
    if (IsUsing_OnlySpringMaps) {
        filesToInclude.InsertLast(seasonalFilePath + "Spring2020.json");
        filesToInclude.InsertLast(seasonalFilePath + "Spring2021.json");
        filesToInclude.InsertLast(seasonalFilePath + "Spring2022.json");
        filesToInclude.InsertLast(seasonalFilePath + "Spring2023.json");
        filesToInclude.InsertLast(seasonalFilePath + "Spring2024.json");
        filesToInclude.InsertLast(seasonalFilePath + "Spring2025.json");
    }
    if (IsUsing_OnlySummerMaps) {
        filesToInclude.InsertLast(seasonalFilePath + "Summer2020.json");
        filesToInclude.InsertLast(seasonalFilePath + "Summer2021.json");
        filesToInclude.InsertLast(seasonalFilePath + "Summer2022.json");
        filesToInclude.InsertLast(seasonalFilePath + "Summer2023.json");
        filesToInclude.InsertLast(seasonalFilePath + "Summer2024.json");
        filesToInclude.InsertLast(seasonalFilePath + "Summer2025.json");
    }
    if (IsUsing_OnlyFallMaps) {
        filesToInclude.InsertLast(seasonalFilePath + "Fall2020.json");
        filesToInclude.InsertLast(seasonalFilePath + "Fall2021.json");
        filesToInclude.InsertLast(seasonalFilePath + "Fall2022.json");
        filesToInclude.InsertLast(seasonalFilePath + "Fall2023.json");
        filesToInclude.InsertLast(seasonalFilePath + "Fall2024.json");
        filesToInclude.InsertLast(seasonalFilePath + "Fall2025.json");
    }

    if (IsUsing_Spring2020Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Spring2020.json");
    }
    if (IsUsing_Summer2020Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Summer2020.json");
    }
    if (IsUsing_Fall2020Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Fall2020.json");
    }
    if (IsUsing_Winter2021Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Winter2021.json");
    }
    if (IsUsing_Spring2021Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Spring2021.json");
    }
    if (IsUsing_Summer2021Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Summer2021.json");
    }
    if (IsUsing_Fall2021Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Fall2021.json");
    }
    if (IsUsing_Winter2022Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Winter2022.json");
    }
    if (IsUsing_Spring2022Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Spring2022.json");
    }
    if (IsUsing_Summer2022Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Summer2022.json");
    }
    if (IsUsing_Fall2022Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Fall2022.json");
    }
    if (IsUsing_Winter2023Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Winter2023.json");
    }
    if (IsUsing_Spring2023Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Spring2023.json");
    }
    if (IsUsing_Summer2023Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Summer2023.json");
    }
    if (IsUsing_Fall2023Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Fall2023.json");
    }
    if (IsUsing_Winter2024Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Winter2024.json");
    }
    if (IsUsing_Spring2024Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Spring2024.json");
    }
    if (IsUsing_Summer2024Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Summer2024.json");
    }
    if (IsUsing_Fall2024Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Fall2024.json");
    }
    if (IsUsing_Winter2025Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Winter2025.json");
    }
    if (IsUsing_Spring2025Maps) {
        filesToInclude.InsertLast(seasonalFilePath + "Spring2025.json");
    }
    
    return filesToInclude;
}
