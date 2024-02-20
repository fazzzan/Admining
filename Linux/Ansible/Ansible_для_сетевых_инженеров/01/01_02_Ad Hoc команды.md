Это команда разового действия для какого-либо хоста, как правило либо для проверки конфига или модуля. 
Общий формат команды:
```
ansible 192.168.100.1 -i myhosts.ini -c network_cli -e ansible_network_os=ios -u cisco -k -m ios_command -a "commands='sh clock'"
```
- 192.168.100.1 - хост из inventory
- -i myhosts.ini - inventory
- -c network_cli -e ansible_network_os=ios - конструкция, объясняющая Ansible типу подключения (network_cli) с обязательным указанием типа ОС (ios)
- -u cisco - пользователь
- -k - аутентификация по паролю, а не по ключам
- -m ios_command - используемый модуль (для Cisco)
- -a "commands='sh ip int br'" - отправляемая в данном режиме
```
root@admin-UB01:/etc/ansible# ansible R7 -i myhosts.ini -c network_cli -e ansible_network_os=ios -u admin -k -m ios_command -a "commands='sh clock'"
SSH password: 
R7 | SUCCESS => {
    "changed": false,
    "stdout": [
        "*14:39:24.630 MSK Thu Mar 29 2018"
    ],
    "stdout_lines": [
        [
            "*14:39:24.630 MSK Thu Mar 29 2018"
        ]
    ]
}
```
Принято часть параметров хранить либо в инвентарном файле, например [myhosts.ini](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_02\myhosts.ini), либо в файлах для конкретных групп/устройств, и тогда команду можно писать  сокращенно:
```
root@admin-UB01:/etc/ansible# ansible R7 -m ios_command -a "commands='sh ip int br'"
SSH password: 
R7 | SUCCESS => {
    "changed": false,
    "stdout": [
        "Interface                  IP-Address      OK? Method Status                Protocol\nEthernet0/0                unassigned      YES NVRAM  administratively down down    \nEthernet0/1                unassigned      YES NVRAM  administratively down down    \nEthernet0/2                unassigned      YES NVRAM  administratively down down    \nEthernet0/3                192.168.10.17   YES NVRAM  up                    up      \nLoopback0                  11.11.11.17     YES NVRAM  up                    up"
    ],
    "stdout_lines": [
        [
            "Interface                  IP-Address      OK? Method Status                Protocol",
            "Ethernet0/0                unassigned      YES NVRAM  administratively down down    ",
            "Ethernet0/1                unassigned      YES NVRAM  administratively down down    ",
            "Ethernet0/2                unassigned      YES NVRAM  administratively down down    ",
            "Ethernet0/3                192.168.10.17   YES NVRAM  up                    up      ",
            "Loopback0                  11.11.11.17     YES NVRAM  up                    up"
        ]
    ]
}
```