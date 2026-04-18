#include <iostream>
#include <string>
#include <lua.hpp>
#include "logger.h"

static lua_State* sharedL = nullptr;

// Mock game:HttpGet function
static int mock_httpGet(lua_State* L) {
    const char* url = luaL_checkstring(L, 2); // Argument 1 is 'game' (self), Argument 2 is URL
    Logger::log("Mock HttpGet called with URL: " + std::string(url));
    lua_pushstring(L, "print('Mock script fetched from URL')"); // Return a dummy script
    return 1; // Number of return values
}

void initLua() {
    if (!sharedL) {
        sharedL = luaL_newstate();
        if (!sharedL) {
            Logger::log("CRITICAL: Failed to create Lua state.");
            return;
        }
        luaL_openlibs(sharedL);
        
        // Mock the 'game' object and 'HttpGet' method
        lua_newtable(sharedL); // Create 'game' table
        lua_pushcfunction(sharedL, mock_httpGet); // Push function
        lua_setfield(sharedL, -2, "HttpGet"); // game.HttpGet = mock_httpGet
        lua_setglobal(sharedL, "game"); // _G.game = table

        // Mock 'loadstring' (standard Lua 5.5 has load, but Roblox uses loadstring)
        lua_getglobal(sharedL, "load");
        lua_setglobal(sharedL, "loadstring");

        Logger::log("Shared Lua VM initialized with Roblox mocks.");
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
