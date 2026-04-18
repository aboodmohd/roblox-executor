# Roblox Executor for macOS

A high-performance script executor for Roblox on macOS.

## Build Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/aboodmohd/roblox-executor.git
   cd roblox-executor
   ```
2. Build the project:
   ```bash
   clang++ -std=c++17 -Wall -O3 src/gui.mm -o RobloxExecutor -framework Cocoa
   ```
3. Run the executor:
   ```bash
   ./RobloxExecutor
   ```

## Note on Lua
The Lua VM integration is currently disabled to ensure successful compilation. To re-enable it, ensure `lua.hpp` is in your include path and uncomment the Lua-related code in `src/executor_backend.h`.
