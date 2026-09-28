<#
.SYNOPSIS
    Script para descargar la última APK de EAS Build
.DESCRIPTION
    Busca el build más reciente de Android en EAS y lo descarga.
    Copia la APK a una ubicación accesible (escritorio por defecto).
.NOTES
    Requiere EAS CLI configurado y autenticado.
#>

Write-Host "=== Descargador de APK más reciente de EAS ===" -ForegroundColor Cyan
Write-Host ""

# Directorio de destino (escritorio por defecto)
$DestinationDir = [Environment]::GetFolderPath("Desktop")
$ApkFileName = "LevelYourDraw_Latest.apk"
$DestinationPath = Join-Path $DestinationDir $ApkFileName

Write-Host "Directorio de destino: $DestinationDir" -ForegroundColor Gray
Write-Host ""

# Obtener lista de builds
Write-Host "Obteniendo lista de builds de EAS..." -ForegroundColor Yellow
$BuildListOutput = eas build:list --platform android 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Error "Error al obtener lista de builds"
    Write-Host "Asegúrate de estar autenticado con EAS CLI" -ForegroundColor Yellow
    exit 1
}

# Parsear el output de texto para encontrar builds
$BuildLines = $BuildListOutput -split "`n"
$Builds = @()
$CurrentBuild = @{}

foreach ($Line in $BuildLines) {
    if ($Line -match "^ID\s+(.+)$") {
        if ($CurrentBuild.Count -gt 0) {
            $Builds += [PSCustomObject]$CurrentBuild
        }
        $CurrentBuild = @{ id = $Matches[1].Trim() }
    }
    elseif ($Line -match "^Platform\s+(.+)$") {
        $CurrentBuild.platform = $Matches[1].Trim()
    }
    elseif ($Line -match "^Status\s+(.+)$") {
        $CurrentBuild.status = $Matches[1].Trim()
    }
    elseif ($Line -match "^Started at\s+(.+)$") {
        $CurrentBuild.'Started at' = $Matches[1].Trim()
    }
    elseif ($Line -match "^Version\s+(.+)$") {
        $CurrentBuild.version = $Matches[1].Trim()
    }
}

# Agregar el último build
if ($CurrentBuild.Count -gt 0) {
    $Builds += [PSCustomObject]$CurrentBuild
}

if ($Builds.Count -eq 0) {
    Write-Error "No se encontraron builds de Android"
    exit 1
}

# Filtrar builds que están finished y tienen APK
$FinishedBuilds = $Builds | Where-Object {
    $_.status -eq "finished" -and $_.platform -eq "android"
}

if ($FinishedBuilds.Count -eq 0) {
    Write-Error "No se encontraron builds completados con APK"
    exit 1
}

# Ordenar por fecha descendente y tomar el más reciente
$LatestBuild = $FinishedBuilds | Sort-Object -Property { [DateTime]::Parse($_.'Started at'.Replace('a. m.', 'AM').Replace('p. m.', 'PM')) } -Descending | Select-Object -First 1

Write-Host "Build más reciente encontrado:" -ForegroundColor Green
Write-Host "  ID: $($LatestBuild.id)" -ForegroundColor Gray
Write-Host "  Fecha: $($LatestBuild.'Started at')" -ForegroundColor Gray
Write-Host "  Versión: $($LatestBuild.version)" -ForegroundColor Gray
Write-Host "  Estado: $($LatestBuild.status)" -ForegroundColor Gray
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
Write-Host "Copiando a escritorio..." -ForegroundColor Yellow
Copy-Item $ApkPath $DestinationPath -Force

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ APK copiada exitosamente" -ForegroundColor Green
    Write-Host "Ubicación: $DestinationPath" -ForegroundColor Cyan
}
else {
    Write-Error "Error al copiar APK"
    exit 1
}

Write-Host ""
Write-Host "=== Descarga Completada ===" -ForegroundColor Green
Write-Host "Puedes instalar la APK en tu dispositivo Android" -ForegroundColor Gray

