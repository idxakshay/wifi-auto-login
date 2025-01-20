@echo off
setlocal enabledelayedexpansion

:: Set the SSID of the WiFi network
set "SSID=91springboard"

:: Set the path for the credentials file
set "SBC_FOLDER=%USERPROFILE%\.sbc"
set "CREDENTIALS_FILE=%SBC_FOLDER%\credentials.txt"

:: Ensure the directory exists
if not exist "%SBC_FOLDER%" (
    mkdir "%SBC_FOLDER%"
    if %errorlevel% neq 0 (
        echo Failed to create directory for credentials: %SBC_FOLDER%.
        exit /b 1
    )
)

:: Function to connect to WiFi
:connect_to_wifi
netsh wlan connect name="%SSID%"
if %errorlevel% neq 0 (
    echo Failed to connect to WiFi network %SSID%.
    exit /b 1
)
echo Successfully connected to %SSID%.
echo Waiting for connection to stabilize...
timeout /t 3 /nobreak
goto :login

:: Function to login to the portal
:login
set "FIRST_TIME_LOGIN=0"
if exist "%CREDENTIALS_FILE%" (

    for /f "tokens=1,2" %%i in (%CREDENTIALS_FILE%) do (
        set "WIFI_USER=%%i"
        set "PASSWORD=%%j"
    )
) else (
    set /p "WIFI_USER=Enter Username: "
    set /p "PASSWORD=Enter Password: "
    echo !WIFI_USER! !PASSWORD!> "%CREDENTIALS_FILE%"
     set "FIRST_TIME_LOGIN=1"
)

:: HTTP API call

curl POST ^
  --ssl-no-revoke "https://portal.91springboard.com/login" ^
  --data-urlencode "username=!WIFI_USER!" ^
  --data-urlencode "password=!PASSWORD!" ^
  -H "Content-Type:application/x-www-form-urlencoded" ^
  -H "Accept:text/html,application/xhtml+xml" ^
  --verbose ^
  --location

echo.
echo.
echo.
echo -----------------------------------------------------------------
if %errorlevel% neq 0 (
    echo Login failed.
    echo -----------------------------------------------------------------
    exit /b 1
)
echo Login successful.
echo -----------------------------------------------------------------

:: Create scheduled task if this is the first time login
if %FIRST_TIME_LOGIN% equ 1 (

    net session >nul 2>&1

    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)


:: Create a task when running as admin so that the script runs on logon
net session >nul 2>&1
if %errorlevel% equ 0 (
    :: Has admin rights, proceed with creating task
    schtasks /Create /SC ONLOGON /TN "WiFiAutoLogin" /TR "\"%~f0\"" /RL HIGHEST /F
    if %errorlevel% neq 0 (
        echo Failed to create scheduled task.
        exit /b 1
    )
    echo Successfully created scheduled task for immediate WiFi login.
)

exit /b 0