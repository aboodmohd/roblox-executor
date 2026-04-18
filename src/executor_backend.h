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

void runExecutorBackend(const std::string& script) {
    if (script.empty()) {
        Logger::log("ERROR: Empty script provided.");
        return;
    }

    initLua();
    if (!sharedL) return;

    Logger::log("Backend: Executing script via Lua VM...");
    
    int status = luaL_dostring(sharedL, script.c_str());
    if (status != LUA_OK) {
        const char* err = lua_tostring(sharedL, -1);
        Logger::log("ERROR: Lua execution failed: " + std::string(err));
        lua_pop(sharedL, 1);
    } else {
        Logger::log("SUCCESS: Script executed via Lua VM.");
    }
}
