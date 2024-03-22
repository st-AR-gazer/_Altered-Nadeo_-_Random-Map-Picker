bool placeholderValue;
bool showInterface;

int currentTab;

void RenderInterface() {
    if (!showInterface) {return;}
    if (GetApp() is null) {showInterface = false; return;}
    //if (cast<CGameCtnEditorFree>(GetApp().Editor) is null) {showInterface = false; return;}

    UI::SetNextWindowPos(100, 100, UI::Cond::Once);
    switch (currentTab) {
    case 0:
        UI::SetNextWindowSize(300, 0, UI::Cond::Always);
        break;
    case 1:
        UI::SetNextWindowSize(300, 0, UI::Cond::Always);
        break;
    case 2:
        UI::SetNextWindowSize(300, 0, UI::Cond::Always);
        break;
    default:
        UI::SetNextWindowSize(300, 0, UI::Cond::Always);
        break;
    }

    if (UI::Begin("Altered Campaign Helper", showInterface, UI::WindowFlags::NoResize)) {

        UI::BeginTabBar("HUH who uses more than 1 tab bar?", UI::TabBarFlags::NoCloseWithMiddleMouseButton);
        UI::PushStyleColor(UI::Col::Tab, vec4(0.5, 0.5, 0.5, 0.75));
        UI::PushStyleColor(UI::Col::TabHovered, vec4(1.2, 1.2, 1.2, 0.85));
        UI::PushStyleColor(UI::Col::TabActive, vec4(0.5, 0.5, 0.5, 1.0));

        if (UI::BeginTabItem("Altered Surfaces")) {
            currentTab = 0;
            UI::Text('All the altered nadeo surface alterations');
            UI::SameLine();
            UI::Text("There are currently " + "[PLACEHOLDER]" + " altered surfaces");

            bool newValue;

            newValue = UI::Checkbox('Dirt', IsUsing_Dirt);
            if (newValue != IsUsing_Dirt) { IsUsing_Dirt = newValue; }

            newValue = UI::Checkbox('Fast-Magnet', IsUsing_Fast_Magnet);
            if (newValue != IsUsing_Fast_Magnet) { IsUsing_Fast_Magnet = newValue; }
            
            newValue = UI::Checkbox('Flooded', IsUsing_Flooded);
            if (newValue != IsUsing_Flooded) { IsUsing_Flooded = newValue; }
            
            newValue = UI::Checkbox('Grass', IsUsing_Grass);
            if (newValue != IsUsing_Grass) { IsUsing_Grass = newValue; }
            
            newValue = UI::Checkbox('Ice', IsUsing_Ice);
            if (newValue != IsUsing_Ice) { IsUsing_Ice = newValue; }
            
            newValue = UI::Checkbox('Magnet', IsUsing_Magnet);
            if (newValue != IsUsing_Magnet) { IsUsing_Magnet = newValue; }
            
            newValue = UI::Checkbox('Mixed', IsUsing_Mixed);
            if (newValue != IsUsing_Mixed) { IsUsing_Mixed = newValue; }

            newValue = UI::Checkbox('Penalty', IsUsing_Penalty);
            if (newValue != IsUsing_Penalty) { IsUsing_Penalty = newValue; }

            newValue = UI::Checkbox('Plastic', IsUsing_Plastic);
            if (newValue != IsUsing_Plastic) { IsUsing_Plastic = newValue; }

            newValue = UI::Checkbox('Road', IsUsing_Wood);
            if (newValue != IsUsing_Wood) { IsUsing_Wood = newValue; }

            newValue = UI::Checkbox('Bobsleigh', IsUsing_Bobsleigh);
            if (newValue != IsUsing_Bobsleigh) { IsUsing_Bobsleigh = newValue; }
            
            newValue = UI::Checkbox('Pipe', IsUsing_Pipe);
            if (newValue != IsUsing_Pipe) { IsUsing_Pipe = newValue; }
            
            newValue = UI::Checkbox('Sausage', IsUsing_Sausage);
            if (newValue != IsUsing_Sausage) { IsUsing_Sausage = newValue; }
            
            newValue = UI::Checkbox('Surfaceless', IsUsing_Surfaceless);
            if (newValue != IsUsing_Surfaceless) { IsUsing_Surfaceless = newValue; }
            
            newValue = UI::Checkbox('Underwater', IsUsing_Underwater);
            if (newValue != IsUsing_Underwater) { IsUsing_Underwater = newValue; }

            UI::Separator();

            UI::EndTabItem();
        }
        





        UI::PopStyleColor(3);
        UI::PushStyleColor(UI::Col::Tab, vec4(0.5, 0.5, 0.5, 0.75));
        UI::PushStyleColor(UI::Col::TabHovered, vec4(1.2, 1.2, 1.2, 0.85));
        UI::PushStyleColor(UI::Col::TabActive, vec4(0.5, 0.5, 0.5, 1.0));
        if (UI::BeginTabItem("Misc")) {
            currentTab = 2;
            placeholderValue = UI::Checkbox('###autoColor', placeholderValue);
            UI::SameLine();
            UI::TextWrapped('Auto select colour when opening a campaign (or altered campaign) map in editor');
            placeholderValue = UI::Checkbox('###cpWarning', placeholderValue);
            UI::SameLine();
            UI::TextWrapped('Warn if the checkpoint count is different to the unaltered map \n(when entering drive mode)');
            placeholderValue = UI::Checkbox('###nameColor', placeholderValue);
            UI::SameLine();
            UI::TextWrapped('Color the name in plugins list');
            UI::Text('Variant highlight mode:');
            if (UI::BeginCombo('##0', "test", UI::ComboFlags::None)) {
                if (UI::Selectable("placeholder", placeholderValue, UI::SelectableFlags::None)) {
                    placeholderValue = placeholderValue;
                }
                
                UI::EndCombo();
            }
            placeholderValue = UI::Checkbox('###overlayhitbox', placeholderValue);
            UI::SameLine();
            UI::TextWrapped('Require hitbox match on custom overlays (may have issues on support mode tilt/slope blocks)\n(not checked on checkpoints)');
            placeholderValue = UI::Checkbox('###debugDots', placeholderValue);
            UI::SameLine();
            UI::TextWrapped('Show debug position dots');

            UI::EndTabItem();
        }
        UI::PopStyleColor(3);
        UI::EndTabBar();
    }
    /*if (shouldRefresh) {
        checkNoFilters();
    }*/
    UI::End();
}