# SmartPacifier-Tool (Version 2) 
This is the evolution of our original prototype, designed to streamline sensor configuration, data acquisition, and analysis across multiple platforms—Android, iOS, Linux, and Windows. Building on the initial .NET-based solution, this version introduces expanded capabilities such as real-time monitoring, MQTT integration, and optional Docker-based data storage.

Whether you’re a researcher or developer, SmartPacifier-Tool offers:

Cross-Platform Support: A unified experience on mobile (Android, iOS) and desktop (Linux, Windows).
Sensor Integration: Seamless setup and control for PPG and other sensor data.
Advanced Analytics: Support for Python-driven algorithms to process and visualize live data.
Scalable Data Storage: Easily switch between local and remote InfluxDB instances.
Modular Architecture: Independent services for frontend, backend, and algorithm layers to enhance maintainability and extensibility.
By combining powerful data handling with a flexible architecture, SmartPacifier-Tool (Version 2) helps researchers, clinicians, and developers push the boundaries of sensor-driven health applications.






# How to build the Project
- Step 1:
- Building the BackEnd

## GTPC
```bash
cd /c/Programming/SmartPacifier-Tool/src/sp_backend/src/external_libs/grpc
git submodule update --init --recursive
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
