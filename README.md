# Roblox Executor for macOS

A high-performance script executor for Roblox on macOS.

## Features
- Real-time memory injection via Mach APIs (`task_for_pid`, `mach_vm_write`).
- Modern Cocoa GUI with full `Cmd+C`/`Cmd+V` support.
- Robust logging and error handling.

## Build Instructions
Ensure you have `clang` and `curl` installed on your macOS system.

1. Clone the repository:
   ```bash
   git clone https://github.com/aboodmohd/roblox-executor.git
   cd roblox-executor
   ```
2. Install dependencies (if needed):
   ```bash
   npm install
   ```

## Usage & Execution
Because this executor uses low-level Mach APIs to inject code directly into the Roblox process memory, **macOS requires root privileges**.

1. Launch the Roblox client on your Mac.
2. Run the executor with `sudo`:
   ```bash
   npm run dev:sudo
   ```
   *(You will be prompted for your Mac password)*
3. When the GUI appears, paste your script URL or content.
4. Click "Inject & Execute Script".
5. Check `executor.log` for injection status.

**Note on macOS Security:** If `npm run dev:sudo` still fails with `(os/kern) failure`, it means macOS System Integrity Protection (SIP) is blocking `task_for_pid` even for root users. In modern macOS, injecting into signed applications often requires disabling SIP or signing your executor with specific entitlements (`com.apple.security.cs.debugger`).
