#opens https port in and out
winrm qc /force
netsh advfirewall firewall add rule name= WinRMHTTPS dir=in action=allow protocol=TCP localport=5986
netsh advfirewall firewall add rule name= WinRMHTTPS dir=out action=allow protocol=TCP localport=5986
netsh advfirewall firewall add rule name= WinRMHTTPS dir=in action=allow protocol=TCP localport=5985
netsh advfirewall firewall add rule name= WinRMHTTPS dir=out action=allow protocol=TCP localport=5985

#opens https port again because whatever the hell these days
New-NetFirewallRule -DisplayName 'WinRm (HTTPS-In)' -Name 'WinRm (HTTPS-In)' -Profile any -LocalPort 5986 -Protocol TCP

winrm set winrm/config/client '@{AllowUnencrypted="true"}'


#Allows for Certificate authentication
#Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true <-- do remotely after copying of cert

#Enables powershell to be connected to remotely 
Enable-PSRemoting -SkipNetworkProfileCheck -Force

#Creates certificate
$Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "10.0.0.4" -Type SSLServerAuthentication, DocumentEncryptionCert
#$CertPath = "Cert:\LocalMachine\My\$Cert.Thumbprint"

$password = ConvertTo-SecureString "Password1234!" -AsPlainText -Force
$cred= New-Object System.Management.Automation.PSCredential ("GustavC", $password )


Export-PfxCertificate -Cert $Cert -FilePath c:\selfCert.pfx -Password $password

#Set winRm to listen to Https with the cert thumbprint
New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force

Enable-WSManCredSSP -Role server -Force


#New-Item -Path WSMan:\localhost\ClientCertificate -Credential $cred -Subject dmin -URI * -Issuer $Cert.thumbprint -Force <---!this one might help but locks u out
#TODO.  MOVE Above line to client scrip?


#Remove HTTP listener (optional)
#Winrm enumerate winrm/config/listener
#Get-ChildItem WSMan:\Localhost\listener | Where -Property Keys -eq 'Transport=HTTP' | Remove-Item -Recurse
#pretty self explanatory
Start-Service WinRM
#sdsd 