# How to setup the LAB

# Prepare both servers
- [ ] Rename computer name
- [ ] Join server to domain
- [ ] Fix time syncronization
- [ ] Configure keyboard layout

>[!IMPORTANT]
> Deploying the Web Application

## Deploy 2 servers: WINZNLABSQL and WINZNLABAPP

- Use template "Windows Server 2022 Standard"
- Change computer name (use CLAB script option 6)
- Add to domain (use CLAB script option 3)
  ZNLAB.LOC\Administrator
- Edit Domain
- Edit Use

>[!TIP]
>CLAB Script:
>```
>iex (iwr "https://raw.githubusercontent.com/NEXTGEN-CyberLAB/WIN-CyberLAB-Tools/main/CyberLAB-quickstart.ps1" -UseBasicParsing).Content
>```
## Fix time issues
If you want to set time.windows.com as reference
```
w32tm /config /manualpeerlist:time.windows.com /syncfromflags:MANUAL
w32tm /config /update
w32tm /query /source
w32tm /resync
Set-TimeZone "Romance Standard Time"
```

If you want to set time.windows.com as reference
```
w32tm /config /manualpeerlist:WINZNLABDC.ZNLAB.LOC /syncfromflags:MANUAL
w32tm /config /update
w32tm /query /source
w32tm /resync
Set-TimeZone "Romance Standard Time"
```

## Change keyboard layout
Check your actual keyboard layout
```
Get-WinUserLanguageList
```
Change your keyboard layout to Spanish
```
Set-WinUserLanguageList es-ES -Force
```

Now you are ready for the next step

## Configure WINZNLABSQL

Read [WINZNLABSQL](/WINZNLABSQL.md) file

## Configure WINZNLABAPP

Read [WINZNLABAPP](WINZNLABAPP.md) file

