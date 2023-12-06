void RenderMenu() {
    if (UI::MenuItem("Load New Altered Map", "map load")) {
        LoadNewMap();


        if (UI::BeginMenu("show debug")) {
            if (UI::MenuItem("Show debug print statements")) {
                doDevLogging = !doDevLogging;
            }
            UI::EndMenu();
        }
    }
}