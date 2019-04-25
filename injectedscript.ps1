winrm qc /force
netsh advfirewall firewall add rule name= WinRMHTTP dir=in action=allow protocol=TCP localport=5985
netsh advfirewall firewall add rule name= WinRMHTTPS dir=in action=allow protocol=TCP localport=5986
Start-Service WinRM
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
Enable-PSRemoting -SkipNetworkProfileCheck -Force