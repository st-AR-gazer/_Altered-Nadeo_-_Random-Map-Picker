bool includeEscapeCharacters = false;

string startColorGlobal = "#0033CC";
string endColorGlobal = "#33FFFF";

void ToggleEscapeCharacters() {
    includeEscapeCharacters = !includeEscapeCharacters;
}

int HexToInt(const string &in hex) {
    int value = 0;
    for (uint i = 0; i < hex.Length; ++i) {
        value *= 16;
        int charValue = int(hex[i]);
        if (charValue >= int('0') && charValue <= int('9')) value += charValue - int('0');
        else if (charValue >= int('A') && charValue <= int('F')) value += 10 + (charValue - int('A'));
        else if (charValue >= int('a') && charValue <= int('f')) value += 10 + (charValue - int('a'));
    }
    return value;
}

void HexToRgb(const string &in hex, int &out r, int &out g, int &out b) {
    r = HexToInt(hex.SubStr(1, 2));
    g = HexToInt(hex.SubStr(3, 2));
    b = HexToInt(hex.SubStr(5, 2));
}

array<string> InterpolateColors(int steps) {
    array<string> colorArray;

    int sR, sG, sB, eR, eG, eB;
    HexToRgb(startColorGlobal, sR, sG, sB);
    HexToRgb(endColorGlobal, eR, eG, eB);

    for (int step = 0; step < steps; ++step) {
        int r = sR + int(float(eR - sR) / (steps - 1) * step);
        int g = sG + int(float(eG - sG) / (steps - 1) * step);
        int b = sB + int(float(eB - sB) / (steps - 1) * step);

        string rHex = Text::Format("%02X", r);
        string gHex = Text::Format("%02X", g);
        string bHex = Text::Format("%02X", b);

        string color = "#" + rHex + gHex + bHex;
        colorArray.InsertLast(color);
    }

    return colorArray;
}

string FormatColorCode(const string &in hexColor) {
    int r, g, b;
    HexToRgb(hexColor, r, g, b);
    r /= 17;
    g /= 17;
    b /= 17;

    string rHex = Text::Format("%1X", r);
    string gHex = Text::Format("%1X", g);
    string bHex = Text::Format("%1X", b);

    rHex = rHex.Length < 2 ? "0" + rHex : rHex;
    gHex = gHex.Length < 2 ? "0" + gHex : gHex;
    bHex = bHex.Length < 2 ? "0" + bHex : bHex;

    string formattedColor = includeEscapeCharacters ? "\\\\$" : "$";
    formattedColor += rHex + gHex + bHex;

    return formattedColor;
}

string ColorizeString(const string &in inputString) {
    if (inputString.Length < 2) return FormatColorCode(startColorGlobal) + inputString;

    array<string> colors = InterpolateColors(inputString.Length);
    string coloredString;

    for (uint i = 0; i < inputString.Length; ++i) {
        string colorCode = FormatColorCode(colors[i]);
        coloredString += colorCode + inputString[i];
    }

    return coloredString;
}

void test() {
    string testString = "Altered";
    string coloredString = ColorizeString(testString);
    string testString2 = "Nadeo!";
    string coloredString2 = ColorizeString(testString2);
    log(coloredString + " " + coloredString2, LogLevel::Info, 74);
}
