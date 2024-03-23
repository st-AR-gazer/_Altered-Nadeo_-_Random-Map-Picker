int g_lineCount;

void RenderMenu() {
    int lineCount = g_lineCount - 1;
    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z Load New Altered Map", "There are " + lineCount + " possible maps!")) {
        if (useStorageObjectOverUID) {
            LoadMapFromStorageObject();
        } else {
            LoadMapFromUID();
        }
    }
    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z Open Settings")) {
        if (showInterface) {
            showInterface = false;
        } else {
            showInterface = true;
        }
    }
}

int GetLineCount(string filePath) {
    log("Getting line count for file: " + filePath, LogLevel::Info, 16);
    if (!IO::FileExists(filePath)) { log("File does not exist: " + filePath, LogLevel::Error, 17); return -1; }

    int lineCount = 0;

    IO::File file;
    file.Open(filePath, IO::FileMode::Read);
    while (!file.EOF()) {
        file.ReadLine();
        lineCount++;
    }
    file.Close();
    
    return lineCount;
}

/*
void RenderMenu() {
    if (UI::MenuItem("Criminal")) {
        placeholder();
    }
    if (UI::MenuItem("Scum")) {
        placeholder2();
    }
}
*/