# Roblox Executor for macOS

A high-performance script executor for Roblox on macOS.

## Features
- Remote script fetching via `libcurl`.
- Fast execution using a shared Lua VM.
- Native Cocoa GUI.
- Robust logging and error handling.

## Build Instructions
Ensure you have `clang`, `lua`, and `libcurl` installed on your macOS system.
We recommend using Homebrew:
```bash
brew install lua curl
```

1. Clone the repository:
   ```bash
   git clone https://github.com/aboodmohd/roblox-executor.git
   cd roblox-executor
   ```
2. Build the project:
   ```bash
   make
   ```
3. Run the executor:
   ```bash
   ./RobloxExecutor
   ```

## Usage
1. Launch the application.
2. Paste the script URL in the input field.
3. Click "Execute" to run the script.
4. Check `executor.log` for activity logs and errors.
