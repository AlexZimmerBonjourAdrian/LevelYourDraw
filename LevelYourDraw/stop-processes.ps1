# Script para detener todos los procesos activos de la aplicación

Write-Host "=== Deteniendo todos los procesos activos ===" -ForegroundColor Cyan
Write-Host ""

cd ". (raiz del proyecto)"

# Detener procesos de Node
Write-Host "Deteniendo procesos de Node..." -ForegroundColor Yellow
try {
    Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Procesos de Node terminados" -ForegroundColor Green
} catch {
    Write-Host "No se encontraron procesos de Node" -ForegroundColor Gray
}

# Detener procesos de Expo
Write-Host "Deteniendo procesos de Expo..." -ForegroundColor Yellow
try {
    Get-Process expo -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Procesos de Expo terminados" -ForegroundColor Green
} catch {
    Write-Host "No se encontraron procesos de Expo" -ForegroundColor Gray
}

# Liberar puertos 8081 y 8082
Write-Host "Liberando puertos 8081 y 8082..." -ForegroundColor Yellow
$ports = @(8081, 8082)
foreach ($port in $ports) {
    try {
        $connections = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
        if ($connections) {
            foreach ($conn in $connections) {
                try {
                    Stop-Process -Id $conn.OwningProcess -Force
                } catch {}
            }
        }
    } catch {}
}
Write-Host "Puertos liberados" -ForegroundColor Green

Write-Host ""
Write-Host "=== Limpieza completada ===" -ForegroundColor Green
