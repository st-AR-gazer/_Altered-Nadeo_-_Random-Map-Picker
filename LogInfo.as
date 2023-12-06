void NotifyWarn(const string &in msg) {
    UI::ShowNotification("Edition not supported", msg, vec4(1, .5, .1, .5), 10000);
}

enum LogLevel {
    Info,
    Warn,
    Error
};

bool doDevLogging = true;

void log(const string &in msg, LogLevel level = LogLevel::Info, int line = -1) {
    string lineInfo = line >= 0 ? "" + line : " ";
    if (doDevLogging) {
        switch(level) {
            case LogLevel::Info: 
                print("\\$0ff[INFO]" + " \\$fff" + "\\$066"+lineInfo+" \\$fff" + msg); 
                break;
            case LogLevel::Warn: 
                print("\\$ff0[WARN]" + " \\$fff" + "\\$660"+lineInfo+" \\$fff" + msg); 
                break;
            case LogLevel::Error: 
                print("\\$f00[ERROR]" + " \\$fff" + "\\$600"+lineInfo+" \\$fff" + msg); 
                break;
        }
    }
}