# Script simple para verificar si el proyecto está en Development
# Uso: .\check-dev-mode.ps1

$hasExpoDevClient = $false
$hasDevClient = $false

# Verificar package.json
if (Test-Path "package.json") {
    $packageJson = Get-Content "package.json" | ConvertFrom-Json
    if ($packageJson.dependencies."expo-dev-client") {
        $hasExpoDevClient = $true
    }
}

# Verificar eas.json
if (Test-Path "eas.json") {
    $easJson = Get-Content "eas.json" | ConvertFrom-Json
    if ($easJson.build.development.developmentClient -eq $true) {
        $hasDevClient = $true
    }
}

if ($hasExpoDevClient -and $hasDevClient) {
    Write-Host "🟢 DEVELOPMENT BUILD - Logs activos" -ForegroundColor Green
} else {
    Write-Host "🔴 PRODUCTION BUILD - Logs desactivados" -ForegroundColor Red
}
