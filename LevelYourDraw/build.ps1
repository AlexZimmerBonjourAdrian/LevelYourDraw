# Script para crear builds de desarrollo con EAS
# Uso: .\build.ps1 [opcion] o .\build.ps1 para elegir interactivamente

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet(1, 2, 3)]
    [int]$opcion
)

# Si no se proporciona opción, mostrar menú interactivo
if (-not $opcion) {
    Write-Host "=== Script de Build de Desarrollo ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Opciones disponibles:" -ForegroundColor Yellow
    Write-Host "  1 - Android" -ForegroundColor White
    Write-Host "  2 - iOS" -ForegroundColor White
    Write-Host "  3 - Todos (Android + iOS)" -ForegroundColor White
    Write-Host ""

    $seleccion = Read-Host "Selecciona una opción (1-3)"

    # Validar la selección
    switch ($seleccion) {
        "1" { $opcion = 1 }
        "2" { $opcion = 2 }
        "3" { $opcion = 3 }
        default {
            Write-Host "Opción no válida. Saliendo..." -ForegroundColor Red
            exit
        }
    }
}

# Mapear opción a plataforma
switch ($opcion) {
    1 { $platform = "android" }
    2 { $platform = "ios" }
    3 { $platform = "all" }
}

# Setear variable de entorno para saltar verificación de Git
$env:EAS_NO_VCS="1"

Write-Host "Iniciando build de desarrollo para $platform..." -ForegroundColor Green
Write-Host "Perfil: development" -ForegroundColor Yellow
Write-Host "Variable EAS_NO_VCS configurada" -ForegroundColor Yellow

# Ejecutar el build
eas build --platform $platform --profile development

