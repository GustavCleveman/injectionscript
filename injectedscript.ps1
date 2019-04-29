
#opens https port in and out
winrm qc /force
netsh advfirewall firewall add rule name= WinRMHTTPS dir=in action=allow protocol=TCP localport=5986
netsh advfirewall firewall add rule name= WinRMHTTPS dir=out action=allow protocol=TCP localport=5986

#opens https port again because whatever the hell these days
New-NetFirewallRule -DisplayName 'WinRm (HTTPS-In)' -Name 'WinRm (HTTPS-In)' -Profile any -LocalPort 5986 -Protocol TCP

#Allows for Certificate authentication
#Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true <-- do remotely after copying of cert

#Enables powershell to be connected to remotely 
Enable-PSRemoting -SkipNetworkProfileCheck -Force

#Creates certificate
$Cert = New-SelfSignedCertificate -Cer--tstoreLocation Cert:\LocalMachine\My -DnsName "10.0.0.4"
#$CertPath = "Cert:\LocalMachine\My\$Cert.Thumbprint"

$Pswrd = ConvertTo-SecureString -String "1Treetop2!" -Force -AsPlainText

Export-PfxCertificate -Cert $Cert -FilePath c:\selfCert.pfx -Password $Pswrd



#Set winRm to listen to Https with the cert thumbprint
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force

# Remove HTTP listener (optional)
#Winrm enumerate winrm/config/listener
#Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq 'Transport=HTTP' | Remove-Item -Recurse

#pretty self explanatory
Start-Service WinRM
