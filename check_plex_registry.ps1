# Plex Media Server Registry Checker Script
# This script checks for and optionally removes Plex authentication entries on Windows
# Run this on any Windows PC where you might have had Plex installed

Write-Host "Plex Media Server Registry Checker" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Registry path
$regPath = "HKCU:\Software\Plex, Inc.\Plex Media Server"

# Check if the registry key exists
if (Test-Path $regPath) {
    Write-Host "[FOUND] Plex Media Server registry key exists at:" -ForegroundColor Yellow
    Write-Host "  $regPath" -ForegroundColor White
    Write-Host ""
    
    # Entries to check
    $entriesToCheck = @(
        "PlexOnlineHome",
        "PlexOnlineMail",
        "PlexOnlineToken",
        "PlexOnlineUsername"
    )
    
    Write-Host "Checking for authentication entries..." -ForegroundColor Yellow
    Write-Host ""
    
    $foundEntries = @()
    foreach ($entry in $entriesToCheck) {
        $value = (Get-ItemProperty -Path $regPath -Name $entry -ErrorAction SilentlyContinue).$entry
        if ($value) {
            $foundEntries += $entry
            if ($entry -eq "PlexOnlineToken") {
                Write-Host "  [FOUND] $entry = [HIDDEN - Token found]" -ForegroundColor Red
            } else {
                Write-Host "  [FOUND] $entry = $value" -ForegroundColor Red
            }
        } else {
            Write-Host "  [OK] $entry - Not found" -ForegroundColor Green
        }
    }
    
    Write-Host ""
    
    if ($foundEntries.Count -gt 0) {
        Write-Host "WARNING: Found $($foundEntries.Count) authentication entry/entries that should be removed!" -ForegroundColor Red
        Write-Host ""
        Write-Host "These entries can cause lockout issues. Would you like to remove them now?" -ForegroundColor Yellow
        Write-Host ""
        
        $confirmation = Read-Host "Remove these entries? (yes/no)"
        
        if ($confirmation -eq "yes") {
            Write-Host ""
            Write-Host "Removing entries..." -ForegroundColor Yellow
            
            $removedCount = 0
            foreach ($entry in $foundEntries) {
                try {
                    Remove-ItemProperty -Path $regPath -Name $entry -ErrorAction Stop
                    Write-Host "  [OK] Removed: $entry" -ForegroundColor Green
                    $removedCount++
                } catch {
                    Write-Host "  [FAILED] Could not remove: $entry - $_" -ForegroundColor Red
                }
            }
            
            Write-Host ""
            if ($removedCount -eq $foundEntries.Count) {
                Write-Host "Success! All entries removed. This PC is now clean." -ForegroundColor Green
            } else {
                Write-Host "Some entries could not be removed. You may need to run as administrator." -ForegroundColor Yellow
            }
        } else {
            Write-Host "Entries not removed. This PC still has authentication entries that may cause issues." -ForegroundColor Yellow
        }
    } else {
        Write-Host "This PC is CLEAN - No authentication entries found!" -ForegroundColor Green
        Write-Host "No action needed." -ForegroundColor Green
    }
    
} else {
    Write-Host "[OK] Plex Media Server registry key not found." -ForegroundColor Green
    Write-Host ""
    Write-Host "This means either:" -ForegroundColor White
    Write-Host "  1. Plex Media Server was never installed on this PC" -ForegroundColor Gray
    Write-Host "  2. Plex Media Server was never run on this user account" -ForegroundColor Gray
    Write-Host "  3. The registry has already been cleaned" -ForegroundColor Gray
    Write-Host ""
    Write-Host "This PC is CLEAN - No action needed." -ForegroundColor Green
}

Write-Host ""
Write-Host "Check complete!" -ForegroundColor Cyan

