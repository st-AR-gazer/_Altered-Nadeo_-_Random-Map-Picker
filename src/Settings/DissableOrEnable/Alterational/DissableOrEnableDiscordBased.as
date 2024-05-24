void DeselectOrSelectAllAlterations(bool shouldSelect) {
    if (!shouldSelect) {
        DeselectAlteredSurface();
        DeselectAlteredEffects();
        DeselectAlteredFinishLocation();
        DeselectAlteredEnviroments();
        DeselectAlteredMulti();
        DeselectAlteredOther();
            
        IsUsing_TMGL_Easy = false;
        IsUsing__AllOfficialCompetitions = false;
        IsUsing_AllTOTD = false;
    } else {
        SelectAlteredSurface();
        SelectAlteredEffects();
        SelectAlteredFinishLocation();
        SelectAlteredEnviroments();
        SelectAlteredMulti();
        SelectAlteredOther();
            
        IsUsing_TMGL_Easy = true;
        IsUsing__AllOfficialCompetitions = true;
        IsUsing_AllTOTD = true;
    }
}