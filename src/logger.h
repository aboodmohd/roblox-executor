#include <iostream>
#include <fstream>
#include <string>
#include <chrono>
#include <iomanip>

class Logger {
public:
    static void log(const std::string& message) {
        std::ofstream logFile("executor.log", std::ios_base::app);
        auto now = std::chrono::system_clock::now();
        auto in_time_t = std::chrono::system_clock::to_time_t(now);
        
        logFile << std::put_time(std::localtime(&in_time_t), "%Y-%m-%d %X") 
                << " - " << message << std::endl;
        std::cout << "[LOG] " << message << std::endl;
    }
};
