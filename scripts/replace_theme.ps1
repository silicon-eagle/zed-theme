param(
    # Path to your source theme JSON. Defaults to a github.json inside a local 'themes' folder next to this script.
    [string]$Source = (Join-Path (Split-Path $PSScriptRoot -Parent) "themes\\github.json"),

    # Base name (without .json) for the destination file in the Zed themes directory.
    [string]$ThemeName = "github",

    # If set, skips making a backup of an existing destination file.
    [switch]$SkipBackup
)

function Write-Info($msg)  { Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-Warn($msg)  { Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function Write-ErrorMsg($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red }

# Resolve source file
$Source = (Resolve-Path -Path $Source -ErrorAction SilentlyContinue).Path
if (-not $Source) {
    Write-ErrorMsg "Source file not found. Provide -Source pointing to your theme JSON."
    exit 1
}

if (-not (Test-Path -Path $Source -PathType Leaf)) {
    Write-ErrorMsg "Source path is not a file: $Source"
    exit 1
}

# Validate JSON
try {
    $null = Get-Content -Raw -Path $Source | ConvertFrom-Json
    Write-Info "JSON validated."
} catch {
    Write-ErrorMsg "JSON validation failed: $($_.Exception.Message)"
    exit 1
}

# Destination paths
$zedDir        = Join-Path $env:APPDATA "Zed"
$themesDir     = Join-Path $zedDir "themes"
$destination   = Join-Path $themesDir ("{0}.json" -f $ThemeName)

Write-Info "Zed themes directory: $themesDir"
if (-not (Test-Path $themesDir)) {
    Write-Info "Creating themes directory..."
    New-Item -ItemType Directory -Path $themesDir -Force | Out-Null
}

# Backup existing file if present
if (Test-Path $destination) {
    if ($SkipBackup) {
        Write-Warn "Existing theme will be overwritten without backup: $destination"
    } else {
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $backup = "{0}.{1}.bak" -f $destination, $timestamp
        Copy-Item -Path $destination -Destination $backup
        Write-Info "Backup created: $backup"
    }
}

# Copy new file with forced overwrite and hash verification
$srcHash = (Get-FileHash -Algorithm SHA256 -Path $Source).Hash
$existingHash = $null
$hadExisting = Test-Path $destination
if ($hadExisting) {
    try { $existingHash = (Get-FileHash -Algorithm SHA256 -Path $destination).Hash } catch {}
    if ($existingHash -eq $srcHash) {
        Write-Info "Destination already matches source (SHA256=$srcHash). Overwriting anyway..."
    }
    # Remove explicitly to avoid any odd file locking issues
    Remove-Item -Path $destination -Force -ErrorAction SilentlyContinue
}

Copy-Item -Path $Source -Destination $destination -Force

# Verify hash after copy
try {
    $newHash = (Get-FileHash -Algorithm SHA256 -Path $destination).Hash
    if ($newHash -ne $srcHash) {
        Write-ErrorMsg "Post-copy hash mismatch. Expected $srcHash but got $newHash."
        exit 1
    } else {
        Write-Info "Theme copied to: $destination (SHA256=$newHash)"
    }
} catch {
    Write-ErrorMsg "Failed to compute hash on destination: $($_.Exception.Message)"
    exit 1
}

Write-Info "Done."
