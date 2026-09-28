<#
.SYNOPSIS
    Script para instalar la APK de desarrollo en dispositivo Android conectado
.DESCRIPTION
    Busca la APK más reciente descargada por EAS y la instala en el dispositivo Android conectado.
.NOTES
    Requiere que ADB esté instalado y que el dispositivo esté conectado con USB debugging habilitado.
#>

Write-Host "=== Instalador de APK de Desarrollo ===" -ForegroundColor Cyan
Write-Host ""

# Directorio donde EAS descarga las APKs
$EasCacheDir = "$env:TEMP\eas-cli-nodejs\eas-build-run-cache"

# Buscar la APK más reciente del proyecto
$ProjectId = "263ef474-4379-4438-8f92-fc703adcd32f"
$Pattern = "${ProjectId}_*.apk"

Write-Host "Buscando APK más reciente en: $EasCacheDir" -ForegroundColor Yellow

if (-not (Test-Path $EasCacheDir)) {
    Write-Error "No se encontró el directorio de caché de EAS"
    Write-Host "Asegúrate de haber descargado una build con: eas build:download --id <build-id>" -ForegroundColor Yellow
    exit 1
}

# Buscar APKs del proyecto
$ApkFiles = Get-ChildItem -Path $EasCacheDir -Filter $Pattern | Sort-Object LastWriteTime -Descending

if ($ApkFiles.Count -eq 0) {
    Write-Error "No se encontraron APKs descargadas para este proyecto"
    Write-Host "Para descargar una build, usa: eas build:download --id <build-id>" -ForegroundColor Yellow
    exit 1
}

# Tomar la APK más reciente
$LatestApk = $ApkFiles[0]
Write-Host "APK encontrada: $($LatestApk.Name)" -ForegroundColor Green
Write-Host "Fecha: $($LatestApk.LastWriteTime)" -ForegroundColor Gray
Write-Host ""

# Verificar que ADB esté disponible
try {
    $AdbVersion = adb version 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "ADB no está disponible"
    }
    Write-Host "ADB detectado: $($AdbVersion.Trim())" -ForegroundColor Green
}
catch {
    Write-Error "ADB no está instalado o no está en el PATH"
    Write-Host "Instala Android SDK o asegúrate de que adb esté en el PATH" -ForegroundColor Yellow
    exit 1
}

# Verificar dispositivos conectados
Write-Host "Verificando dispositivos Android conectados..." -ForegroundColor Yellow
$Devices = adb devices
$DeviceLines = $Devices | Select-String -Pattern "device$" -Context 0, 2

if ($DeviceLines.Count -eq 0) {
    Write-Error "No se detectaron dispositivos Android conectados"
    Write-Host "Asegúrate de:" -ForegroundColor Yellow
    Write-Host "  1. Conectar el dispositivo con USB" -ForegroundColor Gray
    Write-Host "  2. Habilitar USB Debugging en el dispositivo" -ForegroundColor Gray
    Write-Host "  3. Aceptar la autorización RSA en el dispositivo" -ForegroundColor Gray
    exit 1
}

Write-Host "Dispositivos detectados:" -ForegroundColor Green
$DeviceLines | ForEach-Object {
    $DeviceId = $_.Line.Split(' ')[0]
    Write-Host "  - $DeviceId" -ForegroundColor Cyan
}
Write-Host ""

# Instalar la APK
Write-Host "Instalando APK en dispositivo..." -ForegroundColor Yellow
try {
    $InstallResult = adb install -r "$($LatestApk.FullName)"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ APK instalada exitosamente" -ForegroundColor Green
        Write-Host "Ap: $($LatestApk.Name)" -ForegroundColor Gray
        Write-Host "Puedes iniciar la app desde el dispositivo" -ForegroundColor Cyan
    }
    else {
        Write-Error "Error al instalar APK"
        Write-Host "Resultado: $InstallResult" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Error "Error durante la instalación: $_"
    exit 1
}

Write-Host ""
Write-Host "=== Instalación Completada ===" -ForegroundColor Green


