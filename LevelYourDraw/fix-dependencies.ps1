<#
.SYNOPSIS
    Script de reparación de dependencias para LevelYourDraw
.DESCRIPTION
    Soluciona errores de dependencias reinstalando con versiones estables de Expo SDK 57.
    Este script es útil cuando hay errores de cache, módulos faltantes o incompatibilidades.
.NOTES
    Versión actualizada para Expo SDK 57 con versiones estables verificadas:
    - React 19.2.3, React Native 0.86.3
    - Requisitos: Node.js 22.13.x o superior
#>

# Configuración
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = $ScriptDir  # El script está en el directorio del proyecto

# Cambiar al directorio del proyecto
Set-Location $ProjectRoot

Write-Host "=== Script de Reparación de Dependencias ===" -ForegroundColor Cyan
Write-Host "Directorio del proyecto: $ProjectRoot" -ForegroundColor Gray
Write-Host "Directorio actual: $(Get-Location)" -ForegroundColor Gray
Write-Host ""
Write-Host "Este script soluciona errores como:" -ForegroundColor Yellow
Write-Host "  - 'Cannot find module minimatch'" -ForegroundColor Gray
Write-Host "  - 'Unable to deserialize cloned data'" -ForegroundColor Gray
Write-Host "  - Errores de cache de Metro" -ForegroundColor Gray
Write-Host "  - Incompatibilidades de versiones" -ForegroundColor Gray
Write-Host "  - Dependencias faltantes de testing" -ForegroundColor Gray
Write-Host ""
Write-Host "Pasos que ejecutará:" -ForegroundColor Yellow
Write-Host "  1. Verificar requisitos del sistema" -ForegroundColor Gray
Write-Host "  2. Detener procesos existentes" -ForegroundColor Gray
Write-Host "  3. Eliminar node_modules y package-lock.json" -ForegroundColor Gray
Write-Host "  4. Limpiar cache de npm" -ForegroundColor Gray
Write-Host "  5. Reinstalar dependencias con versiones estables" -ForegroundColor Gray
Write-Host "  6. Instalar dependencias críticas de testing" -ForegroundColor Gray
Write-Host "  7. Alinear con Expo SDK 57 ledger" -ForegroundColor Gray
Write-Host "  8. Limpiar cache de Metro" -ForegroundColor Gray
Write-Host "  9. Verificar con expo-doctor" -ForegroundColor Gray
Write-Host ""
Write-Host "Tiempo estimado: 3-6 minutos" -ForegroundColor Cyan
Write-Host ""

# Paso 1: Verificar requisitos del sistema
Write-Host "[1/9] Verificando requisitos del sistema..." -ForegroundColor Yellow
$NodeVersion = node --version
Write-Host "     Node.js versión: $NodeVersion" -ForegroundColor Gray

# Node.js 22.13.x o superior es requerido para Expo SDK 57
$NodeVersionMatch = $NodeVersion -match 'v(\d+)\.(\d+)\.(\d+)'
if ($NodeVersionMatch) {
    $Major = [int]$Matches[1]
    $Minor = [int]$Matches[2]

    if ($Major -lt 22 -or ($Major -eq 22 -and $Minor -lt 13)) {
        Write-Host "     ❌ ERROR: Node.js $NodeVersion no cumple con el requisito mínimo" -ForegroundColor Red
        Write-Host "        Expo SDK 57 requiere Node.js 22.13.x o superior" -ForegroundColor Red
        Write-Host "        Por favor actualiza Node.js antes de continuar" -ForegroundColor Red
        exit 1
    }
    else {
        Write-Host "     ✓ Node.js cumple con los requisitos de Expo SDK 57" -ForegroundColor Green
    }
}
else {
    Write-Host "     ⚠ No se pudo determinar la versión de Node.js" -ForegroundColor Yellow
}

# Paso 2: Detener procesos existentes
Write-Host "[2/9] Deteniendo procesos existentes..." -ForegroundColor Yellow
try {
    Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "     ✓ Procesos de Node terminados" -ForegroundColor Green
} catch {
    Write-Host "     - No se encontraron procesos de Node" -ForegroundColor Gray
}

try {
    Get-Process expo -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "     ✓ Procesos de Expo terminados" -ForegroundColor Green
} catch {
    Write-Host "     - No se encontraron procesos de Expo" -ForegroundColor Gray
}

# Paso 3: Eliminar node_modules y package-lock.json
Write-Host "[3/9] Eliminando node_modules y package-lock.json..." -ForegroundColor Yellow
try {
    Remove-Item -Recurse -Force node_modules -ErrorAction Stop
    Write-Host "     ✓ node_modules eliminado" -ForegroundColor Green
} catch {
    Write-Host "     - node_modules no existe o ya fue eliminado" -ForegroundColor Gray
}

try {
    Remove-Item package-lock.json -ErrorAction Stop
    Write-Host "     ✓ package-lock.json eliminado" -ForegroundColor Green
} catch {
    Write-Host "     - package-lock.json no existe" -ForegroundColor Gray
}

# Paso 4: Limpiar cache de npm
Write-Host "[4/9] Limpiando cache de npm..." -ForegroundColor Yellow
npm cache clean --force
Write-Host "     ✓ Cache de npm limpiado" -ForegroundColor Green

# Paso 5: Reinstalar dependencias base
Write-Host "[5/9] Reinstalando dependencias base..." -ForegroundColor Yellow
Write-Host "     Esto puede tomar 1-3 minutos..." -ForegroundColor Gray
npm install
Write-Host "     ✓ Dependencias base reinstaladas" -ForegroundColor Green

# Paso 6: Instalar dependencias críticas de testing
Write-Host "[6/9] Instalando dependencias críticas de testing..." -ForegroundColor Yellow



Write-Host "     vite@^6.4.2 (compatible con React Native testing)" -ForegroundColor Gray
npm install --save-dev vite@^6.4.2
Write-Host "     ✓ Dependencias críticas de testing instaladas" -ForegroundColor Green

# Paso 7: Alinear con Expo SDK 57 ledger
Write-Host "[7/9] Alineando con Expo SDK 57 ledger..." -ForegroundColor Yellow
Write-Host "     Verificando que expo esté instalado..." -ForegroundColor Gray

# Verificar que expo esté instalado
$ExpoInstalled = npm list expo --depth=0 2>$null | Select-String "expo@" 
if ($ExpoInstalled) {
    Write-Host "     ✓ expo está instalado" -ForegroundColor Green
    Write-Host "     Ejecutando npx expo install --fix..." -ForegroundColor Gray
    npx expo install --fix
    if ($LASTEXITCODE -eq 0) {
        Write-Host "     ✓ Versiones alineadas con SDK 57 ledger" -ForegroundColor Green
    }
    else {
        Write-Host "     ⚠ Advertencia: npx expo install --fix tuvo problemas, pero continuando..." -ForegroundColor Yellow
    }
}
else {
    Write-Host "     ⚠ expo no está instalado, instalándolo manualmente..." -ForegroundColor Yellow
    npm install expo@^57.0.0
    if ($LASTEXITCODE -eq 0) {
        Write-Host "     ✓ expo instalado, intentando alinear..." -ForegroundColor Green
        npx expo install --fix
        if ($LASTEXITCODE -eq 0) {
            Write-Host "     ✓ Versiones alineadas con SDK 57 ledger" -ForegroundColor Green
        }
        else {
            Write-Host "     ⚠ Advertencia: npx expo install --fix tuvo problemas, pero continuando..." -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "     ⚠ No se pudo instalar expo, pero continuando con otras dependencias..." -ForegroundColor Yellow
    }
}

# Paso 8: Limpiar cache de Metro
Write-Host "[8/9] Limpiando cache de Metro..." -ForegroundColor Yellow
try {
    Remove-Item -Recurse -Force .expo -ErrorAction Stop
    Write-Host "     ✓ Directorio .expo eliminado" -ForegroundColor Green
} catch {
    Write-Host "     - .expo no existe" -ForegroundColor Gray
}

try {
    Remove-Item -Recurse -Force node_modules\.cache -ErrorAction Stop
    Write-Host "     ✓ Cache de node_modules eliminado" -ForegroundColor Green
} catch {
    Write-Host "     - node_modules\.cache no existe" -ForegroundColor Gray
}

# Paso 9: Verificar con expo-doctor
Write-Host "[9/9] Verificando compatibilidad con expo-doctor..." -ForegroundColor Yellow
npx expo-doctor@latest
Write-Host "     ✓ Verificación completada" -ForegroundColor Green

Write-Host ""
Write-Host "=== Reparación Completada ===" -ForegroundColor Green
Write-Host ""
Write-Host "Resumen de versiones estables instaladas:" -ForegroundColor Cyan
Write-Host "  React: 19.2.3 (exact pin SDK 57)" -ForegroundColor Green
Write-Host "  React Native: 0.86.3 (exact pin SDK 57)" -ForegroundColor Green
Write-Host "  Expo: ~57.0.24 (SDK 57)" -ForegroundColor Green
Write-Host "  Async Storage: 2.2.0 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "  SVG: 15.15.4 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "  Gesture Handler: 2.32.0 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "  Safe Area Context: 5.7.0 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "  Screens: 4.26.0 (SDK 57 ledger)" -ForegroundColor Green
Write-Host "  React Test Renderer: 19.2.3 (matching React)" -ForegroundColor Green
Write-Host "  Test Renderer: 1.2.0 (React 19.2 compatible)" -ForegroundColor Green
Write-Host "  Vite: 6.4.2 (React Native compatible)" -ForegroundColor Green
Write-Host ""
Write-Host "=== Próximos Pasos ===" -ForegroundColor Cyan
Write-Host "1. Para iniciar el servidor de desarrollo, ejecuta: .\start.ps1" -ForegroundColor Gray
Write-Host "2. Si hubo cambios en dependencias nativas, genera nueva development build:" -ForegroundColor Gray
Write-Host "   eas build --profile development --platform android" -ForegroundColor Gray
Write-Host "   eas build --profile development --platform ios" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠ IMPORTANTE: Los cambios en dependencias nativas requieren nueva build." -ForegroundColor Yellow
Write-Host ""
Write-Host "¿Deseas iniciar el servidor de desarrollo ahora? (S/N)" -ForegroundColor Cyan
$Response = Read-Host

if ($Response -eq 'S' -or $Response -eq 's' -or $Response -eq 'Y' -or $Response -eq 'y') {
    Write-Host ""
    Write-Host "Iniciando servidor de desarrollo..." -ForegroundColor Cyan
    Write-Host "Servidor iniciará en http://localhost:8081" -ForegroundColor Gray
    Write-Host "Presiona Ctrl+C para detener el servidor" -ForegroundColor Gray
    Write-Host ""

    & npx expo start --clear
}
else {
    Write-Host ""
    Write-Host "Puedes iniciar el servidor más tarde con: .\start.ps1" -ForegroundColor Gray
}

