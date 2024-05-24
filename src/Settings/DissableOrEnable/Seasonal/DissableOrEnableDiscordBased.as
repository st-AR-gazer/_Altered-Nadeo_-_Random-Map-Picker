void DeselectOrSelectAllSeasons(bool shouldSelect) {
    if (!shouldSelect) {
        DeselectWinter();
        DeselectSpring();
        DeselectSummer();
        DeselectFall();
        DeselectSeasonalOther();
    } else {
        SelectWinter();
        SelectSpring();
        SelectSummer();
        SelectFall();
        SelectSeasonalOther();
    }
}