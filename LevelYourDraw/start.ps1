$env:NODE_ENV = "development"

Set-Location $PSScriptRoot

Write-Host "Iniciando servidor de desarrollo de Expo..." -ForegroundColor Cyan
Write-Host "Opciones disponibles:" -ForegroundColor Yellow
Write-Host "  --clear      Limpiar caché antes de iniciar" -ForegroundColor Gray
Write-Host "  --no-devtools Sin herramientas de desarrollo" -ForegroundColor Gray
Write-Host "  --minify     Minificar código" -ForegroundColor Gray
Write-Host ""
Write-Host "Iniciando servidor en http://localhost:8081" -ForegroundColor Green
Write-Host "Presiona Ctrl+C para detener el servidor" -ForegroundColor Gray
Write-Host ""
Write-Host "Para ver logs en tiempo real en otra terminal:" -ForegroundColor Yellow
Write-Host "Get-Content .expo\dev\logs\start.log -Wait -Tail 20" -ForegroundColor Gray
Write-Host ""

& npx expo start

