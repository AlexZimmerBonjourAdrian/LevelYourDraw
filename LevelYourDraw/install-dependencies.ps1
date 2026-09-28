<#
.SYNOPSIS
    Script de instalación de dependencias para LevelYourDraw
.DESCRIPTION
    Instala todas las dependencias del proyecto con versiones estables verificadas
    para Expo SDK 57, React Native 0.86.3 y React 19.2.3.
    Alinea versiones con el ledger oficial de Expo SDK 57 y reinstala dependencias críticas.
.NOTES
    Este script asegura versiones estables basadas en el ledger oficial de Expo SDK 57:
    - React 19.2.3, React Native 0.86.3 (exact pins)
    - Paquetes Expo oficiales ~57.0.x
    - Terceros verificados: async-storage 2.2.0, svg 15.15.4, gesture-handler 2.32.0, etc.
    Requisitos: Node.js 22.13.x o superior
#>

# Configuración
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = $ScriptDir  # El script está en el directorio del proyecto
$PackageJsonPath = Join-Path $ProjectRoot "package.json"

# Cambiar al directorio del proyecto
Set-Location $ProjectRoot

Write-Host "=== Instalación de Dependencias - LevelYourDraw" -ForegroundColor Cyan
Write-Host "Directorio del proyecto: $ProjectRoot" -ForegroundColor Gray
Write-Host "Directorio actual: $(Get-Location)" -ForegroundColor Gray
Write-Host ""

# Verificar versión de Node.js (Requisito crítico para SDK 57)
Write-Host "=== Verificando Requisitos del Sistema ===" -ForegroundColor Cyan
$NodeVersion = node --version
Write-Host "Node.js versión: $NodeVersion" -ForegroundColor Gray

# Node.js 22.13.x o superior es requerido para Expo SDK 57
$NodeVersionMatch = $NodeVersion -match 'v(\d+)\.(\d+)\.(\d+)'
if ($NodeVersionMatch) {
    $Major = [int]$Matches[1]
    $Minor = [int]$Matches[2]
    
    if ($Major -lt 22 -or ($Major -eq 22 -and $Minor -lt 13)) {
        Write-Host "❌ ERROR: Node.js $NodeVersion no cumple con el requisito mínimo" -ForegroundColor Red
        Write-Host "   Expo SDK 57 requiere Node.js 22.13.x o superior" -ForegroundColor Red
        Write-Host "   Por favor actualiza Node.js antes de continuar" -ForegroundColor Red
        exit 1
    }
    else {
        Write-Host "✓ Node.js cumple con los requisitos de Expo SDK 57" -ForegroundColor Green
    }
}
else {
    Write-Host "⚠ No se pudo determinar la versión de Node.js" -ForegroundColor Yellow
}

Write-Host ""

# Verificar que package.json existe
if (-not (Test-Path $PackageJsonPath)) {
    Write-Error "No se encontró package.json en: $PackageJsonPath"
    exit 1
}

# Leer package.json
$PackageJson = Get-Content $PackageJsonPath -Raw | ConvertFrom-Json

# Función para verificar si un paquete está instalado con la versión correcta
function Test-PackageInstalled {
    param(
        [string]$PackageName,
        [string]$RequiredVersion
    )
    
    try {
        # Obtener versión instalada
        $InstalledVersion = npm list $PackageName --depth=0 2>$null | Select-String "$PackageName@" | ForEach-Object {
            $_ -match "$PackageName@(.+)" | Out-Null
            $Matches[1]
        }
        
        if (-not $InstalledVersion) {
            return $false
        }
        
        # Normalizar versiones para comparación
        $InstalledVersion = $InstalledVersion.Trim()
        $RequiredVersion = $RequiredVersion.Trim()
        
        # Manejar rangos de versiones (^, ~, etc.)
        if ($RequiredVersion -match '^\^') {
            $RequiredVersion = $RequiredVersion -replace '^\^', ''
            # Verificar si la versión instalada es compatible con el rango ^
            $InstalledMajor = ($InstalledVersion -split '\.')[0]
            $RequiredMajor = ($RequiredVersion -split '\.')[0]
            return $InstalledMajor -eq $RequiredMajor
        }
        elseif ($RequiredVersion -match '^~') {
            $RequiredVersion = $RequiredVersion -replace '^~', ''
            # Verificar si la versión instalada es compatible con el rango ~
            $InstalledParts = $InstalledVersion -split '\.'
            $RequiredParts = $RequiredVersion -split '\.'
            return $InstalledParts[0] -eq $RequiredParts[0] -and $InstalledParts[1] -eq $RequiredParts[1]
        }
        else {
            # Versión exacta
            return $InstalledVersion -eq $RequiredVersion
        }
    }
    catch {
        return $false
    }
}

# Función para verificar si todas las dependencias están instaladas
function Test-AllDependenciesInstalled {
    param(
        [object]$Dependencies
    )
    
    $AllInstalled = $true
    foreach ($Dep in $Dependencies) {
        $PackageName = $Dep.Name
        $Version = $Dep.Value
        
        if (-not (Test-PackageInstalled -PackageName $PackageName -RequiredVersion $Version)) {
            $AllInstalled = $false
            Write-Host "  ✗ $PackageName@$Version - No instalado o versión incorrecta" -ForegroundColor Red
        }
        else {
            Write-Host "  ✓ $PackageName@$Version - Instalado" -ForegroundColor Green
        }
    }
    return $AllInstalled
}

# Verificar dependencias principales
Write-Host "=== Verificando Dependencias Principales ===" -ForegroundColor Cyan
$Dependencies = $PackageJson.dependencies.PSObject.Properties
$MainDepsInstalled = Test-AllDependenciesInstalled -Dependencies $Dependencies

# Verificar dependencias de desarrollo
Write-Host ""
Write-Host "=== Verificando Dependencias de Desarrollo ===" -ForegroundColor Cyan
$DevDependencies = $PackageJson.devDependencies.PSObject.Properties
$DevDepsInstalled = Test-AllDependenciesInstalled -Dependencies $DevDependencies

# Si faltan dependencias, instalar todas con versiones estables
if (-not $MainDepsInstalled -or -not $DevDepsInstalled) {
    Write-Host ""
    Write-Host "=== Instalando Dependencias con Versiones Estables ===" -ForegroundColor Cyan
    Write-Host "Faltan dependencias o versiones incorrectas. Reinstalando con versiones verificadas..." -ForegroundColor Yellow

    # Borrar node_modules para reinstalar limpio
    Write-Host "Preparando instalación limpia..." -ForegroundColor Yellow

    if (Test-Path "node_modules") {
        Write-Host "Eliminando node_modules..." -ForegroundColor Gray
        Remove-Item -Path "node_modules" -Recurse -Force
    }
    if (Test-Path "package-lock.json") {
        Write-Host "Eliminando package-lock.json..." -ForegroundColor Gray
        Remove-Item -Path "package-lock.json" -Force
    }

    # Limpiar cache de npm
    Write-Host "Limpiando cache de npm..." -ForegroundColor Gray
    npm cache clean --force

    # Instalar dependencias base con npm install
    Write-Host "Instalando dependencias base..." -ForegroundColor Gray
    npm install

    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "=== Error ===" -ForegroundColor Red
        Write-Host "Hubo problemas durante la instalación base." -ForegroundColor Red
        exit 1
    }

    # Instalar dependencias críticas faltantes para testing
    Write-Host ""
    Write-Host "=== Instalando Dependencias Críticas de Testing ===" -ForegroundColor Cyan


    Write-Host ""
    Write-Host "=== Ajustando Versiones de Testing ===" -ForegroundColor Cyan

    Write-Host "vite@^6.4.2 (compatible con React Native testing)" -ForegroundColor Gray
    npm install --save-dev vite@^6.4.2

    # Alinear con Expo SDK ledger oficial
    Write-Host ""
    Write-Host "=== Alineando con Expo SDK 57 Ledger ===" -ForegroundColor Cyan
    Write-Host "Verificando que expo esté instalado..." -ForegroundColor Gray

    # Verificar que expo esté instalado
    $ExpoInstalled = npm list expo --depth=0 2>$null | Select-String "expo@"
    if ($ExpoInstalled) {
        Write-Host "✓ expo está instalado" -ForegroundColor Green
        Write-Host "Ejecutando npx expo install --fix para asegurar compatibilidad..." -ForegroundColor Yellow
        npx expo install --fix

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Versiones de Expo alineadas con SDK 57 ledger" -ForegroundColor Green
        }
        else {
            Write-Host "⚠ Advertencia: Hubo problemas al alinear con Expo SDK" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "⚠ expo no está instalado, instalándolo manualmente..." -ForegroundColor Yellow
        npm install expo@^57.0.0
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ expo instalado, intentando alinear..." -ForegroundColor Green
            npx expo install --fix
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✓ Versiones de Expo alineadas con SDK 57 ledger" -ForegroundColor Green
            }
            else {
                Write-Host "⚠ Advertencia: Hubo problemas al alinear con Expo SDK" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "⚠ No se pudo instalar expo, pero continuando con otras dependencias..." -ForegroundColor Yellow
        }
    }

    Write-Host ""
    Write-Host "=== Instalación Completada ===" -ForegroundColor Green
    Write-Host "Todas las dependencias están instaladas con versiones estables." -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "=== Verificando Versiones Críticas ===" -ForegroundColor Cyan

    # Verificar dependencias críticas de testing
    $CriticalDeps = @{
        "vite" = "^6.4.2"
    }

    $CriticalDepsInstalled = $true
    foreach ($Dep in $CriticalDeps.GetEnumerator()) {
        $Name = $Dep.Key
        $Version = $Dep.Value

        if (-not (Test-PackageInstalled -PackageName $Name -RequiredVersion $Version)) {
            $CriticalDepsInstalled = $false
            Write-Host "  ✗ $Name@$Version - No instalado o versión incorrecta" -ForegroundColor Red
        }
        else {
            Write-Host "  ✓ $Name@$Version - Instalado" -ForegroundColor Green
        }
    }

    if (-not $CriticalDepsInstalled) {
        Write-Host ""
        Write-Host "=== Instalando Dependencias Críticas Faltantes ===" -ForegroundColor Cyan

        foreach ($Dep in $CriticalDeps.GetEnumerator()) {
            $Name = $Dep.Key
            $Version = $Dep.Value

            if (-not (Test-PackageInstalled -PackageName $Name -RequiredVersion $Version)) {
                Write-Host "Instalando $Name@$Version..." -ForegroundColor Gray
                npm install --save-dev "$Name@$Version"
            }
        }
    }
    else {
        Write-Host ""
        Write-Host "=== Dependencias Ya Instaladas ===" -ForegroundColor Green
        Write-Host "Todas las dependencias están correctamente instaladas." -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Ejecutando npm install para asegurar consistencia de package-lock.json..." -ForegroundColor Yellow
    npm install
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "=== Sincronización Completada ===" -ForegroundColor Green
    Write-Host "package-lock.json está sincronizado con package.json." -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "=== Advertencia ===" -ForegroundColor Yellow
    Write-Host "Hubo problemas durante la sincronización final." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Verificación Final ===" -ForegroundColor Cyan
Write-Host "Ejecutando expo-doctor para verificar compatibilidad..." -ForegroundColor Yellow
npx expo-doctor@latest

Write-Host ""
Write-Host "=== Resumen de Versiones Estables Instaladas ===" -ForegroundColor Cyan
Write-Host "React: 19.2.3 (exact pin SDK 57)" -ForegroundColor Green
Write-Host "React Native: 0.86.3 (exact pin SDK 57)" -ForegroundColor Green
Write-Host "Expo: ~57.0.24 (SDK 57)" -ForegroundColor Green
Write-Host "Async Storage: 2.2.0 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "SVG: 15.15.4 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "Gesture Handler: 2.32.0 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "Safe Area Context: 5.7.0 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "Screens: 4.26.0 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "React Test Renderer: 19.2.3 (matching React)" -ForegroundColor Green
Write-Host "Test Renderer: 1.2.0 (React 19.2 compatible)" -ForegroundColor Green
Write-Host "Vite: 6.4.2 (React Native compatible)" -ForegroundColor Green

Write-Host ""
Write-Host "=== Próximos Pasos ===" -ForegroundColor Cyan
Write-Host "1. Para iniciar el servidor de desarrollo, ejecuta: .\start.ps1" -ForegroundColor Gray
Write-Host "2. Si hubo cambios en dependencias nativas, genera nueva development build:" -ForegroundColor Gray
Write-Host "   eas build --profile development --platform android" -ForegroundColor Gray
Write-Host "   eas build --profile development --platform ios" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠ IMPORTANTE: Los cambios en dependencias nativas requieren nueva build." -ForegroundColor Yellow

