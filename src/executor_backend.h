#include <iostream>
#include <string>
#include "logger.h"

void runExecutorBackend(const std::string& script) {
    if (script.empty()) {
        Logger::log("ERROR: Empty script provided.");
        return;
    }

    Logger::log("Backend: Received script content/URL.");
    Logger::log("Backend: Executing script...");
    
    // In a real scenario, we would inject this into Roblox
    Logger::log("SUCCESS: Script processed.");
}
