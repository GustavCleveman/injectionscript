Start-Service WinRM
winrm qc /force
netsh advfirewall firewall add rule name= WinRMHTTPS dir=in action=allow protocol=TCP localport=5986
netsh advfirewall firewall add rule name= WinRMHTTPS dir=out action=allow protocol=TCP localport=5986
netsh advfirewall firewall add rule name= WinRMHTTPS dir=in action=allow protocol=TCP localport=5985
netsh advfirewall firewall add rule name= WinRMHTTPS dir=out action=allow protocol=TCP localport=5985

New-NetFirewallRule -DisplayName 'WinRm (HTTPS-In)' -Name 'WinRm (HTTPS-In)' -Profile any -LocalPort 5986 -Protocol TCP

winrm set winrm/config/client '@{AllowUnencrypted="true"}'

Enable-WSManCredSSP -Role server -Force
Enable-PSRemoting -SkipNetworkProfileCheck -Force

