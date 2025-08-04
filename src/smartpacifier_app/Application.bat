@echo off
setlocal ENABLEDELAYEDEXPANSION

echo [*] Launching SmartPacifier-Tool (Frontend)...

:: Move to the script's directory
cd /d %~dp0

:: Check if protoc binary exists
if not exist tools\protoc\bin\protoc.exe (
  echo [ERROR] protoc.exe not found at tools\protoc\bin\protoc.exe
  echo Please ensure it is bundled with the project.
  pause
  exit /b
)

:: Show fake loading bar directly in this terminal
echo Please wait while setting things up...
set "bar=["
for /L %%i in (1,1,30) do (
    set "bar=!bar!#"
    cls
    echo !bar!
    ping -n 1 127.0.0.1 >nul
)

:: Clean up old generated Dart files
echo [*] Cleaning old .pb.dart files...
del /Q lib\generated\*.dart >nul 2>&1

:: Run build_runner clean and regenerate .pb.dart files
echo [*] Running build_runner clean...
call dart run build_runner clean

echo [*] Generating Protobuf Dart files...
call dart run build_runner build --delete-conflicting-outputs

:: Run the Flutter app in release mode
echo.
echo [✓] Build complete. Launching the app in release mode...
call flutter run -d windows --release

:: Keep terminal open in case of errors
echo.
echo [!] Process finished. Press any key to exit...
pause >nul
exit /b
