# SmartPacifier-Tool (Version 2) 
This is the evolution of our original prototype, designed to streamline sensor configuration, data acquisition, and analysis across multiple platforms—Android, iOS, Linux, and Windows. Building on the initial .NET-based solution, this version introduces expanded capabilities such as real-time monitoring, MQTT integration, and optional Docker-based data storage.

Whether you’re a researcher or developer, SmartPacifier-Tool offers:

Cross-Platform Support: A unified experience on mobile (Android, iOS) and desktop (Linux, Windows).
Sensor Integration: Seamless setup and control for PPG and other sensor data.
Advanced Analytics: Support for Python-driven algorithms to process and visualize live data.
Scalable Data Storage: Easily switch between local and remote InfluxDB instances.
Modular Architecture: Independent services for frontend, backend, and algorithm layers to enhance maintainability and extensibility.
By combining powerful data handling with a flexible architecture, SmartPacifier-Tool (Version 2) helps researchers, clinicians, and developers push the boundaries of sensor-driven health applications.


# Running the SmartPacifier-Tool
## Creating the Directory Structure
```bash
mkdir -p /c/Programming
cd /c/Programming
git clone https://github.com/muazzamaqeel/SmartPacifier-Tool.git
```


# Building the Whole Project
## Step 1: Building the BackEnd

## GRPC 
### 1: Cloning 
```bash
cd /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc
git submodule update --init --recursive
```
### 2: Bug Fix
- Go to the following directory:
  /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc/third_party/re2/util
- Open File "pcre.h"
- Search For: #include "util/util.h"
- One line above add this:
```c
  #include <cstdint>
```
- How it Should look now:
```c
#include <cstdint>
#include "util/util.h"
#include "re2/stringpiece.h"
```
### 3: Build & Install
```bash
cd /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc
mkdir build_grpc
cd build_grpc
cmake -G "Ninja" \
  -DCMAKE_BUILD_TYPE=Release \
  -DgRPC_SSL_PROVIDER=package \
  -DgRPC_INSTALL=ON \
  -DgRPC_BUILD_TESTS=OFF \
  -DCMAKE_INSTALL_PREFIX="C:/local/grpc" \
  ..
ninja
ninja install
```

## MQTT
```bash
cd /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp
git submodule update --init --recursive
git checkout v1.5.2
git submodule init
git submodule update
cmake -Bbuild -H. -DPAHO_WITH_MQTT_C=ON -DPAHO_BUILD_EXAMPLES=ON
$ sudo cmake --build build/ --target install
```

## Main BackEnd (C++) 
```bash
cd /c/Programming/SmartPacifier-Tool/src/sp_backend
rm -rf CMakeCache.txt CMakeFiles cmake-build-debug
cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug -S . -B cmake-build-debug
cmake --build cmake-build-debug
cmake-build-debug/sp_backend.exe
```

## Step 2 - Building the FrontEnd
## Main Dart (Flutter)
```bash
cd /c/Programming/SmartPacifier-Tool/src/smartpacifier_app
flutter run -d windows 
```
