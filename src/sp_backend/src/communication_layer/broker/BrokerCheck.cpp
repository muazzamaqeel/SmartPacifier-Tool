#include "BrokerCheck.h"
#ifdef _WIN32
#include <windows.h>
#include <tlhelp32.h>
#include <cstring>
#endif
#include <cstdlib>

bool BrokerCheck::isMosquittoRunning() {
#ifdef _WIN32
    bool found = false;
    HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hSnap != INVALID_HANDLE_VALUE) {
        PROCESSENTRY32 pe32;
        pe32.dwSize = sizeof(PROCESSENTRY32);
        if (Process32First(hSnap, &pe32)) {
            do {
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
    int result = system("pgrep mosquitto > /dev/null 2>&1");
    return (result == 0);
#else
    return false;
#endif
}
