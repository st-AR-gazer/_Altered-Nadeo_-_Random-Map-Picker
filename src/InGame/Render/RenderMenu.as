int g_lineCount;

void RenderMenu() {
    int lineCount = g_lineCount - 1;

    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z Load New Altered Map", "There are " + lineCount + " possible maps!")) {
        LoadNewMap();
    }
}

int GetLineCount(string filePath) {
    if (!IO::FileExists(filePath)) {
        log("File does not exist: " + filePath, LogLevel::Error, 13);
        return -1;
    }

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



// Add a function that checks how many UIDs are in data.csv, and displays that number besides the "Load New Altered Map", where "map load" is currently.