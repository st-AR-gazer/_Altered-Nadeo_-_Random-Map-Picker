int g_lineCount;

void RenderMenu() {
    int lineCount = g_lineCount - 1;

    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z Load New Altered Map", "There are " + lineCount + " possible maps!")) {
        LoadNewMap();
    }
}

int GetLineCount(const string& filePath) {
    File@ file = File();
    if (file.Open(filePath, IO::FileMode::Read)) {
        int lineCount = 0;
        while (!file.EOFReached()) {
            file.ReadLine();
            lineCount++;
        }
        file.Close();
        return lineCount;
    }
    return 0;
}


// Add a function that checks how many UIDs are in data.csv, and displays that number besides the "Load New Altered Map", where "map load" is currently.