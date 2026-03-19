# ==================================
# CONFIGURACIÓN
# ==================================

# VMs internas (EAST-WEST)
$InternalWindowsVMs = @(
    "10.160.127.119",
    "WINZNLABAPP.ZNLAB.LOC",
    "WINZNLABSQL.ZNLAB.LOC",
    "10.160.68.182"
)

$InternalLinuxVMs = @(
    "10.160.70.140",
    "10.160.178.131"
)

# Servidor DNS interno
$InternalDnsServer = "10.160.55.217"

# Recurso SMB interno
$InternalSMBShare = "\\10.160.68.182\C$"

# NORTH-SOUTH URLs
$HttpUrls = @(
    "http://neverssl.com"
)

$HttpsUrls = @(
    "https://www.google.com",
    "https://www.microsoft.com"
)

# Iteraciones y pausa
$Iterations   = 5
$SleepSeconds = 15

# ==================================
# FUNCIONES
# ==================================

function Test-TcpPort {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Target,

        [Parameter(Mandatory=$true)]
        [int]$Port
    )

    if ([string]::IsNullOrWhiteSpace($Target)) {
        return
    }

    # Si es IP, no hacer DNS
    if ($Target -match '^\d{1,3}(\.\d{1,3}){3}$') {
        Test-NetConnection -RemoteAddress $Target -Port $Port -WarningAction SilentlyContinue | Out-Null
    }
    else {
        Test-NetConnection -ComputerName $Target -Port $Port -WarningAction SilentlyContinue | Out-Null
    }
}

function Resolve-InternalDns {
    param (
        [string]$Name
    )

    if ([string]::IsNullOrWhiteSpace($Name)) {
        return
    }

    # Solo resolver si NO es IP
    if ($Name -notmatch '^\d{1,3}(\.\d{1,3}){3}$') {
        Resolve-DnsName -Name $Name -Server $InternalDnsServer -ErrorAction SilentlyContinue | Out-Null
    }
}

# ==================================
# EJECUCIÓN
# ==================================

for ($i = 1; $i -le $Iterations; $i++) {

    Write-Host "Iteración $i / $Iterations" -ForegroundColor Cyan

    # ---------------------------
    # EAST-WEST
    # ---------------------------

    Write-Host "EAST-WEST: DNS interno" -ForegroundColor Yellow

    foreach ($WinVM in $InternalWindowsVMs) {
        Resolve-InternalDns -Name $WinVM
    }

    foreach ($LinuxVM in $InternalLinuxVMs) {
        Resolve-InternalDns -Name $LinuxVM
    }

    Write-Host "EAST-WEST: RPC / SMB / RDP (Windows)" -ForegroundColor Yellow

    foreach ($WinVM in $InternalWindowsVMs) {

        # RPC
        Test-TcpPort -Target $WinVM -Port 135

        # SMB
        Test-TcpPort -Target $WinVM -Port 445

        # RDP
        Test-TcpPort -Target $WinVM -Port 3389
    }

    Write-Host "EAST-WEST: Acceso SMB real" -ForegroundColor Yellow
    try {
        Get-ChildItem $InternalSMBShare -ErrorAction SilentlyContinue | Out-Null
    } catch {}

    Write-Host "EAST-WEST: Linux (DNS / SMB / HTTP)" -ForegroundColor Yellow

    foreach ($LinuxVM in $InternalLinuxVMs) {

        # DNS (si expuesto)
        Test-TcpPort -Target $LinuxVM -Port 53

        # SMB (si hay Samba)
        Test-TcpPort -Target $LinuxVM -Port 445

        # HTTP interno (si aplica)
        Test-TcpPort -Target $LinuxVM -Port 80
    }

    # ---------------------------
    # NORTH-SOUTH
    # ---------------------------

    Write-Host "NORTH-SOUTH: HTTP / HTTPS" -ForegroundColor Green

    foreach ($Url in $HttpUrls) {
        try {
            Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5 | Out-Null
        } catch {}
    }

    foreach ($Url in $HttpsUrls) {
        try {
            Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5 | Out-Null
        } catch {}
    }

    Start-Sleep -Seconds $SleepSeconds
}

Write-Host "Tráfico EAST-WEST y NORTH-SOUTH generado correctamente." -ForegroundColor Green
