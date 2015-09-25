Param(
    [Parameter(Mandatory=$True)]
    [string]$SAPWD
)

Copy-Item -Path "C:\System\Deployment\Packages\SQL2014\" -Destination "C:\" -Recurse

$SSPassword = ConvertTo-SecureString -String $SAPWD -AsPlainText -Force
$Arguments = "/Q /IACCEPTSQLSERVERLICENSETERMS /SAPWD=" + $SSPassword + " /CONFIGURATIONFILE=C:\SQL2014\ConfigurationFile.ini"
Start-Process -FilePath "C:\SQL2014\Setup.exe" -ArgumentList $Arguments -Wait

Remove-Item -Path "C:\SQL2014\" -Recurse

REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQLServer\SuperSocketNetLib\Tcp\IP2" /v Enabled /t REG_DWORD /d 00000001 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQLServer\SuperSocketNetLib\Tcp" /v Enabled /t REG_DWORD /d 1 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQLServer\SuperSocketNetLib\Tcp\IP2" /v TcpPort /t REG_SZ /d 1433 /f
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQLServer\SuperSocketNetLib\Tcp\IPAll" /v TcpPort /t REG_SZ /d 1433 /f

net stop "SQL Server (SQLEXPRESS)"
net start "SQL Server (SQLEXPRESS)"