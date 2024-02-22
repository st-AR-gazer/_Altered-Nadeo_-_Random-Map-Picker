int g_lineCount;

void RenderMenu() {
    int lineCount = g_lineCount - 1;

    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z Load New Altered Map", "There are " + lineCount + " possible maps!")) {
        LoadNewMap();
    }
}

int GetLineCount(string filePath) {
    // Check if the file exists before opening it
    if (!IO::FileExists(filePath)) {
        log("File does not exist: " + filePath, LogLevel::Error, 14);
        return -1; // Return -1 or appropriate error code
    }

    IO::File file;
    // Attempt to open the file in read mode
    file.Open(filePath, IO::FileMode::Read);
    log("Failed to open file: " + filePath, LogLevel::Error, 21);
    return -1; // Return -1 or appropriate error code
    

    int lineCount = 0;
    while (!file.EOF()) {
        file.ReadLine();
        lineCount++;
    }
    file.Close();
    return lineCount;
}



// Add a function that checks how many UIDs are in data.csv, and displays that number besides the "Load New Altered Map", where "map load" is currently.