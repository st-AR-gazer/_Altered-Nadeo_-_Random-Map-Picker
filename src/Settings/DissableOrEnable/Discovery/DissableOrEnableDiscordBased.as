void DeselectOrSelectAllDiscoveryCampaigns(bool shouldSelect) {
    if (!shouldSelect) {
        DeselectDiscoveryCampaigns();
    } else {
        SelectDiscoveryCampaigns();
    }
}

void DeselectDiscoveryCampaigns() {
    IsUsing_AllSnowDiscovery = false;
    IsUsing_AllRallyDiscovery = false;
    IsUsing_AllDesertDiscovery = false;
}

void SelectDiscoveryCampaigns() {
    IsUsing_AllSnowDiscovery = true;
    IsUsing_AllRallyDiscovery = true;
    IsUsing_AllDesertDiscovery = true;
}