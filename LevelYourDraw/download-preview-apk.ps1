<#
.SYNOPSIS
    Script para descargar la última APK del perfil preview de EAS Build.
.DESCRIPTION
    A diferencia de download-latest-apk.ps1 (trae cualquier build Android),
    este filtra solo builds finished del perfil preview con artefacto APK
    y lo copia al escritorio como LevelYourDraw_Preview.apk.
.NOTES
    Requiere EAS CLI configurado y autenticado.
#>

Write-Host "=== Descargador de APK preview de EAS ===" -ForegroundColor Cyan
Write-Host ""

# Directorio de destino (escritorio por defecto)
$DestinationDir = [Environment]::GetFolderPath("Desktop")
$ApkFileName = "LevelYourDraw_Preview.apk"
$DestinationPath = Join-Path $DestinationDir $ApkFileName

Write-Host "Directorio de destino: $DestinationDir" -ForegroundColor Gray
Write-Host ""

# Obtener lista de builds en JSON (solo stdout, EAS mezcla avisos por stderr)
Write-Host "Obteniendo builds de EAS..." -ForegroundColor Yellow
$BuildListRaw = eas build:list --platform android --json 2>&1 | Out-String

if ($LASTEXITCODE -ne 0) {
    Write-Error "Error al obtener lista de builds"
    Write-Host "Asegúrate de estar autenticado con EAS CLI (eas login)" -ForegroundColor Yellow
    exit 1
}

# Extraer solo el JSON (de primer '[' al último ']'), ignorando avisos
$JsonStart = $BuildListRaw.IndexOf('[')
$JsonEnd = $BuildListRaw.LastIndexOf(']')
if ($JsonStart -lt 0 -or $JsonEnd -lt 0 -or $JsonEnd -le $JsonStart) {
    Write-Error "La respuesta de EAS no contiene JSON. Salida recibida:"
    Write-Host ($BuildListRaw | Select-Object -First 10) -ForegroundColor Gray
    exit 1
}

try {
    $Builds = $BuildListRaw.Substring($JsonStart, $JsonEnd - $JsonStart + 1) | ConvertFrom-Json
} catch {
    Write-Error "No se pudo parsear la respuesta de EAS: $($_.Exception.Message)"
    exit 1
}

if (-not $Builds -or $Builds.Count -eq 0) {
    Write-Error "No se encontraron builds de Android"
    exit 1
}

# Filtrar: finished + perfil preview + artefacto APK
$PreviewBuilds = $Builds | Where-Object {
    $_.status -eq "finished" -and
    $_.buildProfile -eq "preview" -and
    $_.artifacts.applicationArchiveUrl -like "*.apk"
}

if (-not $PreviewBuilds -or $PreviewBuilds.Count -eq 0) {
    Write-Error "No hay builds preview terminados con APK. Lanza uno con .\build-preview-apk.ps1"
    exit 1
}

# El más reciente por fecha de creación
$LatestBuild = $PreviewBuilds | Sort-Object -Property createdAt -Descending | Select-Object -First 1

Write-Host "Build preview más reciente:" -ForegroundColor Green
Write-Host "  ID: $($LatestBuild.id)" -ForegroundColor Gray
Write-Host "  Fecha: $($LatestBuild.createdAt)" -ForegroundColor Gray
Write-Host "  Versión: $($LatestBuild.version)" -ForegroundColor Gray
Write-Host "  URL: $($LatestBuild.artifacts.applicationArchiveUrl)" -ForegroundColor Gray
Write-Host ""

# Descargar el build
Write-Host "Descargando build..." -ForegroundColor Yellow
$DownloadResult = eas build:download --id $LatestBuild.id 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Error "Error al descargar el build"
    exit 1
}

# Extraer la ruta del APK del output
$ApkPath = $DownloadResult | Select-String "Build downloaded to" | ForEach-Object {
    $_ -match "Build downloaded to (.+)" | Out-Null
    $Matches[1].Trim()
}

if (-not $ApkPath -or -not (Test-Path $ApkPath)) {
    Write-Error "No se pudo encontrar la ruta del APK descargado"
    exit 1
}

Write-Host "APK descargada en: $ApkPath" -ForegroundColor Green
Write-Host ""

# Copiar a ubicación accesible
Write-Host "Copiando a escritorio como $ApkFileName ..." -ForegroundColor Yellow
Copy-Item $ApkPath $DestinationPath -Force

if ($LASTEXITCODE -eq 0) {
    Write-Host "OK - APK lista" -ForegroundColor Green
    Write-Host "Ubicación: $DestinationPath" -ForegroundColor Cyan
}
else {
    Write-Error "Error al copiar APK"
    exit 1
}

Write-Host ""
Write-Host "=== Descarga Completada ===" -ForegroundColor Green
Write-Host "Puedes instalar la APK en tu dispositivo Android" -ForegroundColor Gray

