# WiFi Auto Login Script

This script automates the WiFi login process for 91springboard network users on Windows. Once configured, it automatically connects and logs in to the WiFi network whenever you start your Windows system.

## Quick Start

### 1. Download the Script

> **Quick Download Link:**
> 📥 [**Click here to download wifi-login.bat**](https://github.com/idxakshay/wifi-auto-login/releases/download/first-release/wifi-login.bat)

<details>
<summary><strong>Download Instructions</strong></summary>

- **Option 1**: Click the download link above
- **Option 2**: Right-click and select "Save link as..."
- **Important**: Save it in an easily accessible location (e.g., Desktop or Documents)
</details>

### 2. First-Time Setup

1. Double-click the `wifi-login.bat` script to run it
2. When prompted, enter your:
   - Username (your 91springboard login email)
   - Password (your 91springboard password)
3. The script will automatically:
   - Save your credentials securely
   - Request administrative privileges to set up auto-start
   - Create a scheduled task for automatic login

### 3. Automatic Login

After the initial setup, the script will:

- Run automatically when you log into Windows
- Connect to the 91springboard WiFi network
- Handle the portal authentication automatically

## How It Works

The script performs several automated tasks:

1. **Credential Management**

   - Stores credentials securely in `%USERPROFILE%\.sbc\credentials.txt`
   - Uses these saved credentials for subsequent logins

2. **Network Connection**

   - Automatically connects to the "91springboard" WiFi network
   - Waits for the connection to stabilize

3. **Portal Authentication**

   - Performs automatic login to the portal using saved credentials
   - Uses CURL to handle the authentication request

4. **Auto-Start Configuration**
   - Creates a Windows scheduled task to run on system logon
   - Ensures the script runs with necessary permissions

## Troubleshooting

If you need to update your credentials:

1. Delete the folder: `%USERPROFILE%\.sbc`
2. Run the script again to re-enter your credentials

## Security Note

Your credentials are stored locally on your computer in plain text. While this is convenient, please be aware of the security implications.
