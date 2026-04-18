#include <iostream>
#include <lua.hpp>

int main() {
    std::cout << "Initializing Lua VM..." << std::endl;
    lua_State* L = luaL_newstate();
    luaL_openlibs(L);

    std::cout << "Lua VM ready. Ready to execute scripts." << std::endl;

    // Placeholder for script execution logic
    // luaL_dostring(L, "print('Hello from Lua!')");

    lua_close(L);
    return 0;
}
