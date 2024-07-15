// [Setting category="General" name="Enable All Settings"]
// bool enableAllSettings = false;

void SelectAllSettings() {
    SelectWinter();
    SelectSpring();
    SelectSummer();
    SelectFall();
    SelectSeasonalOther();

    SelectAlteredSurface();
    SelectAlteredEffects();
    SelectAlteredFinishLocation();
    SelectAlteredEnviroments();
    SelectAlteredGameModes();
    SelectAlteredMulti();
    SelectAlteredOther();
    SelectAlteredExtraCampaigns();

    IsUsing_AllOfficialCompetitions = true; // Sorted in ByAlteration
}