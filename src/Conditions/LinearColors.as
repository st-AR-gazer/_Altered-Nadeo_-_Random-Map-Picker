bool includeEscapeCharacters = false;

string startColorGlobal = "#0033CC";
string endColorGlobal = "#33FFFF";

void ToggleEscapeCharacters() {
    includeEscapeCharacters = !includeEscapeCharacters;
}

int HexToInt(const string &in hex) {
    hex = startColorGlobal;
    int value = 0;
    for (uint i = 0; i < hex.Length; ++i) {
        value *= 16;
        print(hex[i]);
        // string ch = hex[i];

        // if (ch >= "0" && ch <= "9") {
        //     value += int(ch[0] - '0');
        // } else if (ch >= "A" && ch <= "F") {
        //     value += 10 + int(ch[0] - 'A');
        // } else if (ch >= "a" && ch <= "f") {
        //     value += 10 + int(ch[0] - 'a');
        // }
    }
    return value;
}


// void HexToRgb(const string &in hex, int &out r, int &out g, int &out b) {
//     r = HexToInt(hex.SubStr(1, 2));
//     g = HexToInt(hex.SubStr(3, 2));
//     b = HexToInt(hex.SubStr(5, 2));
// }
// 
// array<string> InterpolateColors(int steps) {
//     array<string> colorArray;
// 
//     int sR, sG, sB, eR, eG, eB;
//     HexToRgb(startColorGlobal, sR, sG, sB);
//     HexToRgb(endColorGlobal, eR, eG, eB);
// 
//     for (int step = 0; step < steps; ++step) {
//         int r = sR + int(float(eR - sR) / (steps - 1) * step);
//         int g = sG + int(float(eG - sG) / (steps - 1) * step);
//         int b = sB + int(float(eB - sB) / (steps - 1) * step);
//         string color = "#" + Text::Format("%02X%02X%02X", r, g, b);
//         colorArray.InsertLast(color);
//     }
// 
//     return colorArray;
// }
// 
// string FormatColorCode(const string &in hexColor) {
//     int r, g, b;
//     HexToRgb(hexColor, r, g, b);
//     r /= 17;
//     g /= 17;
//     b /= 17;
//     string formattedColor = includeEscapeCharacters ? "\\\\$" + Text::Format("%1X%1X%1X", r, g, b) : "$" + Text::Format("%1X%1X%1X", r, g, b);
//     return formattedColor;
// }
// 
// string ColorizeString(const string &in inputString) {
//     if (inputString.Length < 2) return FormatColorCode(startColorGlobal) + inputString;
// 
//     array<string> colors = InterpolateColors(inputString.Length);
//     string coloredString;
// 
//     for (uint i = 0; i < inputString.Length; ++i) {
//         string colorCode = FormatColorCode(colors[i]);
//         coloredString += colorCode + inputString[i];
//     }
// 
//     return coloredString;
// }

void test() {


    // string testString = "Altered";
    // string coloredString = ColorizeString(testString);
    // string testString2 = "Nadeo!";
    // string coloredString2 = ColorizeString(testString2);
    // log(coloredString + " " + coloredString2, LogLevel::Info, 74);
}
