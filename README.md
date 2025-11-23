# Plex Server Reset Tools

A collection of scripts to help resolve Plex Media Server authentication lockout issues. These tools remove stale authentication entries that prevent you from accessing your Plex Server Settings.

## Problem

In some situations, you may find yourself "locked out" from accessing your Plex Media Server settings. This commonly occurs when:

- Your server is signed in to one account but your web app is signed in with a different account
- You changed your password or removed your server "Device" entry
- The existing authentication token has been invalidated
- You have multiple Plex installations with conflicting authentication

You'll often see error messages like:
- "You do not have permission to access this server"
- "No soup for you"

## Solution

These scripts remove the authentication entries that are causing the lockout, allowing you to sign in or claim your server with your desired account. **Your server installation and libraries will NOT be affected** - only the authentication information is removed.

## Scripts

### Windows Scripts

#### `fix_plex_registry.ps1`
Removes Plex authentication entries from the Windows Registry. Use this if your Plex Media Server is running on Windows.

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File .\fix_plex_registry.ps1
```

**⚠️ Important:** These are PowerShell scripts (`.ps1` files). You must run them in **PowerShell**, not Command Prompt (CMD). 
- Open **PowerShell** (search for "PowerShell" in Start menu)
- Navigate to the script location
- Run the command above

**What it does:**
- Checks for Plex registry entries at `HKEY_CURRENT_USER\Software\Plex, Inc.\Plex Media Server`
- Removes: `PlexOnlineHome`, `PlexOnlineMail`, `PlexOnlineToken`, `PlexOnlineUsername`
- Prompts for confirmation before making changes

#### `check_plex_registry.ps1`
Checks if your Windows PC has Plex authentication entries that need to be cleaned. Useful for checking multiple PCs.

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File .\check_plex_registry.ps1
```

**What it does:**
- Scans for Plex registry entries
- Shows what entries exist
- Offers to remove them automatically

#### `view_and_clear_plex_tokens.ps1`
View existing authentication tokens before clearing them. Useful if you want to see what's there or save a backup.

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File .\view_and_clear_plex_tokens.ps1
```

**Options:**
- `view-only` - Display tokens without removing
- `clear` - Remove tokens immediately
- `save-then-clear` - Save tokens to a file, then remove them

### Linux/NAS Scripts

#### `fix_plex_nas.sh`
Removes Plex authentication entries from the Preferences.xml file on Linux/NAS systems (Synology, QNAP, etc.).

**Usage:**
```bash
chmod +x fix_plex_nas.sh
sudo ./fix_plex_nas.sh
```

**What it does:**
- Creates a backup of Preferences.xml
- Removes authentication entries using sed
- Stops and starts Plex Media Server

#### `check_plex_status.sh`
Diagnostic script to check Plex status and Preferences.xml on Linux/NAS systems.

**Usage:**
```bash
chmod +x check_plex_status.sh
sudo ./check_plex_status.sh
```

### Command Reference Files

#### `nas_plex_fix_commands.txt`
Quick reference commands for fixing Plex on NAS systems. Copy and paste these commands directly into your SSH session.

## Quick Start

### For Windows Plex Servers

**Quick One-Liner (if you can't download files):**

Open PowerShell and paste this single command:

```powershell
$r="HKCU:\Software\Plex, Inc.\Plex Media Server";if(Test-Path $r){@("PlexOnlineHome","PlexOnlineMail","PlexOnlineToken","PlexOnlineUsername")|%{if((gp $r -Name $_ -EA 0).$_){rp $r -Name $_ -EA 0;Write-Host "Removed: $_" -ForegroundColor Green}};Write-Host "Done!"}else{Write-Host "No Plex registry found - PC is clean!"}
```

This will automatically remove any Plex authentication entries found.

**Or use the script file:**

1. **Stop Plex Media Server** (if running)
2. Run the fix script:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\fix_plex_registry.ps1
   ```
3. **Start Plex Media Server**
4. Sign in to your Plex account and claim your server

### For Linux/NAS Plex Servers

1. **SSH into your NAS** as root or sudo user
2. **Stop Plex Media Server:**
   ```bash
   /usr/syno/bin/synopkg stop PlexMediaServer  # Synology
   # or
   systemctl stop plexmediaserver  # Standard Linux
   ```
3. **Backup Preferences.xml:**
   ```bash
   cp "/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml" \
      "/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml.backup"
   ```
4. **Remove authentication entries:**
   ```bash
   sed -i 's/ PlexOnlineHome="[^"]*"//g' "/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml"
   sed -i 's/ PlexOnlineMail="[^"]*"//g' "/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml"
   sed -i 's/ PlexOnlineToken="[^"]*"//g' "/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml"
   sed -i 's/ PlexOnlineUsername="[^"]*"//g' "/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml"
   ```
5. **Start Plex Media Server:**
   ```bash
   /usr/syno/bin/synopkg start PlexMediaServer  # Synology
   # or
   systemctl start plexmediaserver  # Standard Linux
   ```
6. Sign in to your Plex account and claim your server

## What Gets Removed

These scripts remove the following authentication entries:

- `PlexOnlineHome` - Home server flag
- `PlexOnlineMail` - Associated email address
- `PlexOnlineToken` - Authentication token
- `PlexOnlineUsername` - Username

**Important:** Only authentication information is removed. Your libraries, media files, metadata, and server configuration remain intact.

## After Running the Scripts

1. Open your Plex web interface at `http://app.plex.tv` or `http://[your-server-ip]:32400/web`
2. Sign in with your Plex account
3. Claim your server if prompted
4. Your libraries and media should still be there

## Troubleshooting

### Still seeing errors?

1. **Clear browser cache** - Try a hard refresh (Ctrl+F5) or use incognito/private mode
2. **Wait a moment** - Give Plex a minute to fully restart
3. **Check multiple PCs** - If you've used Plex on multiple Windows PCs, clean the registry on all of them
4. **Verify Plex is running:**
   - Windows: Check Services or Task Manager
   - Linux/NAS: `systemctl status plexmediaserver` or check package status

### Can't find Preferences.xml?

The location varies by system:
- **Synology NAS:** `/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml`
- **QNAP:** `/share/CACHEDEV1_DATA/.qpkg/PlexMediaServer/Library/Plex Media Server/Preferences.xml`
- **Standard Linux:** `~/.config/Plex Media Server/Preferences.xml` or `/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml`

Use `find` to locate it:
```bash
find /volume* -name "Preferences.xml" 2>/dev/null | grep -i plex
```

## Based On

These scripts are based on the official Plex support article:
[Why am I locked out of Server Settings and how do I get in?](https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/)

## Safety

- All scripts create backups before making changes
- Scripts prompt for confirmation before removing entries
- Only authentication entries are removed, not your media or libraries
- Tested on Windows 10/11 and Synology NAS systems

## License

This project is provided as-is for educational and troubleshooting purposes.

## Contributing

Feel free to submit issues or pull requests if you find bugs or have improvements!

## Disclaimer

Use these scripts at your own risk. While they follow official Plex support documentation, always backup your data before making system changes.

