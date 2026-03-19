## Setup the database on WINZNLABSQL

## Install XAMPP (Apache+PHP)

https://www.apachefriends.org/index.html

https://sourceforge.net/projects/xampp/files/XAMPP%20Windows/8.2.12/xampp-windows-x64-8.2.12-0-VS16-installer.exe/download

Other apps that can be installed:

- [ ] MySQL
- [ ] FileZilla FTP
- [ ] Mercury Mail Server
- [ ] Tomcat
- [ ] Perl

## Install Wordpress on WINZNLABAPP

### Rename htdocs folder
If necessary, stop Apache from XAMPP Control Panel

### Download Wordpress

https://wordpress.org/latest.zip

```
New-Item -Path C:\temp -ItemType Directory -Force
Invoke-WebRequest -Uri https://wordpress.org/latest.zip -OutFile C:\temp\latest.zip -UseBasicParsing
Rename-Item -Path C:\xampp\htdocs -NewName htdocs.DIST
Expand-Archive -LiteralPath C:\temp\latest.zip -DestinationPath C:\xampp\htdocs
```

### Download and copy wp-config.php
```
Invoke-WebRequest -Uri https://raw.githubusercontent.com/znhomelab/znlab/refs/heads/main/wp-config.php -OutFile C:\xampp\htdocs\wp-config.php -UseBasicParsing
```
### Start Apache from XAMPP Control Panel

### Access and configure Wordpress
```
http://WINZNLABAPP
```
Configure the new Wordpress App

User: admin
Password: mujkomplic84$

## Test sql connection from WINZNLABAPP to WINZNLABSQL

### Chocolatey Install (if not already installed)
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
### MySQL-cli Install (if not already installed)
```
choco install mysql-cli -Y
```
### Test connection using the wbdpuser's password
```
mysql wordpress -h WINZNLABSQL -u wpdbuser -p
```
