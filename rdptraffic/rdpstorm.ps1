# Deploy this script on servers
# --- Config ---
$Domain   = 'ZNLAB.LOC'
$Users    = @('aaron.douglas','adrian.william','alexandra.samantha')  # varios usuarios
$PlainPassword = 'NuevaP@ssw0rd'                 # misma contraseña para todos
$Servers  = @('WINZNLABSQL','WINZNLABAPP','WINZNLABDC') | Select-Object -Unique
$HoldSeconds = 20; $MinSleep = 3; $MaxSleep = 10; $Concurrent = 1
$Log = 'C:\Scripts\log-rdp-storm.log'
# -------------

# Prep
$LogDir = Split-Path $Log; if (-not (Test-Path $LogDir)) { New-Item -Type Directory -Force -Path $LogDir | Out-Null }
$Me = $env:COMPUTERNAME
$Peers = $Servers | Where-Object { $_.ToUpper() -ne $Me.ToUpper() }
if (-not $Peers) { throw "Peers vacío." }

$mstsc = (Get-Command mstsc.exe -ErrorAction SilentlyContinue).Source
if (-not $mstsc) { throw "mstsc.exe no disponible." }

function Set-RdpCred {
  param([string]$Target,[string]$Domain,[string]$User,[string]$PassPlain)
  cmdkey /delete:("TERMSRV/$Target") | Out-Null 2>$null
  cmdkey /generic:("TERMSRV/$Target") /user:("$Domain\$User") /pass:$PassPlain | Out-Null
}

Register-EngineEvent PowerShell.Exiting -Action {
  foreach ($t in $using:Peers) { cmdkey /delete:("TERMSRV/$t") | Out-Null 2>$null }
} | Out-Null

function Test-RdpPort {
  param([string]$Target,[int]$Port=3389)
  try { (Test-NetConnection -ComputerName $Target -Port $Port -WarningAction SilentlyContinue).TcpTestSucceeded }
  catch {
    try { $c = New-Object System.Net.Sockets.TcpClient; $ok=$c.BeginConnect($Target,$Port,$null,$null).AsyncWaitHandle.WaitOne(2000); $c.Close(); $ok }
    catch { $false }
  }
}

function Invoke-RdpOnce {
  param([string]$Target)

  $ts = Get-Date
  if (-not (Test-RdpPort -Target $Target)) { "$ts`t$Target`tPORT_CLOSED" | Add-Content $Log; return }

  # elegir usuario y preparar credencial para ESTE intento
  $user = Get-Random -InputObject $Users
  Set-RdpCred -Target $Target -Domain $Domain -User $user -PassPlain $PlainPassword
  "$ts`t$Target`tCREDS:$Domain\$user" | Add-Content $Log

  $p = Start-Process -FilePath $mstsc -ArgumentList "/v:$Target" -PassThru -WindowStyle Minimized
  "$ts`t$Target`tOPEN" | Add-Content $Log
  Start-Sleep -Seconds $HoldSeconds
  try { if ($p -and -not $p.HasExited) { Stop-Process -Id $p.Id -Force } } catch {}
  "$(Get-Date)`t$Target`tCLOSE" | Add-Content $Log
}

while ($true) {
  $count = [Math]::Min([Math]::Max($Concurrent,1), $Peers.Count)
  $targets = if ($count -eq 1) { ,(Get-Random -InputObject $Peers) } else { Get-Random -InputObject $Peers -Count $count }
  foreach ($t in $targets) { Invoke-RdpOnce -Target $t }
  Start-Sleep -Seconds (Get-Random -Minimum $MinSleep -Maximum $MaxSleep)
}

