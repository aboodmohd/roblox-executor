#include <iostream>
#include <string>
#include <vector>
#include <mach/mach.h>
#include <mach/mach_vm.h>
#include <libproc.h>
#include "logger.h"

// Function to find Roblox process PID
pid_t findRobloxPID() {
    int numberOfProcesses = proc_listpids(PROC_ALL_PIDS, 0, NULL, 0);
    std::vector<pid_t> pids(numberOfProcesses);
    proc_listpids(PROC_ALL_PIDS, 0, pids.data(), sizeof(pid_t) * numberOfProcesses);

    for (pid_t pid : pids) {
        char name[PROC_PIDPATHINFO_MAXSIZE];
        proc_name(pid, name, sizeof(name));
        // Roblox process on macOS is usually named "RobloxPlayer" or "Roblox"
        if (std::string(name) == "RobloxPlayer" || std::string(name) == "Roblox") {
            return pid;
        }
    }
    return -1;
}

// Function to inject code into target process using Mach APIs
bool injectIntoProcess(pid_t pid, const std::string& code) {
    task_t task;
    // Note: task_for_pid requires root privileges (sudo) or the app to be signed with task_for_pid-allow entitlement
    kern_return_t kr = task_for_pid(mach_task_self(), pid, &task);
    if (kr != KERN_SUCCESS) {
        Logger::log("ERROR: Failed to get task port for Roblox (PID: " + std::to_string(pid) + "). Error: " + std::string(mach_error_string(kr)));
        Logger::log("HINT: You may need to run the executor with 'sudo' (e.g., sudo ./RobloxExecutor) to allow memory injection.");
        return false;
    }

    mach_vm_address_t remote_address;
    kr = mach_vm_allocate(task, &remote_address, code.size() + 1, VM_FLAGS_ANYWHERE);
    if (kr != KERN_SUCCESS) {
        Logger::log("ERROR: Failed to allocate memory in Roblox process.");
        return false;
    }

    kr = mach_vm_write(task, remote_address, (vm_offset_t)code.c_str(), (mach_msg_type_number_t)code.size() + 1);
    if (kr != KERN_SUCCESS) {
        Logger::log("ERROR: Failed to write code to Roblox process.");
        return false;
    }

    Logger::log("SUCCESS: Script payload injected at memory address: 0x" + std::to_string(remote_address));
    Logger::log("NOTE: A full executor requires a thread hijacker/execution engine inside the Roblox process to read this memory and execute it. This is a basic memory write.");
    return true;
}

void runExecutorBackend(const std::string& script) {
    if (script.empty()) {
        Logger::log("ERROR: Empty script provided.");
        return;
    }

    Logger::log("Backend: Scanning for active Roblox process...");
    pid_t robloxPid = findRobloxPID();
    
    if (robloxPid == -1) {
        Logger::log("ERROR: Roblox process not found. Please launch Roblox first.");
        return;
    }

    Logger::log("Found Roblox (PID: " + std::to_string(robloxPid) + "). Attempting injection...");
    
    if (injectIntoProcess(robloxPid, script)) {
        Logger::log("Injection routine completed.");
    } else {
        Logger::log("Injection routine failed.");
    }
}
