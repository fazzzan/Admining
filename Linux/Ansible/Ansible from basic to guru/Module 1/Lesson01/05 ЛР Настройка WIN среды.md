Тэги: #ansible #assets #modules #Inventory #ad-hoc #AWT #ssh-copy-id
Ссылки: 
## Лабораторная работа
### ТЗ
![[Pasted image 20240113192100.png]]
Я планирую использовать
- RedOS
- Ubuntu LTS
- Windows Server 2019
- ESXi 6.5
- Cisco

![[Pasted image 20240113232058.png]]
### Установка и проверка работы SSH:
```
RedOS
dnf install sshd
sudo systemctl status sshd

Ubuntu
sudo apt update && sudo apt upgrade
 sudo apt install openssh-server
 sudo systemctl enable --now ssh
 sudo systemctl status ssh
```

### Создаем inventory
```
redos

[ubuntu]
ansible1
ansible2
```

### Настройка WIN хоста
Возможно, начиная с 7 и срв 2008. Для работы с Вин, необходимы отдельные модули. Также добавляем в файл hosts.
Подготовка хоста начинается:
- логинимся под админом 
- PoSH runAS administrator
- ```winrm quickconfig```
![[Pasted image 20240121144558.png]]
![[Pasted image 20240121144733.png]]

![[Pasted image 20240121144830.png]]
- Обновляем PoSH и WinRM (раздел Upgrading PowerShell and .NET Framework)
```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/jborean93/ansible-windows/master/scripts/Upgrade-PowerShell.ps1"
$file = "$env:temp\Upgrade-PowerShell.ps1"
$username = "ansible"
$password = "P@55w0rd"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force

&$file -Version 5.1 -Username $username -Password $password -Verbose

затем 

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

затем 

$reg_winlogon_path = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
Set-ItemProperty -Path $reg_winlogon_path -Name AutoAdminLogon -Value 0
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultUserName -ErrorAction SilentlyContinue
Remove-ItemProperty -Path $reg_winlogon_path -Name DefaultPassword -ErrorAction SilentlyContinue

```
- проверяем документацию (https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html, https://docs.ansible.com/ansible/latest/os_guide/windows_winrm.html#certificate)
Дальнейшие действия [по статье ](https://adamtheautomator.com/winrm-for-ansible/),  очень много времени было потрачено чтобы выяснить где хранятся сертификаты пользователя и как правильно их установить на Win ПК

> [!question]- ```скрипт который у меня сработал на server2019```>
```
#region Ensure the WinRm service is running
Set-Service -Name "WinRM" -StartupType Automatic
Start-Service -Name "WinRM"
#endregion

#region Enable PS remoting
if (-not (Get-PSSessionConfiguration) -or (-not (Get-ChildItem WSMan:\localhost\Listener))) {
    Enable-PSRemoting -SkipNetworkProfileCheck -Force
}
#endregion

#region Enable cert-based auth
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
#endregion

$output_path = 'C:\Temp\'

$testUserAccountName = 'ansible'
$testUserAccountPassword = (ConvertTo-SecureString -String 'P@55w0rd' -AsPlainText -Force)
if (-not (Get-LocalUser -Name $testUserAccountName -ErrorAction Ignore)) {
    $newUserParams = @{
        Name                 = $testUserAccountName
        AccountNeverExpires  = $true
        PasswordNeverExpires = $true
        Password             = $testUserAccountPassword
    }
    $null = New-LocalUser @newUserParams
}

## This is the public key generated from the Ansible server using:
<# 
cat > openssl.conf << EOL
distinguished_name = req_distinguished_name
[req_distinguished_name]
[v3_req_client]
extendedKeyUsage = clientAuth
subjectAltName = otherName:1.3.6.1.4.1.311.20.2.3;UTF8:$USERNAME@localhost
EOL
export OPENSSL_CONF=openssl.conf
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out cert.pem -outform PEM -keyout cert_key.pem -subj "/CN=$USERNAME" -extensions v3_req_client
rm openssl.conf 
#>

$ansibleCert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2
$pubKeyFilePath = "$output_path\cert.pem" 
$ansibleCert.Import($pubKeyFilePath)

## Import the public key into Trusted Root Certification Authorities and Trusted People
$store_name = [System.Security.Cryptography.X509Certificates.StoreName]::Root
$store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
$store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
$store.Open("MaxAllowed")
$store.Add($ansibleCert)
$store.Close()

$ansibleCert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2
$pubKeyFilePath = "$output_path\cert.pem" 
$ansibleCert.Import($pubKeyFilePath)

## Import the public key into Trusted Root Certification Authorities and Trusted People
$store_name = [System.Security.Cryptography.X509Certificates.StoreName]::TrustedPeople
$store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
$store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
$store.Open("MaxAllowed")
$store.Add($ansibleCert)
$store.Close()

##$null = Import-Certificate -FilePath $pubKeyFilePath -CertStoreLocation 'Cert:\LocalMachine\Root'
##$null = Import-Certificate -FilePath $pubKeyFilePath -CertStoreLocation 'Cert:\LocalMachine\TrustedPeople'

$ansibleCert = Get-ChildItem -Path 'Cert:\LocalMachine\Root' | ? {$_.Subject -eq 'CN=ansible'}

#endregion

#region Create the "server" cert for the Windows server and listener
# $hostName = "$env:COMPUTERNAME.$env:USERDNSDOMAIN"
$hostname = hostname
$serverCert = New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation 'Cert:\LocalMachine\My'

#region Create an SSL listener with the server cert
$httpsListeners = Get-ChildItem -Path WSMan:\localhost\Listener\ | where-object { $_.Keys -match 'Transport=HTTPS' }

if ((-not $httpsListeners) -or -not (@($httpsListeners).where( { $_.CertificateThumbprint -ne $serverCert.Thumbprint }))) {
    $newWsmanParams = @{
        ResourceUri = 'winrm/config/Listener'
        SelectorSet = @{ Transport = "HTTPS"; Address = "*" }
        ValueSet    = @{ Hostname = $hostName; CertificateThumbprint = $serverCert.Thumbprint }
        # UseSSL = $true
    }
    $null = New-WSManInstance @newWsmanParams
}
#endregion

#region Map the client cert
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $testUserAccountName, $testUserAccountPassword
$ansibleCert = Get-ChildItem -Path 'Cert:\LocalMachine\Root' | ? {$_.Subject -eq 'CN=$testUserAccountName'}
$thumbprint = (Get-ChildItem -Path cert:\LocalMachine\root | Where-Object { $_.Subject -eq "CN=$testUserAccountName" }).Thumbprint

New-Item -Path WSMan:\localhost\ClientCertificate `
    -Subject "$testUserAccountName" `
    -URI * `
    -Issuer $thumbprint `
    -Credential $credential `
    -Force

#endregion

Get-ChildItem -Path WSMan:\localhost\ClientCertificate | fl
Get-ChildItem -Path WSMan:\localhost\Client

#region Ensure LocalAccountTokenFilterPolicy is set to 1
$newItemParams = @{
    Path         = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
    Name         = 'LocalAccountTokenFilterPolicy'
    Value        = 1
    PropertyType = 'DWORD'
    Force        = $true
}
$null = New-ItemProperty @newItemParams
#endregion

 #region Ensure WinRM 5986 is open on the firewall
 $ruleDisplayName = 'Windows Remote Management (HTTPS-In)'
 if (-not (Get-NetFirewallRule -DisplayName $ruleDisplayName -ErrorAction Ignore)) {
     $newRuleParams = @{
         DisplayName   = $ruleDisplayName
         Direction     = 'Inbound'
         LocalPort     = 5986
         RemoteAddress = 'Any'
         Protocol      = 'TCP'
         Action        = 'Allow'
         Enabled       = 'True'
         Group         = 'Windows Remote Management'
     }
     $null = New-NetFirewallRule @newRuleParams
 }
 #endregion

## Add the local user to the administrators group. If this step isn't doing, Ansible sees an "AccessDenied" error
Get-LocalUser -Name $testUserAccountName | Add-LocalGroupMember -Group 'Administrators'

Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true
```

Разбор скрипта:
> [!question]- ```1. Задаем автозапуск службе WinRm.```>
>```
Set-Service -Name "WinRM" -StartupType Automatic
Start-Service -Name "WinRM"
>```

> [!question]- ```2. Удаляем старую конфигурирацию удаленного подключения к PowerShell и создаем новое:```>
>>powershell
>```
>winrm enumerate winrm/config/listener
>
winrm delete winrm/config/Listener?Address=*+Transport=HTTP
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS
>
Get-ChildItem -Path WSMan:\localhost\ClientCertificate | fl
># To remove all WinRM listeners:
Remove-Item -Recurse -Path WSMan:\localhost\ClientCertificate\*
>
>if (-not (Get-PSSessionConfiguration) -or (-not (Get-ChildItem WSMan:\localhost\Listener))) {
 >  ## Use SkipNetworkProfileCheck to make available even on Windows Firewall public profiles
 >  ## Use Force to not be prompted if we're sure or not.
 >   Enable-PSRemoting -SkipNetworkProfileCheck -Force
>}

> [!question]- ```3. Включаем аутентификацию на основе сертификатов.```>
>powershell
>```
>#region Enable cert-based auth 
>Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
>#endregion
>```

> [!question]- ```4. Создаем локальную УЗ пользователя.```>
>powershell
>```
> $testUserAccountName = 'ansible'
> $testUserAccountPassword = (ConvertTo-SecureString -String 'P@55w0rd' -AsPlainText -Force)
> if (-not (Get-LocalUser -Name $testUserAccountName -ErrorAction Ignore)) {
>     $newUserParams = @{
>         Name                 = $testUserAccountName
>         AccountNeverExpires  = $true
>         PasswordNeverExpires = $true
>         Password             = $testUserAccountPassword
>     }
>     $null = New-LocalUser @newUserParams
> }
>```

> [!question]- ```5. Настройка сертификата управляющей машины Ansible, с которого будет выполняться подключение.```>
> WinRm для Ansible (безопасно) должен иметь два сертификата:
> - сертификат клиента (создание выполняется на Ansible управляющей машине): `openssl`команда создает закрытый ключ в файле _cert_key.pem_ и открытый ключ _cert.pem._ Ключом будет использоваться аутентификация клиента (1.3.6.1.4.1.311.20.2.3), «сопоставленная» с локальной УЗ пользователя на целевом сервере  _ansible_ .
> ```
> cat > openssl.conf << EOL 
distinguished_name = req_distinguished_name
[req_distinguished_name]
countryName            = RU
organizationName       = test.local
organizationalUnitName = IT
[v3_req_client]
extendedKeyUsage = clientAuth
subjectAltName = otherName:1.3.6.1.4.1.311.20.2.3;UTF8:ansible@localhost
> EOL 
> export OPENSSL_CONF=openssl.conf 
> openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out cert.pem -outform PEM -keyout cert_key.pem -subj "/CN=ansible" -extensions v3_req_client 
> rm openssl.conf
>```
> - созданный сертификат пользователя Ansible (выполняется на целевом сервере Win) - необходимо импортировать в два хранилища сертификатов на хосте Windows, чтобы WinRm в Ansible работал. Для этого:
>      - перенесите открытый ключ _cert.pem_ на хост Windows. 
>      - импортируйте его в хранилища сертификатов _доверенных корневых центров сертификации_ и _доверенных лиц_`Import-Certificate` , как показано далее.
>powershell
>```
>
$ansibleCert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2
$pubKeyFilePath = "$output_path\cert.pem" 
$ansibleCert.Import($pubKeyFilePath)
>
>## Import the public key into Trusted Root Certification Authorities and Trusted People
$store_name = [System.Security.Cryptography.X509Certificates.StoreName]::Root
$store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
$store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
$store.Open("MaxAllowed")
$store.Add($ansibleCert)
$store.Close()
>
$ansibleCert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2
$pubKeyFilePath = "$output_path\cert.pem" 
$ansibleCert.Import($pubKeyFilePath)
>
>## Import the public key into Trusted Root Certification Authorities and Trusted People
$store_name = [System.Security.Cryptography.X509Certificates.StoreName]::TrustedPeople
$store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
$store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
$store.Open("MaxAllowed")
$store.Add($ansibleCert)
$store.Close()
>```.

> [!question]- ```6. Создаем самоподписной сертификат сервера.```>
>WinRM для Ansible требуется сертификат, определенный с использованием ключа для аутентификации сервера. Этот сертификат будет храниться в хранилище сертификатов _LocalMachine\My_ узла Windows . При этом сам сертификат не будет трастед. Импортируем его в трастед руты. Создание самоподписного сертификата, ниже:
>powershell
>```
$hostname = 'server2019'
$serverCert = New-SelfSignedCertificate -DnsName $hostName -CertStoreLocation 'Cert:\LocalMachine\My'
>```

> [!question]- ```7. Конфигурим прослушиватели Ansible WinRm```>
> Прослушиватели _прослушивают_ порт 5986 на предмет входящих соединений. (Ранее мы удалили уже сконфигурированные прослушиватели, так как очень много возни с выяснением что перестало работать). Прослушиватель принимает входящие соединения и пытается зашифровать данные с помощью сертификата сервера, созданного п.п.6.
>powershell
>```
>#Find all HTTPS listners
>$httpsListeners = Get-ChildItem -Path WSMan:\localhost\Listener\ | where-object { $_.Keys -match 'Transport=HTTPS' }
>if ((-not $httpsListeners) -or -not (@($httpsListeners).where( { $_.CertificateThumbprint -ne $serverCert.Thumbprint }))) {
 >   $newWsmanParams = @{
  >      ResourceUri = 'winrm/config/Listener'
   >     SelectorSet = @{ Transport = "HTTPS"; Address = "*" }
   >     ValueSet    = @{ Hostname = $hostName; CertificateThumbprint = $serverCert.Thumbprint }
   >     # UseSSL = $true
   > }
   > $null = New-WSManInstance @newWsmanParams
>}
>```

> [!question]- ```8. Проверяем работу прослушивателей.```>
>powershell
>```
>winrm enumerate winrm/config/Listener
>```

> [!question]- ```9. «Сопоставляем» сертификат клиента с учетной записью локального пользователя.```>
> Это надо чтобы убедиться, что Ansible подключается к хосту Windows с использованием сертификата сервера, и будет выполнять все инструкции как локальный пользователь. В этом случае все действия, выполняемые WinRm для Ansible, будут использовать локальную учетную запись пользователя _ansible_
>powershell
>```
>$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $testUserAccountName, $testUserAccountPassword
$ansibleCert = Get-ChildItem -Path 'Cert:\LocalMachine\Root' | ? {$_.Subject -eq 'CN=$testUserAccountName'}
$thumbprint = (Get-ChildItem -Path cert:\LocalMachine\root | Where-Object { $_.Subject -eq "CN=$testUserAccountName" }).Thumbprint
>
>New-Item -Path WSMan:\localhost\ClientCertificate `
>    -Subject "$testUserAccountName" `
>    -URI * `
>    -Issuer $thumbprint `
>    -Credential $credential `
>    -Force
>
>```
>Get-ChildItem -Path WSMan:\localhost\ClientCertificate | fl
>Get-ChildItem -Path WSMan:\localhost\Client

> [!question]- ```10. Разрешить WinRm для Ansible с контролем учетных записей пользователей (UAC).```>
>powershell
>```
> $newItemParams = @{
>    Path         = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
>    Name         = 'LocalAccountTokenFilterPolicy'
>    Value        = 1
>    PropertyType = 'DWORD'
>    Force        = $true
>}
>$null = New-ItemProperty @newItemParams
>```

> [!question]- ```11. Порт 5986 в брандмауэре Windows```>
>powershell
>```
> #region Ensure WinRM 5986 is open on the firewall 
>$ruleDisplayName = 'Windows Remote Management (HTTPS-In)' 
> if (-not (Get-NetFirewallRule -DisplayName $ruleDisplayName -ErrorAction Ignore)) { 
> 	$newRuleParams = @{ 
> 		DisplayName = $ruleDisplayName 
> 		Direction = 'Inbound' 
> 		LocalPort = 5986 
> 		RemoteAddress = 'Any' 
> 		Protocol = 'TCP' 
> 		Action = 'Allow' 
> 		Enabled = 'True' 
> 		Group = 'Windows Remote Management' 
> 	} 
> 	$null = New-NetFirewallRule @newRuleParams 
> } 
> #endregion
>```

> [!question]- ```12. Добавляем пользователя в администраторы```>
>powershell
>```
Get-LocalUser -Name $testUserAccountName | Add-LocalGroupMember -Group 'Administrators'
>

ANSIBLE для Win должна:
- иметь свой CFG и свою inventory. Тут очень важный момент - настройка ansible_winrm_transport, чтобы не передавать пароль в открытом виде
![[Pasted image 20240121211917.png]]
```
[ansible4]
server2019 

[windows:children]
ansible4

[windows:vars]
ansible_user=ansible
#ansible_password=P@55w0rd
#ansible_port=5986
ansible_connection=winrm
ansible_winrm_scheme=https
ansible_winrm_server_cert_validation=ignore
#ansible_winrm_transport=basic
ansible_winrm_cert_pem=/etc/ansible/windows/cert.pem
ansible_winrm_cert_key_pem=/etc/ansible/windows/cert_key.pem
ansible_winrm_transport=certificate
```
![[Pasted image 20240121212003.png]]
```
[defaults]
inventory = inventory_win
host_key_checking = False

[privilege_escalation]
```
- имя Win ВМ должно разворачиваться (/etc/hosts)
- должно быть установлено ```sudo pip3 install pywinrm```
- проверить доступность WIN ПК можно командой ```ansible -i inventory_win windows -m win_ping```
![[Pasted image 20240121212058.png]]
-
- сбор фактов о WIN ПК ```ansible -i inventory_win windows -m win_ping```
-u:ansible -p:P@55w0rd ipconfig
winrs -r:https://server2019.local:5986/wsman -u:ansible -p:P@55w0rd -ssl ipconfig

Test-WSMan -ComputerName server2019
- сбор фактов о WIN ПК ```ansible -i inventory_win windows -m win_ping```

