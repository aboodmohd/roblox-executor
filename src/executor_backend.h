#include <iostream>
#include <string>
#include <lua.hpp>
#include "logger.h"

static lua_State* sharedL = nullptr;

void initLua() {
    if (!sharedL) {
        sharedL = luaL_newstate();
        if (!sharedL) {
            Logger::log("CRITICAL: Failed to create Lua state.");
            return;
        }
        luaL_openlibs(sharedL);
        Logger::log("Shared Lua VM initialized.");
    }
}

void runExecutorBackend(const std::string& url) {
    if (url.empty()) {
        Logger::log("ERROR: Empty script URL provided.");
        return;
    }

    initLua();
    if (!sharedL) return;

    Logger::log("Backend: Fetching and executing script from " + url);

    // Simulation of script execution with error checking
    int status = luaL_dostring(sharedL, "print('Simulated execution')");
    if (status != LUA_OK) {
        const char* err = lua_tostring(sharedL, -1);
        Logger::log("ERROR: Lua execution failed: " + std::string(err));
        lua_pop(sharedL, 1);
    } else {
        Logger::log("Script executed successfully.");
    }
}
