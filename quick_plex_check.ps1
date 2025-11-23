# Quick Plex Registry Check - Copy and paste this into PowerShell
$regPath = "HKCU:\Software\Plex, Inc.\Plex Media Server"

if (Test-Path $regPath) {
    Write-Host "Found Plex registry entries. Checking..." -ForegroundColor Yellow
    $entries = @("PlexOnlineHome", "PlexOnlineMail", "PlexOnlineToken", "PlexOnlineUsername")
    $found = @()
    
    foreach ($entry in $entries) {
        $value = (Get-ItemProperty -Path $regPath -Name $entry -ErrorAction SilentlyContinue).$entry
        if ($value) {
            $found += $entry
            Write-Host "[FOUND] $entry" -ForegroundColor Red
        }
    }
    
    if ($found.Count -gt 0) {
        Write-Host "`nFound $($found.Count) entries. Remove them? (yes/no)" -ForegroundColor Yellow
        $confirm = Read-Host
        if ($confirm -eq "yes") {
            foreach ($entry in $found) {
                Remove-ItemProperty -Path $regPath -Name $entry -ErrorAction SilentlyContinue
                Write-Host "[REMOVED] $entry" -ForegroundColor Green
            }
            Write-Host "`nDone! PC is now clean." -ForegroundColor Green
        }
    } else {
        Write-Host "No authentication entries found. PC is clean!" -ForegroundColor Green
    }
} else {
    Write-Host "No Plex registry found. PC is clean!" -ForegroundColor Green
}

