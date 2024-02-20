Параметр parents используется, для задания режима/области конфигурации, в котором будут выполнены команды. Например в области _line vty 0 4_, yaml должен выглядеть:
```
---
- name: Run cfg in routers
  hosts: cisco_devices

  tasks:
    - name: config line vty
      ios_config:
        partents: 
          - line vty 0 4
        lines:
          - login local
          - transport input ssh
...
```
Попробую задать e0/0, e0/1
```
ansible R1 -i myhosts.ini -c network_cli -m ios_command -a "commands='show run int e0/0'"
ansible R1 -i myhosts.ini -c network_cli -m ios_command -a "commands='show run int e0/1'"
ansible R1 -i myhosts.ini -c network_cli -m ios_command -a "commands='show cdp nei'"
```

```
---
- name: Configure R1-R7
  hosts: cisco_devices

  tasks:
    - name: Default interfaces
      ios_config:
        lines:
          - default interface ethernet 0/0
          - default interface ethernet 0/0

	- name: configure R1 e0/0
      ios_config:
        parents:
          - interface ethernet 0/0
        lines:
          - ip address 172.16.0.1 255.255.255.240
          - cdp enable
          - no shutdown

	- name: configure R1 e0/1
      ios_config:
        parents:
          - interface ethernet 0/1
        lines:
          - ip address 172.16.0.17 255.255.255.240
          - cdp enable
          - no shutdown
          - 
	- name: configure R1 e0/3
      ios_config:
        parents:
          - interface ethernet 0/3
        lines:
          - no cdp enable
...
```

Вызывать файлы разных плейбуков можно через ключевое слово _import_playbook_
```
---
- import_playbook: R1_ios_command_03_04_02.yaml
- import_playbook: R2_ios_command_03_04_02.yaml
- import_playbook: R3_ios_command_03_04_02.yaml
- import_playbook: R4_ios_command_03_04_02.yaml
- import_playbook: R5_ios_command_03_04_02.yaml
- import_playbook: R6_ios_command_03_04_02.yaml
- import_playbook: R7_ios_command_03_04_02.yaml
...
```

