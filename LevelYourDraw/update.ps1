# Script para publicar actualizaciones EAS Update
# Uso: .\update.ps1

# Setear variable de entorno para saltar verificación de Git
$env:EAS_NO_VCS="1"

Write-Host "=== Script de EAS Update ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Este comando publica una actualización over-the-air sin crear un nuevo build." -ForegroundColor Yellow
Write-Host ""

# Pedir mensaje de la actualización
$mensaje = Read-Host "Mensaje de la actualización (ej: fix: corregir error en login)"

# Validar que no esté vacío
if ([string]::IsNullOrWhiteSpace($mensaje)) {
    Write-Host "El mensaje no puede estar vacío. Saliendo..." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Publicando actualización..." -ForegroundColor Green
Write-Host "Branch: production" -ForegroundColor Yellow
Write-Host "Mensaje: $mensaje" -ForegroundColor Yellow
Write-Host ""

# Ejecutar el update
eas update --branch production --message $mensaje

