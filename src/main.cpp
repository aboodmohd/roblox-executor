#include <iostream>
#include <lua.hpp>
#include <string>
#include <curl/curl.h>
#include <mach/mach.h>
#include <mach/mach_vm.h>
#include <libproc.h>

// Refined injection logic using Mach APIs
bool injectIntoProcess(pid_t pid, const std::string& code) {
    task_t task;
    kern_return_t kr = task_for_pid(mach_task_self(), pid, &task);
    if (kr != KERN_SUCCESS) {
        std::cerr << "Failed to get task for PID " << pid << ": " << mach_error_string(kr) << std::endl;
        return false;
    }

    mach_vm_address_t remote_address;
    kr = mach_vm_allocate(task, &remote_address, code.size(), VM_FLAGS_ANYWHERE);
    if (kr != KERN_SUCCESS) {
        std::cerr << "Failed to allocate memory in target process." << std::endl;
        return false;
    }

    kr = mach_vm_write(task, remote_address, (vm_offset_t)code.c_str(), (mach_msg_type_number_t)code.size());
    if (kr != KERN_SUCCESS) {
        std::cerr << "Failed to write memory to target process." << std::endl;
        return false;
    }

    std::cout << "Successfully injected code at address: 0x" << std::hex << remote_address << std::endl;
    return true;
}

// ... (fetchScript and other functions remain)
