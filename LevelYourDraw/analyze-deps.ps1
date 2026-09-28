# Script para análisis de dependencias del proyecto

Write-Host "=== Análisis de Dependencias ===" -ForegroundColor Cyan
Write-Host ""

cd ". (raiz del proyecto)"

# Función para mostrar dependencias de producción
function Show-ProductionDeps {
    Write-Host "=== Dependencias de Producción ===" -ForegroundColor Yellow
    Write-Host "Estas dependencias se incluyen en el build:" -ForegroundColor Gray
    Write-Host ""
    
    $deps = Get-Content package.json | ConvertFrom-Json
    $deps.dependencies.PSObject.Properties | ForEach-Object {
        Write-Host "$($_.Name): $($_.Value)" -ForegroundColor White
    }
    Write-Host ""
}

# Función para mostrar dependencias de desarrollo
function Show-DevDeps {
    Write-Host "=== Dependencias de Desarrollo ===" -ForegroundColor Yellow
    Write-Host "Estas dependencias NO se incluyen en el build:" -ForegroundColor Gray
    Write-Host ""
    
    $deps = Get-Content package.json | ConvertFrom-Json
    $deps.devDependencies.PSObject.Properties | ForEach-Object {
        Write-Host "$($_.Name): $($_.Value)" -ForegroundColor White
    }
    Write-Host ""
}

# Función para analizar dependencias de testing
function Show-TestingDeps {
    Write-Host "=== Dependencias de Testing ===" -ForegroundColor Yellow
    Write-Host "Estas pueden causar el problema de DefaultToolLauncher:" -ForegroundColor Gray
    Write-Host ""
    
    $testingDeps = @(
        "jest",
        "ts-jest", 
        "@types/jest",
        "babel-jest"
    )
    
    $deps = Get-Content package.json | ConvertFrom-Json
    $deps.devDependencies.PSObject.Properties | ForEach-Object {
        if ($testingDeps -contains $_.Name) {
            Write-Host "$($_.Name): $($_.Value)" -ForegroundColor Red
        }
    }
    Write-Host ""
}

# Función para verificar compatibilidad de Babel
function Check-BabelCompatibility {
    Write-Host "=== Compatibilidad de Babel ===" -ForegroundColor Yellow
    Write-Host ""
    
    $deps = Get-Content package.json | ConvertFrom-Json
    
    $babelCore = $deps.devDependencies.'@babel/core'
    $tsJest = $deps.devDependencies.'ts-jest'
    
    Write-Host "@babel/core: $babelCore" -ForegroundColor White
    Write-Host "ts-jest: $tsJest" -ForegroundColor White
    Write-Host ""
    
    if ($babelCore -match "^8\.") {
        Write-Host "ALERTA: Babel 8.x no es compatible con ts-jest actual" -ForegroundColor Red
        Write-Host "ts-jest requiere @babel/core >=7.0.0-beta.0 <8" -ForegroundColor Gray
    } elseif ($babelCore -match "^7\.") {
        Write-Host "OK: Babel 7.x es compatible con ts-jest" -ForegroundColor Green
    }
    Write-Host ""
}

# Función para verificar versiones de Expo/React Native
function Check-ExpoVersions {
    Write-Host "=== Versiones de Expo/React Native ===" -ForegroundColor Yellow
    Write-Host ""
    
    $deps = Get-Content package.json | ConvertFrom-Json
    
    $expo = $deps.dependencies.expo
    $reactNative = $deps.dependencies.'react-native'
    $react = $deps.dependencies.react
    
    Write-Host "Expo: $expo" -ForegroundColor White
    Write-Host "React Native: $reactNative" -ForegroundColor White
    Write-Host "React: $react" -ForegroundColor White
    Write-Host ""
    
    if ($expo -match "~57\.") {
        Write-Host "OK: Expo SDK 57" -ForegroundColor Green
        if ($reactNative -match "0\.86\.") {
            Write-Host "OK: React Native 0.86 (compatible con Expo 57)" -ForegroundColor Green
        } else {
            Write-Host "ALERTA: React Native version no coincide con Expo 57" -ForegroundColor Red
        }
    }
    Write-Host ""
}

# Función para verificar dependencias desactualizadas
function Check-Outdated {
    Write-Host "=== Verificando dependencias desactualizadas ===" -ForegroundColor Yellow
    Write-Host "Esto puede tardar unos segundos..." -ForegroundColor Gray
    Write-Host ""
    
    npm outdated
    Write-Host ""
}

# Menú interactivo
Write-Host "Selecciona una opción:" -ForegroundColor Yellow
Write-Host "1. Ver dependencias de producción"
Write-Host "2. Ver dependencias de desarrollo"
Write-Host "3. Ver dependencias de testing (relevantes para DefaultToolLauncher)"
Write-Host "4. Verificar compatibilidad de Babel"
Write-Host "5. Verificar versiones de Expo/React Native"
Write-Host "6. Verificar dependencias desactualizadas"
Write-Host "7. Análisis completo (todas las opciones)"
Write-Host "8. Salir"
Write-Host ""

$opcion = Read-Host "Opción"

switch ($opcion) {
    "1" {
        Show-ProductionDeps
    }
    "2" {
        Show-DevDeps
    }
    "3" {
        Show-TestingDeps
    }
    "4" {
        Check-BabelCompatibility
    }
    "5" {
        Check-ExpoVersions
    }
    "6" {
        Check-Outdated
    }
    "7" {
        Show-ProductionDeps
        Show-DevDeps
        Show-TestingDeps
        Check-BabelCompatibility
        Check-ExpoVersions
        Check-Outdated
    }
    "8" {
        Write-Host "Saliendo..." -ForegroundColor Gray
        exit
    }
    default {
        Write-Host "Opción inválida" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Presiona Enter para salir..."
Read-Host
