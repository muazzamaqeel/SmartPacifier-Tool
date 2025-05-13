# SmartPacifier-Tool (Version 2) 
This is the evolution of our original prototype, designed to streamline sensor configuration, data acquisition, and analysis across multiple platforms—Android, iOS, Linux, and Windows. Building on the initial .NET-based solution, this version introduces expanded capabilities such as real-time monitoring, MQTT integration, and optional Docker-based data storage.

Whether you’re a researcher or developer, SmartPacifier-Tool offers:

Cross-Platform Support: A unified experience on mobile (Android, iOS) and desktop (Linux, Windows).
Sensor Integration: Seamless setup and control for PPG and other sensor data.
Advanced Analytics: Support for Python-driven algorithms to process and visualize live data.
Scalable Data Storage: Easily switch between local and remote InfluxDB instances.
Modular Architecture: Independent services for frontend, backend, and algorithm layers to enhance maintainability and extensibility.
By combining powerful data handling with a flexible architecture, SmartPacifier-Tool (Version 2) helps researchers, clinicians, and developers push the boundaries of sensor-driven health applications.


# Running the SmartPacifier-Tool - OS (Windows)

## Building the Whole Project
### Step 1: Building the BackEnd (For Collaborators)
```bash
mkdir -p /c/Programming
cd /c/Programming
git clone --recurse-submodules https://github.com/muazzamaqeel/SmartPacifier-Tool.git

```
#### Cloning GRPC & MQTT 
```bash
mkdir -p /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc
cd /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc
git clone https://github.com/grpc/grpc.git grpc
cd grpc
git fetch --tags
git checkout v1.62.0
git submodule update --init --recursive

mkdir -p /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt
cd /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/
git clone https://github.com/eclipse/paho.mqtt.cpp.git paho.mqtt.cpp
cd paho.mqtt.cpp
git fetch --tags
git checkout v1.5.2
git submodule update --init --recursive
```

### Step 2: Building GRPC & MQTT
#### GRPC (Including - Bug Fix)
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
#### Build & Install
```bash
cd /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc
mkdir -p build_grpc && cd build_grpc
cmake -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DgRPC_SSL_PROVIDER=package \
  -DgRPC_INSTALL=ON \
  -DgRPC_BUILD_TESTS=OFF \
  -DgRPC_PROTOBUF_PROVIDER=module \
  -DCMAKE_INSTALL_PREFIX="C:/local/grpc" \
  ..
ninja
ninja install
```

#### MQTT
```bash
cd /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/mqtt/paho.mqtt.cpp
git fetch --tags
git checkout v1.5.2
git submodule update --init --recursive
mkdir -p build && cd build
cmake -S .. -B . -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DPAHO_WITH_MQTT_C=ON \
  -DPAHO_BUILD_EXAMPLES=OFF \
  -DPAHO_BUILD_SAMPLES=OFF \
  -DPAHO_BUILD_STATIC=ON \
  -DCMAKE_INSTALL_PREFIX="C:/local/paho" \
  -DCMAKE_CXX_FLAGS="-march=native"
ninja
ninja install
```

### Main BackEnd (C++) 
```bash
cd /c/Programming/SmartPacifier-Tool/src/sp_backend
rm -f src/ipc_layer/grpc/*.pb.cc \
      src/ipc_layer/grpc/*.pb.h \
      src/ipc_layer/grpc/*.grpc.pb.cc \
      src/ipc_layer/grpc/*.grpc.pb.h
rm -rf CMakeCache.txt CMakeFiles cmake-build-debug
cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug -S . -B cmake-build-debug
cmake --build cmake-build-debug
cmake-build-debug/sp_backend.exe
```

### Step 2 - Building the FrontEnd
#### Main Dart (Flutter)
```bash
cd /c/Programming/SmartPacifier-Tool/src/smartpacifier_app
flutter run -d windows 
```
