#include <iostream>
#include <lua.hpp>
#include <string>
#include <curl/curl.h>

// Callback to handle data from curl
size_t WriteCallback(void* contents, size_t size, size_t nmemb, std::string* s) {
    size_t newLength = size * nmemb;
    try {
        s->append((char*)contents, newLength);
    } catch(std::bad_alloc &e) {
        return 0;
    }
    return newLength;
}

// Function to fetch script from URL
std::string fetchScript(const std::string& url) {
    CURL* curl;
    CURLcode res;
    std::string readBuffer;

    curl = curl_easy_init();
    if(curl) {
        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);
        res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);

        if(res != CURLE_OK) {
            std::cerr << "curl_easy_perform() failed: " << curl_easy_strerror(res) << std::endl;
            return "";
        }
    }
    return readBuffer;
}

void executeScript(lua_State* L, const std::string& script) {
    if (luaL_dostring(L, script.c_str()) != LUA_OK) {
        std::cerr << "Lua Error: " << lua_tostring(L, -1) << std::endl;
    }
}

int main() {
    std::string input;
    std::cout << "Enter URL to fetch script: ";
    std::getline(std::cin, input);

    std::string script = fetchScript(input);
    if (!script.empty()) {
        lua_State* L = luaL_newstate();
        luaL_openlibs(L);
        executeScript(L, script);
        lua_close(L);
    }
    return 0;
}
