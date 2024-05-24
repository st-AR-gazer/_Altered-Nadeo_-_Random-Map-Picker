// [Setting category="General" name="Deselect All Settings"]
// bool deselectAllSettings = false;

void DeselectAllSettings() {
    DeselectWinter();
    DeselectSpring();
    DeselectSummer();
    DeselectFall();
    DeselectSeasonalOther();

    DeselectAlteredSurface();
    DeselectAlteredEffects();
    DeselectAlteredFinishLocation();
    DeselectAlteredEnviroments();
    DeselectAlteredMulti();
    DeselectAlteredOther();
    DeselectAlteredExtraCampaigns();

    IsUsing_AllOfficialCompetitions = false; // Sorted in ByAlteration
}