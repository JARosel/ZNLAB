w32tm /config /manualpeerlist:time.windows.com /syncfromflags:MANUAL
w32tm /config /update
w32tm /query /source
w32tm /resync
Set-TimeZone "Romance Standard Time"

w32tm /config /manualpeerlist:WINZNLABDC.ZNLAB.LOC /syncfromflags:MANUAL
w32tm /config /update
w32tm /query /source
w32tm /resync
Set-TimeZone "Romance Standard Time"
