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
        if (std::string(name) == "Roblox") {
            return pid;
        }
    }
    return -1;
}

// Function to inject code into target process
bool injectIntoProcess(pid_t pid, const std::string& code) {
    task_t task;
    kern_return_t kr = task_for_pid(mach_task_self(), pid, &task);
    if (kr != KERN_SUCCESS) {
        Logger::log("ERROR: Failed to get task port for Roblox (PID: " + std::to_string(pid) + ")");
        return false;
    }

    mach_vm_address_t remote_address;
    kr = mach_vm_allocate(task, &remote_address, code.size(), VM_FLAGS_ANYWHERE);
    if (kr != KERN_SUCCESS) {
        Logger::log("ERROR: Failed to allocate memory in Roblox process.");
        return false;
    }

    kr = mach_vm_write(task, remote_address, (vm_offset_t)code.c_str(), (mach_msg_type_number_t)code.size());
    if (kr != KERN_SUCCESS) {
        Logger::log("ERROR: Failed to write code to Roblox process.");
        return false;
    }

    Logger::log("SUCCESS: Code injected at 0x" + std::to_string(remote_address));
    return true;
}

void runExecutorBackend(const std::string& url) {
    if (url.empty()) {
        Logger::log("ERROR: Empty script URL provided.");
        return;
    }

    pid_t robloxPid = findRobloxPID();
    if (robloxPid == -1) {
        Logger::log("ERROR: Roblox process not found.");
        return;
    }

    Logger::log("Found Roblox (PID: " + std::to_string(robloxPid) + "). Injecting...");
    
    // In a real scenario, we would fetch the script content first
    std::string scriptContent = "print('Injected Script')"; 
    
    if (injectIntoProcess(robloxPid, scriptContent)) {
        Logger::log("Script injection complete.");
    }
}
