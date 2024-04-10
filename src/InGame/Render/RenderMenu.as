int g_lineCount;

void RenderMenu() {
    
    if (UI::MenuItem("\\$29e" + Icons::Connectdevelop + Icons::Random + "\\$z Random " + ColorizeString("Altered") + "\\$z Map", "There are " + g_lineCount + " possible maps!")) {
        if (showInterface) {
            showInterface = false;
        } else {
            showInterface = true;
        }
    }
}

void GetLineCount(const string &in filePath) {
    log("Getting line count for file: " + filePath, LogLevel::Info, 16);
    g_lineCount = -1;
    if (!IO::FileExists(filePath)) { log("File does not exist: " + filePath, LogLevel::Error, 17); return; }


    IO::File file;
    file.Open(filePath, IO::FileMode::Read);
    while (!file.EOF()) {
        file.ReadLine();
        g_lineCount++;
    }
    file.Close();
}