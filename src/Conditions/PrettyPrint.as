string PrettyPrintJSON(const Json::Value &in value) {
    string jsonStr = Json::Write(value);
    string pretty;
    int depth = 0;
    bool inString = false;

    for (uint i = 0; i < jsonStr.Length; ++i) {
        string currentChar = jsonStr.SubStr(i, 1);

        if (currentChar == "\"") inString = !inString;

        if (!inString) {
            if (currentChar == "{" || currentChar == "[") {
                pretty += currentChar + "\n" + Indent(depth + 1);
                ++depth;
            } else if (currentChar == "}" || currentChar == "]") {
                --depth;
                pretty += "\n" + Indent(depth) + currentChar;
            } else if (currentChar == ",") {
                pretty += currentChar + "\n" + Indent(depth);
            } else if (currentChar == ":") {
                pretty += currentChar + " ";
            } else {
                pretty += currentChar;
            }
        } else {
            pretty += currentChar;
        }
    }

    return pretty;
}

string Indent(int depth) {
    string indent;
    for (int i = 0; i < depth; ++i) {
        indent += "    ";
    }
    return indent;
}
