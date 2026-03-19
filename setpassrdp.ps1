Set-ADAccountPassword -Identity Aaron.Douglas -Reset -NewPassword (ConvertTo-SecureString "supersecret1$" -AsPlainText -Force)
Set-ADAccountPassword -Identity Adam.Andrew -Reset -NewPassword (ConvertTo-SecureString "supersecret1$" -AsPlainText -Force)
Unlock-ADAccount -Identity Aaron.Douglas
Enable-ADAccount -Identity Adam.Andrew

## Check connectivity with servers:
Test-WSMan WINZNLABAPP
Test-WSMan WINZNLABSQL
Test-WSMan WINZNLABSRV
Test-WSMan WINZNLABSEG

## Script para activar RDP
$servers = "WINZNLABAPP","WINZNLABSQL","WINZNLABSRV","WINZNLABSEG"

Invoke-Command -ComputerName $servers -ScriptBlock {
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

    $domain = $env:USERDOMAIN
    $member = "$domain\Domain Users"

    $groupName = (Get-LocalGroup | Where-Object { $_.Name -match "Desktop|Escritorio" }).Name
    Add-LocalGroupMember -Group $groupName -Member $member -ErrorAction SilentlyContinue

    Write-Host "$env:COMPUTERNAME configurado correctamente"
}

###########################

# 2. Abrir reglas de firewall para Escritorio remoto
#    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
