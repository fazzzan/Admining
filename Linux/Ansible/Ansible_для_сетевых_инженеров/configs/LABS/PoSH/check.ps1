winrm enumerate winrm/config/listener
dir WSMan:\localhost\listener | fl
Winrm get http://schemas.microsoft.com/wbem/wsman/1/config

(get-ChildItem -Path cert:\LocalMachine\root | Where-Object { $_.Subject -like "CN=ansible" }).Thumbprint


Get-ChildItem -Path WSMan:\localhost\ClientCertificate | fl
