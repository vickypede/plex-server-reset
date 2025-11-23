# Plex Media Server Registry Fix Script
# This script removes authentication entries to regain access to Plex Server Settings
# Based on: https://support.plex.tv/articles/204281528-why-am-i-locked-out-of-server-settings-and-how-do-i-get-in/

Write-Host "Plex Media Server Registry Fix Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as administrator (not required for HKEY_CURRENT_USER, but good to know)
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdmin) {
    Write-Host "Running with administrator privileges" -ForegroundColor Green
} else {
    Write-Host "Running with standard user privileges (this is fine for HKEY_CURRENT_USER)" -ForegroundColor Yellow
}

Write-Host ""

# Registry path
$regPath = "HKCU:\Software\Plex, Inc.\Plex Media Server"

# Check if the registry key exists
if (Test-Path $regPath) {
    Write-Host "Found Plex Media Server registry key at: $regPath" -ForegroundColor Green
    Write-Host ""
    
    # Entries to remove
    $entriesToRemove = @(
        "PlexOnlineHome",
        "PlexOnlineMail",
        "PlexOnlineToken",
        "PlexOnlineUsername"
    )
    
    Write-Host "Checking for entries to remove..." -ForegroundColor Yellow
    Write-Host ""
    
    $foundEntries = @()
    foreach ($entry in $entriesToRemove) {
        $entryPath = Join-Path $regPath $entry
        if (Test-Path $entryPath) {
            $foundEntries += $entry
            $value = (Get-ItemProperty -Path $regPath -Name $entry -ErrorAction SilentlyContinue).$entry
            Write-Host "  Found: $entry = $value" -ForegroundColor Yellow
        } else {
            Write-Host "  Not found: $entry" -ForegroundColor Gray
        }
    }
    
    if ($foundEntries.Count -eq 0) {
        Write-Host ""
        Write-Host "No entries found to remove. Your registry may already be clean." -ForegroundColor Green
        Write-Host "You can try launching Plex Media Server and signing in again." -ForegroundColor Green
        exit 0
    }
    
    Write-Host ""
    Write-Host "WARNING: This will remove the following authentication entries:" -ForegroundColor Red
    foreach ($entry in $foundEntries) {
        Write-Host "  - $entry" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "This will allow you to sign in/claim your Plex Media Server again." -ForegroundColor Yellow
    Write-Host "Your server installation and libraries will NOT be affected." -ForegroundColor Yellow
    Write-Host ""
    
    $confirmation = Read-Host "Do you want to continue? (yes/no)"
    
    if ($confirmation -ne "yes") {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        exit 0
    }
    
    Write-Host ""
    Write-Host "Removing entries..." -ForegroundColor Yellow
    
    $removedCount = 0
    foreach ($entry in $foundEntries) {
        try {
            Remove-ItemProperty -Path $regPath -Name $entry -ErrorAction Stop
            Write-Host "  [OK] Removed: $entry" -ForegroundColor Green
            $removedCount++
        } catch {
            Write-Host "  [FAILED] Failed to remove: $entry - $_" -ForegroundColor Red
        }
    }
    
    Write-Host ""
    if ($removedCount -eq $foundEntries.Count) {
        Write-Host "Success! Removed $removedCount entry/entries." -ForegroundColor Green
        Write-Host ""
        Write-Host "Next steps:" -ForegroundColor Cyan
        Write-Host "1. Launch your Plex Media Server" -ForegroundColor White
        Write-Host "2. Sign in to/claim your Plex Media Server with your Plex account" -ForegroundColor White
        Write-Host "3. Your libraries and settings should remain intact" -ForegroundColor White
    } else {
        Write-Host "Some entries could not be removed. You may need to run this script as administrator or manually edit the registry." -ForegroundColor Red
    }
    
} else {
    Write-Host "Plex Media Server registry key not found at: $regPath" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This could mean:" -ForegroundColor Yellow
    Write-Host "1. Plex Media Server is not installed on this Windows PC" -ForegroundColor White
    Write-Host "2. Plex Media Server has never been run on this user account" -ForegroundColor White
    Write-Host "3. Your Plex server is running on a different machine (like your NAS)" -ForegroundColor White
    Write-Host ""
    Write-Host "If your Plex server is on a NAS or Linux machine, you will need to edit the Preferences.xml file instead." -ForegroundColor Cyan
}

Write-Host ""

