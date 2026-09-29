# Script para monitorear builds de EAS

Write-Host "=== Monitor de Builds EAS ===" -ForegroundColor Cyan
Write-Host ""

Set-Location $PSScriptRoot

# Función para mostrar builds recientes
function Show-RecentBuilds {
    Write-Host "Builds recientes:" -ForegroundColor Yellow
    eas build:list
    Write-Host ""
}

# Función para mostrar builds en cola con tiempo exacto
function Show-QueueBuilds {
    Write-Host "=== Builds en Cola y Estado Actual ===" -ForegroundColor Yellow
    Write-Host "Mostrando builds pendientes y en proceso..." -ForegroundColor Gray
    Write-Host ""

    $result = eas build:list --limit 20 --non-interactive

    if ($result) {
        # Analizar el output para extraer información relevante
        $lines = $result -split "`n"
        $currentBuild = $null
        $inBuildBlock = $false

        foreach ($line in $lines) {
            if ($line -match "^ID\s+(.+)") {
                $currentBuild = @{
                    ID = $Matches[1]
                    Platform = ""
                    Status = ""
                    StartedAt = $null
                    FinishedAt = $null
                }
                $inBuildBlock = $true
            }
            elseif ($inBuildBlock) {
                if ($line -match "^Platform\s+(.+)") { $currentBuild.Platform = $Matches[1] }
                elseif ($line -match "^Status\s+(.+)") { $currentBuild.Status = $Matches[1] }
                elseif ($line -match "^Started at\s+(.+)") {
                    $dateString = $Matches[1]
                    # Verificar si es "‹in progress›" en lugar de fecha
                    if ($dateString -match "in progress") {
                        $currentBuild.StartedAt = $null
                    }
                    else {
                        try {
                            $currentBuild.StartedAt = [DateTime]::ParseExact($dateString, "M/d/yyyy, HH:mm:ss", $null)
                        }
                        catch {
                            # Intentar formato alternativo si falla
                            try {
                                $currentBuild.StartedAt = [DateTime]::Parse($dateString)
                            }
                            catch {
                                $currentBuild.StartedAt = $null
                            }
                        }
                    }
                }
                elseif ($line -match "^Finished at\s+(.+)") {
                    $dateString = $Matches[1]
                    # Verificar si es "‹in progress›" en lugar de fecha
                    if ($dateString -match "in progress") {
                        $currentBuild.FinishedAt = $null
                    }
                    else {
                        try {
                            $currentBuild.FinishedAt = [DateTime]::ParseExact($dateString, "M/d/yyyy, HH:mm:ss", $null)
                        }
                        catch {
                            try {
                                $currentBuild.FinishedAt = [DateTime]::Parse($dateString)
                            }
                            catch {
                                $currentBuild.FinishedAt = $null
                            }
                        }
                    }
                }
                elseif ($line -match "^—+$") {
                    # Fin del bloque de build
                    if ($currentBuild.Status -match "(in queue|in progress|new)") {
                        $elapsed = if ($currentBuild.StartedAt) {
                            (Get-Date) - $currentBuild.StartedAt
                        } else {
                            $null
                        }

                        Write-Host "Build ID: $($currentBuild.ID)" -ForegroundColor Cyan
                        Write-Host "  Plataforma: $($currentBuild.Platform)" -ForegroundColor Gray
                        Write-Host "  Estado: $($currentBuild.Status)" -ForegroundColor Green
                        if ($currentBuild.StartedAt) {
                            Write-Host "  Iniciado: $($currentBuild.StartedAt.ToString('HH:mm:ss'))" -ForegroundColor Gray
                            if ($elapsed) {
                                $elapsedStr = "{0:hh\:mm\:ss}" -f $elapsed
                                Write-Host "  Tiempo transcurrido: $elapsedStr" -ForegroundColor Yellow
                            }
                        }
                        Write-Host ""
                    }
                    $currentBuild = $null
                    $inBuildBlock = $false
                }
            }
        }

        Write-Host "Tiempo estimado según cola de Expo gratuito:" -ForegroundColor Cyan
        Write-Host "- Builds rápidas: 15-30 minutos (cola baja)" -ForegroundColor Gray
        Write-Host "- Builds normales: 30-60 minutos (cola media)" -ForegroundColor Gray
        Write-Host "- Builds lentas: 60-120 minutos (cola alta)" -ForegroundColor Gray
        Write-Host ""
    }
    else {
        Write-Host "No se pudieron obtener builds en cola" -ForegroundColor Red
    }
}

# Función para monitorear un build específico
function Watch-Build {
    param(
        [string]$BuildId
    )
    
    Write-Host "Monitoreando build: $BuildId" -ForegroundColor Green
    Write-Host "Presiona Ctrl+C para detener el monitoreo" -ForegroundColor Gray
    Write-Host ""
    
    while ($true) {
        $result = eas build:view $BuildId
        Clear-Host
        Write-Host "=== Monitor de Build EAS ===" -ForegroundColor Cyan
        Write-Host "Build ID: $BuildId" -ForegroundColor Green
        Write-Host ""
        Write-Host $result
        Write-Host ""
        Write-Host "Actualizado: $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor Gray
        Write-Host "Presiona Ctrl+C para detener" -ForegroundColor Gray
        
        Start-Sleep -Seconds 30
    }
}

# Menú interactivo
Write-Host "Selecciona una opción:" -ForegroundColor Yellow
Write-Host "1. Ver builds recientes"
Write-Host "2. Monitorear build específico (por ID)"
Write-Host "3. Ver builds de este proyecto"
Write-Host "4. Ver builds en cola y tiempo estimado"
Write-Host "5. Salir"
Write-Host ""

$opcion = Read-Host "Opción"

switch ($opcion) {
    "1" {
        Show-RecentBuilds
    }
    "2" {
        $buildId = Read-Host "Ingresa el ID del build"
        if ($buildId) {
            Watch-Build -BuildId $buildId
        } else {
            Write-Host "ID de build inválido" -ForegroundColor Red
        }
    }
    "3" {
        Write-Host "Builds del proyecto actual:" -ForegroundColor Yellow
        eas build:list --limit 10
    }
    "4" {
        Show-QueueBuilds
    }
    "5" {
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

