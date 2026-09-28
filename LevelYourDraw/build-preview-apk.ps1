<#
.SYNOPSIS
    Script para crear build instalable (APK) con EAS y descargarla.
.DESCRIPTION
    Lanza un build con perfil preview (APK instalable sin Play Store),
    espera a que termine y descarga la APK al escritorio usando
    download-latest-apk.ps1. Verifica tsc, .env y login antes de compilar.
.NOTES
    Requiere EAS CLI configurado y autenticado (cuenta (cuenta de tienda propia)).
    El build hornea el .env local: verifica EXPO_PUBLIC_API_URL antes.
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet(1)]
    [int]$opcion,
    [switch]$SkipChecks
)

# Si no se proporciona opción, mostrar menú interactivo
if (-not $opcion) {
    Write-Host "=== Script de Build Instalable (APK sin Play Store) ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Opciones disponibles:" -ForegroundColor Yellow
    Write-Host "  1 - Android preview (APK instalable directo)" -ForegroundColor White
    Write-Host ""

    $seleccion = Read-Host "Selecciona una opción (1)"

    switch ($seleccion) {
        "1" { $opcion = 1 }
        default {
            Write-Host "Opción no válida. Saliendo..." -ForegroundColor Red
            exit
        }
    }
}

# Setear variable de entorno para saltar verificación de Git
$env:EAS_NO_VCS="1"

if (-not $SkipChecks) {
    # 1. Verificar EAS CLI
    Write-Host "[1/4] Verificando EAS CLI..." -ForegroundColor Yellow
    $EasVersion = eas --version 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "EAS CLI no instalado. Instala con: npm i -g eas-cli"
        exit 1
    }
    Write-Host "     ✓ $EasVersion" -ForegroundColor Green

    # 2. Verificar login
    Write-Host "[2/4] Verificando sesión de EAS..." -ForegroundColor Yellow
    $WhoAmI = eas whoami 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "No hay sesión activa. Ejecuta: eas login (cuenta (cuenta de tienda propia))"
        exit 1
    }
    Write-Host "     ✓ Sesión: $WhoAmI" -ForegroundColor Green

    # 3. Verificar .env (el build lo hornea, ya no lee tu PC)
    Write-Host "[3/4] Verificando .env..." -ForegroundColor Yellow
    if (-not (Test-Path ".env")) {
        Write-Error "No existe .env. Copia .env.example y completa los valores."
        exit 1
    }
    $ApiUrl = (Get-Content ".env" | Select-String "^EXPO_PUBLIC_API_URL=(.+)$" | ForEach-Object { $_.Matches[0].Groups[1].Value } | Select-Object -First 1)
    Write-Host "     ✓ API embebida: $ApiUrl" -ForegroundColor Green
    $confirm = Read-Host "     ¿Compilar contra esa URL? (S/n)"
    if ($confirm -eq "n" -or $confirm -eq "N") {
        Write-Host "Cancela, ajusta .env y vuelve a ejecutar." -ForegroundColor Yellow
        exit
    }

    # 4. Verificar tipos (no hornear JS roto)
    Write-Host "[4/4] Verificando TypeScript..." -ForegroundColor Yellow
    npx tsc --noEmit 2>&1 | Select-Object -First 5
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Hay errores de tipos. Corrige antes de compilar."
        exit 1
    }
    Write-Host "     ✓ tsc limpio" -ForegroundColor Green
}

Write-Host ""
Write-Host "Iniciando build preview para android (15-60 min en cola gratuita)..." -ForegroundColor Green
Write-Host "Perfil: preview (APK)" -ForegroundColor Yellow

# Ejecutar el build esperando a que termine
eas build --platform android --profile preview --non-interactive --wait

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "=== Error en el build ===" -ForegroundColor Red
    Write-Host "Revisa el log arriba o en https://expo.dev" -ForegroundColor Gray
    exit 1
}

Write-Host ""
Write-Host "=== Build terminado, descargando APK ===" -ForegroundColor Green

# Reusar el descargador de preview (solo perfil preview con APK)
& "$PSScriptRoot\download-preview-apk.ps1"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Listo para instalar ===" -ForegroundColor Green
    Write-Host "1. Pasa la APK al teléfono (USB, Drive o descarga directa)" -ForegroundColor Gray
    Write-Host "2. Permite 'Instalar apps desconocidas' si Android lo pide" -ForegroundColor Gray
    Write-Host "3. Instala y prueba (no necesita Metro ni PC)" -ForegroundColor Gray
}

