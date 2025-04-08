#include "BrokerCheck.h"
#ifdef _WIN32
#include <windows.h>
#include <tlhelp32.h>  // For CreateToolhelp32Snapshot, Process32First, etc.
#include <cstring>     // For _stricmp
#endif
#include <cstdlib>     // For system() on Linux

bool BrokerCheck::isMosquittoRunning() {
#ifdef _WIN32
    bool found = false;

    // Create a snapshot of all processes in the system.
    HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnap != INVALID_HANDLE_VALUE) {
        PROCESSENTRY32 pe32;
        pe32.dwSize = sizeof(PROCESSENTRY32);

        // Retrieve information about the first process.
        if (Process32First(hSnap, &pe32)) {
            do {
                // Compare the executable name (case-insensitive) to "mosquitto.exe"
                if (_stricmp(pe32.szExeFile, "mosquitto.exe") == 0) {
                    found = true;
                    break;
                }
            } while (Process32Next(hSnap, &pe32));
        }
        CloseHandle(hSnap);
    }
    return found;
#elif defined(__linux__)
    // On Linux, use pgrep to check if the process is running.
    int result = system("pgrep mosquitto > /dev/null 2>&1");
    return (result == 0);
#else
    // For unsupported systems, simply return false.
    return false;
#endif
}
