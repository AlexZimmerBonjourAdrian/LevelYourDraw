$env:NODE_ENV = "development"

cd ". (raiz del proyecto)"

Write-Host "=== Limpiando cache de Metro y reiniciando servidor ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Este script:" -ForegroundColor Yellow
Write-Host "  1. Detiene procesos existentes" -ForegroundColor Gray
Write-Host "  2. Limpia cache de Metro con --clear" -ForegroundColor Gray
Write-Host "  3. Reinicia el servidor de desarrollo" -ForegroundColor Gray
Write-Host ""
Write-Host "Útil cuando:" -ForegroundColor Yellow
Write-Host "  - Hay errores de cache de Metro" -ForegroundColor Gray
Write-Host "  - Se cambiaron dependencias del proyecto" -ForegroundColor Gray
Write-Host "  - Hay mensajes 'Unable to deserialize cloned data'" -ForegroundColor Gray
Write-Host ""

# Detener procesos existentes
Write-Host "Deteniendo procesos existentes..." -ForegroundColor Yellow
try {
    Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "  ✓ Procesos de Node terminados" -ForegroundColor Green
} catch {
    Write-Host "  - No se encontraron procesos de Node" -ForegroundColor Gray
}

try {
    Get-Process expo -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "  ✓ Procesos de Expo terminados" -ForegroundColor Green
} catch {
    Write-Host "  - No se encontraron procesos de Expo" -ForegroundColor Gray
}

Write-Host ""
Write-Host "Limpiando cache de Metro..." -ForegroundColor Yellow
Write-Host "Iniciando servidor con --clear..." -ForegroundColor Green
Write-Host ""
Write-Host "Servidor iniciará en http://localhost:8081" -ForegroundColor Cyan
Write-Host "Presiona Ctrl+C para detener el servidor" -ForegroundColor Gray
Write-Host ""

& npx expo start --clear

