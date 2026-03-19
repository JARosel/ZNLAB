## Prepare WINZNLABSQL
### Chocolatey Install:
```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```
### MySQL-cli Install
```
choco install mysql-cli -Y
```

### MySQL-server Install

Download installer:
https://dev.mysql.com/downloads/installer/
Run installer and select MySQL Server and MySQL Workbench

https://dev.mysql.com/get/mysql-installer-community-8.0.44.0.msi

```
$DownloadDir = "C:\temp\MySQL_Install"
$InstallerName = "mysql-installer-web-community.msi"
$DownloadUrl = "https://dev.mysql.com/get/mysql-installer-community-8.0.44.0.msi" 
$InstallerPath = Join-Path $DownloadDir $InstallerName
mkdir $DownloadDir -Force
Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath -UseBasicParsing
```
## Install and configure MySQL Server and MySQL Workbench
>[!IMPORTANT]
> Use a strong password

```
$DownloadDir = "C:\temp\MySQL_Install"
$InstallerPath = Join-Path $DownloadDir "mysql-installer-community-8.0.44.0.msi"
$ProductsToInstall = "MySQL Server 8.0;MySQL Workbench 8.0"
$RootPassword = "Str0nGp4zz$"
$InstallDir = "C:\Program Files\MySQL"

$Arguments = @(
    "/i",
    $InstallerPath,
    "/qn", 
    "INSTALLDIR=`"$InstallDir`"",
    "INSTALLPRODUCTS=`"$ProductsToInstall`"",
    "MYSQL_SERVER_ROOT_PASSWORD=`"$RootPassword`"",
    "MYSQL_SERVER_PORT=3306"

)
Start-Process -FilePath "msiexec.exe" -ArgumentList $Arguments -Wait
```

## Configure database user for the webapp (use the root password defined before)
```
mysql -h WINZNLABSQL -u root -p
```

## Configure database for the webapp
```
CREATE DATABASE wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'wpdbuser'@'%' IDENTIFIED BY 'JSup3R$pzrd!';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpdbuser'@'%';
FLUSH PRIVILEGES;
```
