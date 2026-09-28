<#
.SYNOPSIS
    Script para configurar el secreto EXPO_PUBLIC_API_URL en EAS.
.DESCRIPTION
    Los builds en la nube de EAS ignoran tu .env local (gitignoreado), por lo
    que la URL de la API debe existir como secreto del proyecto. Sin esto, la
    APK instalada se cierra al abrir (la variable se hornea undefined).
    Se ejecuta una sola vez por URL (producción u homologación).
.NOTES
    Requiere EAS CLI configurado y autenticado (cuenta (cuenta de tienda propia)).
#>

param(
    [Parameter(Mandatory=$false)]
    [string]$Valor
)

$SecretName = "EXPO_PUBLIC_API_URL"
$DefaultUrl = "https://app.LevelYourDraw"

Write-Host "=== Secreto EAS: $SecretName ===" -ForegroundColor Cyan
Write-Host ""

# Setear variable de entorno para saltar verificación de Git
$env:EAS_NO_VCS="1"

# 1. Verificar EAS CLI
Write-Host "[1/3] Verificando EAS CLI y sesión..." -ForegroundColor Yellow
$null = eas --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "EAS CLI no instalado. Instala con: npm i -g eas-cli"
    exit 1
}
$WhoAmI = eas whoami 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Sin sesión. Ejecuta: eas login (cuenta (cuenta de tienda propia))"
    exit 1
}
Write-Host "     ✓ Sesión: $WhoAmI" -ForegroundColor Green

# 2. Pedir valor si no vino por parámetro
if (-not $Valor) {
    Write-Host ""
    Write-Host "URL actual en .env local (referencia):" -ForegroundColor Gray
    if (Test-Path ".env") {
        $LocalUrl = (Get-Content ".env" | Select-String "^EXPO_PUBLIC_API_URL=(.+)$" | ForEach-Object { $_.Matches[0].Groups[1].Value } | Select-Object -First 1)
        Write-Host "  $LocalUrl" -ForegroundColor Gray
    }
    Write-Host ""
    $Valor = Read-Host "URL de la API para la nube (Enter = $DefaultUrl)"
    if (-not $Valor) {
        $Valor = $DefaultUrl
    }
}

Write-Host "URL a configurar: $Valor" -ForegroundColor Yellow
$confirm = Read-Host "¿Crear/actualizar secreto? (S/n)"
if ($confirm -eq "n" -or $confirm -eq "N") {
    Write-Host "Cancelado." -ForegroundColor Yellow
    exit
}

# 3. Si ya existe, borrarlo primero (EAS no tiene update directo)
Write-Host "[2/3] Revisando secreto existente..." -ForegroundColor Yellow
$Existing = eas secret:list --json 2>&1 | ConvertFrom-Json | Where-Object { $_.name -eq $SecretName }
if ($Existing) {
    Write-Host "     Ya existe, eliminando para recrear..." -ForegroundColor Gray
    eas secret:delete --id $Existing.id --non-interactive 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "No se pudo eliminar el secreto existente"
        exit 1
    }
}

Write-Host "[3/3] Creando secreto..." -ForegroundColor Yellow
eas secret:create --name $SecretName --value $Valor --type string --scope project --non-interactive --force 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Error "No se pudo crear el secreto"
    exit 1
}

Write-Host ""
Write-Host "=== Secreto configurado ===" -ForegroundColor Green
Write-Host "Los próximos builds en la nube hornearán esa URL." -ForegroundColor Gray
Write-Host "Lanza .\build-preview-apk.ps1 para generar una APK que abra." -ForegroundColor Gray


