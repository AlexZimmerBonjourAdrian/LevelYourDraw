# Script para iniciar servidor de desarrollo de Expo en modo Development build
# Este modo muestra los logs de console.log en la terminal

Write-Host "=== Iniciando servidor de development build ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Este modo muestra los logs de console.log en la terminal." -ForegroundColor Green
Write-Host "Los logs aparecerán abajo cuando la app haga llamadas a la API." -ForegroundColor Green
Write-Host ""
Write-Host "Para detener el servidor, presiona Ctrl+C" -ForegroundColor Yellow
Write-Host ""

# Iniciar servidor en modo development build
npx expo start --dev-client

