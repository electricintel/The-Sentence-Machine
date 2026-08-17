Set-Location $PSScriptRoot
Write-Host "Starting USOS Build..."

# Create folder structure
$folders = @(
    "USOS/kernel/core",
    "USOS/kernel/drivers",
    "USOS/kernel/utils",
    "USOS/system/init",
    "USOS/system/hud",
    "USOS/system/ir",
    "USOS/system/usp",
    "USOS/system/comms",
    "USOS/ui",
    "USOS/apps/hud_console",
    "USOS/apps/calculator",
    "USOS/apps/notepad",
    "USOS/apps/clock",
    "USOS/apps/diagnostics",
    "USOS/apps/terminal",
    "USOS/apps/codebreaker",
    "USOS/apps/translator",
    "USOS/apps/sentence_lab"
)

foreach ($f in $folders) {
    New-Item -ItemType Directory -Force -Path $f | Out-Null
}

# Run module scripts
$modules = @(
    "modules/kernel_core.ps1",
    "modules/kernel_drivers.ps1",
    "modules/kernel_utils.ps1",
    "modules/system_services.ps1",
    "modules/ui_system.ps1",
    "modules/codebreaker.ps1",
    "modules/apps.ps1"
)

foreach ($m in $modules) {
    Write-Host "Running module: $m"
    . "$PSScriptRoot\$m"
}

Write-Host "Compiling USOS C sources..."

$gcc = Get-Command gcc -ErrorAction Stop
$ar = Get-Command ar -ErrorAction SilentlyContinue

$buildRoot = Join-Path $PSScriptRoot "USOS/build"
$objRoot = Join-Path $buildRoot "obj"
New-Item -ItemType Directory -Force -Path $objRoot | Out-Null

$sourceFiles = Get-ChildItem -Path (Join-Path $PSScriptRoot "USOS") -Recurse -Filter *.c |
    Sort-Object FullName

$objectFiles = @()

foreach ($source in $sourceFiles) {
    $relativeSource = $source.FullName.Substring($PSScriptRoot.Length + 1)
    $relativeObject = [System.IO.Path]::ChangeExtension($relativeSource, ".o")
    $objectPath = Join-Path $objRoot $relativeObject
    $objectDir = Split-Path $objectPath -Parent
    New-Item -ItemType Directory -Force -Path $objectDir | Out-Null

    Write-Host "Compiling $relativeSource"
    & $gcc.Source -std=c11 -Wall -Wextra -I "$PSScriptRoot\USOS" -I "$PSScriptRoot\USOS\kernel\core" -I "$PSScriptRoot\USOS\kernel\drivers" -I "$PSScriptRoot\USOS\kernel\utils" -I "$PSScriptRoot\USOS\system\init" -I "$PSScriptRoot\USOS\system\hud" -I "$PSScriptRoot\USOS\system\ir" -I "$PSScriptRoot\USOS\system\usp" -I "$PSScriptRoot\USOS\system\comms" -I "$PSScriptRoot\USOS\ui" -I "$PSScriptRoot\USOS\apps\codebreaker" -c $source.FullName -o $objectPath
    if ($LASTEXITCODE -ne 0) {
        throw "Compilation failed for $relativeSource"
    }

    $objectFiles += $objectPath
}

$manifestPath = Join-Path $buildRoot "compile-manifest.txt"
Set-Content $manifestPath ($objectFiles -join "`r`n") -Encoding UTF8

if ($null -ne $ar) {
    $archivePath = Join-Path $buildRoot "libusos.a"
    if (Test-Path $archivePath) {
        Remove-Item $archivePath -Force
    }

    Write-Host "Archiving libusos.a"
    & $ar.Source rcs $archivePath @objectFiles
    if ($LASTEXITCODE -ne 0) {
        throw "Archiving libusos.a failed"
    }
}

$linkManifestPath = Join-Path $buildRoot "link-manifest.txt"
Set-Content $linkManifestPath ($objectFiles -join "`r`n") -Encoding UTF8

$exePath = Join-Path $buildRoot "usos.exe"
if (Test-Path $exePath) {
    Remove-Item $exePath -Force
}

Write-Host "Linking usos.exe"
& $gcc.Source @objectFiles -o $exePath
if ($LASTEXITCODE -ne 0) {
    throw "Executable link failed"
}

$distRoot = Join-Path $buildRoot "dist"
New-Item -ItemType Directory -Force -Path $distRoot | Out-Null

$bundleFiles = @(
    $exePath,
    (Join-Path (Split-Path $gcc.Source -Parent) "cygwin1.dll"),
    (Join-Path (Split-Path $gcc.Source -Parent) "cyggcc_s-seh-1.dll")
)

foreach ($file in $bundleFiles) {
    if (Test-Path $file) {
        Copy-Item $file $distRoot -Force
    }
}

Write-Host "Portable bundle created at $distRoot"

Write-Host "USOS Build Complete."
