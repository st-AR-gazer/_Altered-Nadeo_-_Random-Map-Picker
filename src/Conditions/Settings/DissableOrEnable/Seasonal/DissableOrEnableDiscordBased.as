void DeselectOrSelectAllSeasons(bool shouldSelect) {
    if (!shouldSelect) {
        DeselectWinter();
        DeselectSpring();
        DeselectSummer();
        DeselectSeasonalFall();
    } else {
        SelectWinter();
        SelectSpring();
        SelectSummer();
        SelectFall();
        SelectSeasonalOther();
    }
}