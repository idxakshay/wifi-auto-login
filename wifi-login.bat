@echo off
setlocal enabledelayedexpansion

:: Set the SSID of the WiFi network
set SSID=91springboard

:: Set the path for the credentials file
set SBC_FOLDER=%USERPROFILE%\.sbc
set CREDENTIALS_FILE=%SBC_FOLDER%\credentials.txt

:: Ensure the directory exists
if not exist "%SBC_FOLDER%" (
    mkdir "%SBC_FOLDER%"
    if %errorlevel% neq 0 (
        echo Failed to create directory %SBC_FOLDER%.
        exit /b 1
    )
)

:: Function to connect to WiFi
:connect_to_wifi
netsh wlan connect name=%SSID%
if %errorlevel% neq 0 (
 echo Failed to connect to WiFi network %SSID%.
 exit /b 1
)
echo Successfully connected to %SSID%.
goto :login

:: Function to login to the portal
:login
if exist "%CREDENTIALS_FILE%" (
 for /f "tokens=1,2" %%i in (%CREDENTIALS_FILE%) do (
  set WIFI_USER=%%i
  set PASSWORD=%%j
 )
) else ( 
 set /p WIFI_USER=Enter Username:
 set /p PASSWORD=Enter Password:
 echo %WIFI_USER% %PASSWORD% > "%CREDENTIALS_FILE%"
)
        set PASSWORD=%%j
    )
) else (
    set /p WIFI_USER=Enter Username:
    set /p PASSWORD=Enter Password:
    echo %WIFI_USER% %PASSWORD% > "%CREDENTIALS_FILE%"
)

:: HTTP API call
set URL=http://example.com/api/login
set POST_DATA="username=%WIFI_USER%&password=%PASSWORD%"

:: Use curl for HTTP POST request
curl -X POST -d %POST_DATA% %URL%

if %errorlevel% neq 0 (
    echo Login failed.
    exit /b 1
)
echo Login successful.
exit /b 0