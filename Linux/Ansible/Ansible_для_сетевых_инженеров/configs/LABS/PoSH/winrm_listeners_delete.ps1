winrm enumerate winrm/config/listener

winrm delete winrm/config/Listener?Address=*+Transport=HTTP
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS

Get-ChildItem -Path WSMan:\localhost\ClientCertificate | fl
# To remove all WinRM listeners:
Remove-Item -Recurse -Path WSMan:\localhost\ClientCertificate\*


# To remove only those listeners that run over HTTPS:

Get-ChildItem -Path WSMan:\localhost\Listener | Where-Object { $_.Keys -contains "Transport=HTTPS" } | Remove-Item -Recurse -Force