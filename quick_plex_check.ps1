<#
.SYNOPSIS
  Plex Media Server Registry Checker / Cleaner

.DESCRIPTION
  Scans common Plex registry locations for authentication entries and
  optionally removes them. Run this on any Windows PC where Plex Media
  Server or Plex client has been installed.

.PARAMETER AutoRemove
  Automatically remove any found auth entries without prompting.

.PARAMETER ScanAllHives
  Also scan HKLM and WOW6432Node (recommended when cleaning a server).
#>

[CmdletBinding()]
param(
    [switch]$AutoRemove,
    [switch]$ScanAllHives
)

Write-Host "Plex Media Server Registry Checker" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Detect if running as admin (needed for HKLM writes)
$identity  = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
$IsAdmin   = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

Write-Host ("Running as administrator: {0}" -f $IsAdmin) -ForegroundColor Yellow
Write-Host ""

# Registry paths to scan
$regPaths = @(
    "HKCU:\Software\Plex, Inc.\Plex Media Server"
)

if ($ScanAllHives) {
    $regPaths += @(
        "HKLM:\SOFTWARE\Plex, Inc.\Plex Media Server",
        "HKLM:\SOFTWARE\WOW6432Node\Plex, Inc.\Plex Media Server"
    )
}

# Entries to check (extended a bit)
$entriesToCheck = @(
    "PlexOnlineHome",
    "PlexOnlineMail",
    "PlexOnlineToken",
    "PlexOnlineUsername",
    "PlexOnlineTokenType",
    "PlexOnlineServerUUID",
    "PlexOnlineMachineIdentifier"
)

function ConvertTo-RegExePath {
    param(
        [Parameter(Mandatory)][string]$PsPath
    )
    # Convert HKCU:\foo to HKCU\foo etc.
    $PsPath -replace '^HKCU:\\', 'HKCU\' `
           -replace '^HKLM:\\', 'HKLM\' `
           -replace '^HKU:\\',  'HKU\'
}

function Backup-RegistryKey {
    param(
        [Parameter(Mandatory)][string]$Path
    )

    if (-not (Test-Path $Path)) { return }

    try {
        $backupDir = Join-Path -Path $env:TEMP -ChildPath "PlexRegBackup"
        if (-not (Test-Path $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        }

        $safeName  = ($Path -replace '[:\\ ]','_')
        $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
        $backupFile = Join-Path $backupDir "Backup_${safeName}_${timestamp}.reg"

        $regExePath = ConvertTo-RegExePath -PsPath $Path

        & reg.exe export "$regExePath" "$backupFile" /y | Out-Null
        Write-Host "  [BACKUP] Exported $regExePath to $backupFile" -ForegroundColor DarkGray
    }
    catch {
        Write-Host "  [BACKUP-FAILED] Could not export $Path : $_" -ForegroundColor Red
    }
}

function Check-PlexRegistryKey {
    param(
        [Parameter(Mandatory)][string]$Path
    )

    if (-not (Test-Path $Path)) {
        Write-Host "[OK] Plex Media Server registry key not found at: $Path" -ForegroundColor Green
        Write-Host ""
        return
    }

    Write-Host "[FOUND] Plex Media Server registry key at:" -ForegroundColor Yellow
    Write-Host "  $Path" -ForegroundColor White
    Write-Host ""

    try {
        $props = Get-ItemProperty -Path $Path -ErrorAction Stop
    }
    catch {
        Write-Host "  [ERROR] Cannot read $Path : $_" -ForegroundColor Red
        Write-Host ""
        return
    }

    Write-Host "Checking for authentication entries..." -ForegroundColor Yellow
    Write-Host ""

    $foundEntries = @()

    foreach ($entry in $entriesToCheck) {
        $hasProperty = $props.PSObject.Properties.Name -contains $entry

        if ($hasProperty) {
            $value = $props.$entry

            $foundEntries += $entry

            if ($entry -like "*Token*") {
                Write-Host "  [FOUND] $entry = [HIDDEN - Token found]" -ForegroundColor Red
            } else {
                if ($null -eq $value -or $value -eq "") {
                    Write-Host "  [FOUND] $entry = (present but empty)" -ForegroundColor Red
                } else {
                    Write-Host "  [FOUND] $entry = $value" -ForegroundColor Red
                }
            }
        } else {
            Write-Host "  [OK] $entry - Not found" -ForegroundColor Green
        }
    }

    Write-Host ""

    if ($foundEntries.Count -eq 0) {
        Write-Host "This key is CLEAN - No authentication entries found." -ForegroundColor Green
        Write-Host ""
        return
    }

    Write-Host "WARNING: Found $($foundEntries.Count) authentication entry/entries in:" -ForegroundColor Red
    Write-Host "  $Path" -ForegroundColor Red
    Write-Host ""

    $doRemove = $false

    if ($AutoRemove) {
        $doRemove = $true
        Write-Host "[AUTO] AutoRemove enabled - entries will be removed." -ForegroundColor Yellow
    } else {
        Write-Host "These entries can cause lockout / 'not authorized' issues." -ForegroundColor Yellow
        $confirmation = Read-Host "Remove these entries from this key? (yes/no)"
        if ($confirmation -match '^(y|yes)$') {
            $doRemove = $true
        }
    }

    if (-not $doRemove) {
        Write-Host "Entries NOT removed for this key. Authentication entries remain." -ForegroundColor Yellow
        Write-Host ""
        return
    }

    # Try backup first
    Backup-RegistryKey -Path $Path

    Write-Host ""
    Write-Host "Removing entries from $Path ..." -ForegroundColor Yellow

    $removedCount = 0

    foreach ($entry in $foundEntries) {
        try {
            Remove-ItemProperty -Path $Path -Name $entry -ErrorAction Stop
            Write-Host "  [OK] Removed: $entry" -ForegroundColor Green
            $removedCount++
        }
        catch {
            Write-Host "  [FAILED] Could not remove: $entry - $_" -ForegroundColor Red
        }
    }

    Write-Host ""
    if ($removedCount -eq $foundEntries.Count) {
        Write-Host "Success! All authentication entries removed from this key." -ForegroundColor Green
    } else {
        Write-Host "Some entries could not be removed from this key." -ForegroundColor Yellow
        if (-not $IsAdmin -and $Path -like 'HKLM*') {
            Write-Host "Hint: Re-run this script in an elevated PowerShell session (Run as administrator)." -ForegroundColor Yellow
        }
    }

    Write-Host ""
}

# === MAIN ===

if ($ScanAllHives -and -not $IsAdmin) {
    Write-Host "NOTE: ScanAllHives is enabled but you're not running as admin." -ForegroundColor Yellow
    Write-Host "      HKLM entries may be detected but removal may fail." -ForegroundColor Yellow
    Write-Host ""
}

foreach ($path in $regPaths) {
    Check-PlexRegistryKey -Path $path
}

Write-Host "Check complete!" -ForegroundColor Cyan
Write-Host ""
