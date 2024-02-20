Тэги: #ansible #Idempotence #uptime
Ссылки: 

## Лабораторка
![[Pasted image 20240208154654.png]]
Для начала, найдем подходящий модуль при помощи 
```
ansible-doc -l | grep .wind | grep fact

community.windows.win_disk_facts                                                                 Show the attached disks and disk informat...
community.windows.win_listen_ports_facts                                                         Recopilates the facts of the listenin...
community.windows.win_product_facts                                                              Provides Windows product a...
```

1. Сбор информации о хосте
> [!question]- ```ansible windows -m setup``` >
>  ```
>administrator@admin-UB01:/etc/ansible/windows$ ansible windows -m setup
>[WARNING]: Failed to collect distribution due to timeout
>[WARNING]: Failed to collect platform due to timeout
>[WARNING]: Failed to collect winrm due to timeout
>server2019 | SUCCESS => {
>    "ansible_facts": {
>        "ansible_bios_date": "08/09/2021",
>        "ansible_bios_version": "VMW71.00V.18452719.B64.2108091906",
>        "ansible_date_time": {
>            "date": "2024-02-08",
>            "day": "08",
>            "epoch": "1707396001.2067",
>            "epoch_int": 1707396001,
>            "epoch_local": "1707406801.2067",
>            "hour": "15",
>            "iso8601": "2024-02-08T12:40:01Z",
>            "iso8601_basic": "20240208T154001206702",
>            "iso8601_basic_short": "20240208T154001",
>            "iso8601_micro": "2024-02-08T12:40:01.206702Z",
>            "minute": "40",
>            "month": "02",
>            "second": "01",
>            "time": "15:40:01",
>            "tz": "Arab Standard Time",
>            "tz_offset": "+03:00",
>            "weekday": "Thursday",
>            "weekday_number": "4",
>            "weeknumber": "5",
>            "year": "2024"
>        },
>        "ansible_distribution": null,
>        "ansible_distribution_major_version": "10",
>        "ansible_distribution_version": "10.0.17763.0",
>        "ansible_env": {
>            "ALLUSERSPROFILE": "C:\\ProgramData",
>            "APPDATA": "C:\\Users\\ansible\\AppData\\Roaming",
>            "COMPUTERNAME": "SERVER2019",
>            "ComSpec": "C:\\Windows\\system32\\cmd.exe",
>            "CommonProgramFiles": "C:\\Program Files\\Common Files",
>            "CommonProgramFiles(x86)": "C:\\Program Files (x86)\\Common Files",
>            "CommonProgramW6432": "C:\\Program Files\\Common Files",
>            "DriverData": "C:\\Windows\\System32\\Drivers\\DriverData",
>            "LOCALAPPDATA": "C:\\Users\\ansible\\AppData\\Local",
>            "NUMBER_OF_PROCESSORS": "2",
>            "OS": "Windows_NT",
>            "PATHEXT": ".COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC;.CPL",
>            "PROCESSOR_ARCHITECTURE": "AMD64",
>            "PROCESSOR_IDENTIFIER": "Intel64 Family 6 Model 158 Stepping 10, GenuineIntel",
>            "PROCESSOR_LEVEL": "6",
>            "PROCESSOR_REVISION": "9e0a",
>            "PROMPT": "$P$G",
>            "PSExecutionPolicyPreference": "Unrestricted",
>            "PSModulePath": "C:\\Users\\ansible\\Documents\\WindowsPowerShell\\Modules;C:\\Program Files\\WindowsPowerShell\\Modules;C:\\Windows\\system32\\WindowsPowerShell\\v1.0\\Modules",
>            "PUBLIC": "C:\\Users\\Public",
>            "Path": "C:\\Windows\\system32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\Windows\\System32\\OpenSSH\\;C:\\Users\\ansible\\AppData\\Local\\Microsoft\\WindowsApps",
>            "ProgramData": "C:\\ProgramData",
>            "ProgramFiles": "C:\\Program Files",
>            "ProgramFiles(x86)": "C:\\Program Files (x86)",
>            "ProgramW6432": "C:\\Program Files",
>            "SystemDrive": "C:",
>            "SystemRoot": "C:\\Windows",
>            "TEMP": "C:\\Users\\ansible\\AppData\\Local\\Temp",
>            "TMP": "C:\\Users\\ansible\\AppData\\Local\\Temp",
>            "USERDOMAIN": "SERVER2019",
>            "USERNAME": "ansible",
>            "USERPROFILE": "C:\\Users\\ansible",
>            "windir": "C:\\Windows"
>        },
>        "ansible_interfaces": [
>            {
>                "connection_name": "Ethernet0",
>                "default_gateway": "192.168.1.1",
>                "dns_domain": null,
>                "interface_index": 12,
>                "interface_name": "Intel(R) 82574L Gigabit Network Connection",
>                "ipv4": {
>                    "address": "192.168.1.25",
>                    "prefix": "24"
>                },
>                "ipv6": {
>                    "address": "fe80::924b:b8c0:f411:ba66%12",
>                    "prefix": "64"
>                },
>                "macaddress": "00:0C:29:ED:D0:01",
>                "mtu": 1500,
>                "speed": 1000
>            }
>        ],
>        "ansible_ip_addresses": [
>            "fe80::924b:b8c0:f411:ba66%12",
>            "192.168.1.25"
>        ],
>        "ansible_lastboot": "2024-02-08 14:13:27Z",
>        "ansible_memfree_mb": 1097,
>        "ansible_memtotal_mb": 2048,
>        "ansible_os_family": "Windows",
>        "ansible_os_installation_type": "Server",
>        "ansible_os_name": null,
>        "ansible_os_product_type": "server",
>        "ansible_pagefilefree_mb": 233,
>        "ansible_pagefiletotal_mb": 384,
>        "ansible_powershell_version": 5,
>        "ansible_processor": [
>            "0",
>            "GenuineIntel",
>            "Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz",
>            "1",
>            "GenuineIntel",
>            "Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz"
>        ],
>        "ansible_processor_cores": 1,
>        "ansible_processor_count": 2,
>        "ansible_processor_threads_per_core": 1,
>        "ansible_processor_vcpus": 2,
>        "ansible_product_name": "VMware7,1",
>        "ansible_product_serial": "VMware-56 4d e6 75 bd 60 e4 fd-36 ce 70 c2 51 ed d0 01",
>        "ansible_swaptotal_mb": 0,
>        "ansible_uptime_seconds": 5237,
>        "ansible_user_dir": "C:\\Users\\ansible",
>        "ansible_user_gecos": "",
>        "ansible_user_id": "ansible",
>        "ansible_user_sid": "S-1-5-21-3961262962-3216262785-2315873534-1001",
>        "ansible_virtualization_role": "guest",
>        "ansible_virtualization_type": "VMware",
>        "ansible_windows_domain": "WORKGROUP",
>        "ansible_windows_domain_member": false,
>        "ansible_windows_domain_role": "Stand-alone server",
>        "gather_subset": [
>            "all"
>        ],
>        "module_setup": true
>    },
>    "changed": false
>}
>```
>

> [!question]- ```ansible all -m win_product_facts``` >
>  ```
>server2019 | SUCCESS => {
>    "ansible_facts": {
>        "ansible_os_license_channel": "Retail",
>        "ansible_os_license_edition": "Windows(R), ServerDatacenter edition",
>        "ansible_os_license_status": "Notification",
>        "ansible_os_product_id": "00430-70000-00001-AA878",
>        "ansible_os_product_key": "NPTRB-CFYFD-DGFPG-DY9GJ-CPR8F"
>    },
>    "changed": false
>}
>

2. Создание пользователя
> [!question]- ```ansible all -m win_user -a "name=anna state=present"``` >
>  ```
>server2019 | CHANGED => {
>    "account_disabled": false,
>    "account_locked": false,
>    "changed": true,
>    "description": "",
>    "fullname": "anna",
>    "groups": [],
>    "name": "anna",
>    "password_expired": true,
>    "password_never_expires": false,
>    "path": "WinNT://WORKGROUP/SERVER2019/anna",
>    "sid": "S-1-5-21-3961262962-3216262785-2315873534-1002",
>    "state": "present",
>    "user_cannot_change_password": false
>}
>