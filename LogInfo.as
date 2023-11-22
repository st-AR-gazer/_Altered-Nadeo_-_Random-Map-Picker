void NotifyWarn(const string &in msg) {
    UI::ShowNotification("Edition not supported", msg, vec4(1, .5, .1, .5), 10000);
}

enum LogLevel {
    Info,
    Warn,
    Error
};

void log(const string &in msg, LogLevel level = LogLevel::Info) {
    switch(level) {
        case LogLevel::Info: 
            print("[INFO] " + msg); 
            break;
        case LogLevel::Warn: 
            print("[WARN] " + msg); 
            break;
        case LogLevel::Error: 
            print("[ERROR] " + msg); 
            break;
    }
}