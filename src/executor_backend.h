#include <iostream>
#include <string>
#include <lua.hpp>

// Backend function called by GUI
void runExecutorBackend(const std::string& url) {
    std::cout << "Backend: Fetching and executing script from " << url << std::endl;
    // Integration logic (libcurl + Lua VM + Mach Injection) would be called here
}
