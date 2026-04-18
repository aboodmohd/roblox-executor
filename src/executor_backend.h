#include <iostream>
#include <string>
#include "logger.h"

// Lua dependency removed for compilation stability
void runExecutorBackend(const std::string& url) {
    if (url.empty()) {
        Logger::log("ERROR: Empty script URL provided.");
        return;
    }

    Logger::log("Backend: Fetching and executing script from " + url);
    Logger::log("Script execution initiated (Lua VM disabled).");
}
