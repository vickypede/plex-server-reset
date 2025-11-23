# View and Clear Plex Authentication Tokens
# This script shows you what tokens exist, then clears them

Write-Host "Plex Authentication Token Viewer & Cleaner" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

$regPath = "HKCU:\Software\Plex, Inc.\Plex Media Server"

if (Test-Path $regPath) {
    Write-Host "Found Plex registry entries. Displaying current values:" -ForegroundColor Yellow
    Write-Host ""
    
    # Retrieve and display the values
    $entries = @{
        "PlexOnlineHome" = $null
        "PlexOnlineMail" = $null
        "PlexOnlineToken" = $null
        "PlexOnlineUsername" = $null
    }
    
    foreach ($key in $entries.Keys) {
        $value = (Get-ItemProperty -Path $regPath -Name $key -ErrorAction SilentlyContinue).$key
        if ($value) {
            $entries[$key] = $value
            if ($key -eq "PlexOnlineToken") {
                Write-Host "  $key = $value" -ForegroundColor Yellow
                Write-Host "    (This is the authentication token)" -ForegroundColor Gray
            } else {
                Write-Host "  $key = $value" -ForegroundColor Yellow
            }
        }
    }
    
    Write-Host ""
    Write-Host "IMPORTANT: These tokens are likely causing your lockout issue." -ForegroundColor Red
    Write-Host "Even if you retrieve them, they may be invalid or expired." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Recommendation: Clear these entries and re-authenticate fresh." -ForegroundColor Cyan
    Write-Host ""
    
    $choice = Read-Host "What would you like to do? (view-only/clear/save-then-clear)"
    
    if ($choice -eq "save-then-clear") {
        # Save to a text file first
        $saveFile = "$env:USERPROFILE\Desktop\plex_tokens_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
        $output = @"
Plex Authentication Tokens Backup
Generated: $(Get-Date)
Computer: $env:COMPUTERNAME
User: $env:USERNAME

Registry Path: $regPath

Entries Found:
"@
        
        foreach ($key in $entries.Keys) {
            if ($entries[$key]) {
                $output += "`n$key = $($entries[$key])"
            }
        }
        
        $output | Out-File -FilePath $saveFile
        Write-Host ""
        Write-Host "Tokens saved to: $saveFile" -ForegroundColor Green
        Write-Host ""
        
        # Now clear them
        $choice = "clear"
    }
    
    if ($choice -eq "clear") {
        Write-Host ""
        Write-Host "Clearing authentication entries..." -ForegroundColor Yellow
        
        $cleared = 0
        foreach ($key in $entries.Keys) {
            if ($entries[$key]) {
                try {
                    Remove-ItemProperty -Path $regPath -Name $key -ErrorAction Stop
                    Write-Host "  [OK] Cleared: $key" -ForegroundColor Green
                    $cleared++
                } catch {
                    Write-Host "  [FAILED] Could not clear: $key - $_" -ForegroundColor Red
                }
            }
        }
        
        Write-Host ""
        if ($cleared -gt 0) {
            Write-Host "Success! Cleared $cleared entry/entries." -ForegroundColor Green
            Write-Host "This PC is now clean. You can re-authenticate with Plex." -ForegroundColor Green
        } else {
            Write-Host "No entries were cleared." -ForegroundColor Yellow
        }
    } elseif ($choice -eq "view-only") {
        Write-Host ""
        Write-Host "Tokens displayed above. They are still in the registry." -ForegroundColor Yellow
        Write-Host "To clear them, run this script again and choose 'clear'." -ForegroundColor Yellow
    } else {
        Write-Host ""
        Write-Host "Invalid choice. No changes made." -ForegroundColor Yellow
    }
    
} else {
    Write-Host "No Plex registry entries found. This PC is already clean." -ForegroundColor Green
}

Write-Host ""

