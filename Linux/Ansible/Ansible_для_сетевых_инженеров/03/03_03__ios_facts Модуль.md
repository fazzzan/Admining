собирает информацию с устройств под управлением IOS из команд:
- dir    
- show version    
- show memory statistics    
- show interfaces    
- show ipv6 interface    
- show lldp    
- show lldp neighbors detail    
- show running-config

Функционал логгирования поможет увидеть что именно было введено: http://xgu.ru/wiki/EEM

По-умолчанию модуль собирает всю информацию, кроме конфигурационного файла. Собираемую информацию определяет параметр **gather_subset**: 
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/20.jpg)
Поддерживаются такие варианты (указаны также команды, которые будут выполняться на устройстве):
- all    
- hardware    
    - dir        
    - show version        
    - show memory statistics        
- config    
    - show version        
    - show running-config        
- interfaces    
    - dir        
    - show version        
    - show interfaces        
    - show ip interface        
    - show ipv6 interface        
    - show lldp        
    - show lldp neighbors detail

```
  - ios_facts:
      gather_subset: all
  - ios_facts:
      gather_subset:
        - interfaces
```

# Вывод на экран
вывести на экран полученные факты:
```
---
- name: YAMLPB3
  hosts: cisco_routers367
   
  tasks:
    - name: PB3_GET ALL FACTS
      ios_facts:  
        gather_subset: all  
      register: VAR_shoall_subset
    - name: Print_all facts
      debug: var=VAR_shoall_subset                       
...
```
Вывод показываем все доступные *facts*
```
{
    "VAR_shoall_subset": {
        "ansible_facts": {
            "ansible_net_all_ipv4_addresses": [
                "192.168.10.13",
                "11.11.11.13"
            ],
            "ansible_net_all_ipv6_addresses": [],
            "ansible_net_api": "cliconf",
            "ansible_net_config": "Building configuration...\n\nCurrent configuration : 1347 bytes\n!\n! Last configuration change at 13:33:43 MSK Thu Mar 29 2018\n!\nversion 15.4\nservice timestamps debug datetime msec\nservice timestamps log datetime msec\nservice password-encryption\n!\nhostname R3\n!\nboot-start-marker\nboot host tftp R3-confg 192.168.10.131\nboot-end-marker\n!\n!\n!\nno aaa new-model\nno process cpu autoprofile hog\nclock timezone MSK 3 0\nmmi polling-interval 60\nno mmi auto-configure\nno mmi pvc\nmmi snmp-timeout 180\n!\n!\n!\n!\n!\n!\n!\n!\n\n\n!\n!\n!\n!\nip domain name test.local\nip cef\nno ipv6 cef\n!\nmultilink bundle-name authenticated\n!\n!\n!\n!\n!\n!\n!\n!\nusername admin privilege 15 password 7 08116C5D1A0E550516\n!\nredundancy\n!\nno cdp run\n!\nip ssh version 2\n! \n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\ninterface Loopback0\n ip address 11.11.11.13 255.255.255.255\n!\ninterface Ethernet0/0\n no ip address\n shutdown\n no cdp enable\n!\ninterface Ethernet0/1\n no ip address\n shutdown\n no cdp enable\n!\ninterface Ethernet0/2\n no ip address\n shutdown\n no cdp enable\n!\ninterface Ethernet0/3\n description ### MGM ###\n ip address 192.168.10.13 255.255.255.0\n no cdp enable\n!\nip forward-protocol nd\n!\n!\nno ip http server\nno ip http secure-server\n!\n!\n!\n!\ncontrol-plane\n!\n!\n!\n!\n!\n!\n!\n!\nline con 0\n exec-timeout 5 30\n password 7 00343315174C5B140B\n logging synchronous\n login local\nline aux 0\nline vty 0 4\n logging synchronous\n login local\n history size 100\n transport input all\n!\n!\nend",
            "ansible_net_filesystems": [
                "system:"
            ],
            "ansible_net_filesystems_info": {
                "system:": {}
            },
            "ansible_net_gather_network_resources": [],
            "ansible_net_gather_subset": [
                "interfaces",
                "default",
                "hardware",
                "config"
            ],
            "ansible_net_hostname": "R3",
            "ansible_net_image": "unix:/opt/unetlab/addons/iol/bin/L3_ADVENTERPRISEK9_M_15.4_2T.bin",
            "ansible_net_interfaces": {
                "Ethernet0/0": {
                    "bandwidth": 10000,
                    "description": null,
                    "duplex": null,
                    "ipv4": [],
                    "lineprotocol": "down",
                    "macaddress": "aabb.cc00.0300",
                    "mediatype": null,
                    "mtu": 1500,
                    "operstatus": "administratively down",
                    "type": "AmdP2"
                },
                "Ethernet0/1": {
                    "bandwidth": 10000,
                    "description": null,
                    "duplex": null,
                    "ipv4": [],
                    "lineprotocol": "down",
                    "macaddress": "aabb.cc00.0310",
                    "mediatype": null,
                    "mtu": 1500,
                    "operstatus": "administratively down",
                    "type": "AmdP2"
                },
                "Ethernet0/2": {
                    "bandwidth": 10000,
                    "description": null,
                    "duplex": null,
                    "ipv4": [],
                    "lineprotocol": "down",
                    "macaddress": "aabb.cc00.0320",
                    "mediatype": null,
                    "mtu": 1500,
                    "operstatus": "administratively down",
                    "type": "AmdP2"
                },
                "Ethernet0/3": {
                    "bandwidth": 10000,
                    "description": "### MGM ###",
                    "duplex": null,
                    "ipv4": [
                        {
                            "address": "192.168.10.13",
                            "subnet": "24"
                        }
                    ],
                    "lineprotocol": "up",
                    "macaddress": "aabb.cc00.0330",
                    "mediatype": null,
                    "mtu": 1500,
                    "operstatus": "up",
                    "type": "AmdP2"
                },
                "Loopback0": {
                    "bandwidth": 8000000,
                    "description": null,
                    "duplex": null,
                    "ipv4": [
                        {
                            "address": "11.11.11.13",
                            "subnet": "32"
                        }
                    ],
                    "lineprotocol": "up",
                    "macaddress": null,
                    "mediatype": null,
                    "mtu": 1514,
                    "operstatus": "up",
                    "type": null
                }
            },
            "ansible_net_iostype": "IOS",
            "ansible_net_memfree_mb": 809.8315887451172,
            "ansible_net_memtotal_mb": 864.1188087463379,
            "ansible_net_neighbors": {},
            "ansible_net_operatingmode": "autonomous",
            "ansible_net_python_version": "3.10.12",
            "ansible_net_serialnum": "69212163",
            "ansible_net_system": "ios",
            "ansible_net_version": "15.4(2)T4",
            "ansible_network_resources": {}
        },
        "changed": false,
        "failed": false
    }
}
```
Позже можно выводить на экран конкрентный параметр, обратившись к нему по имени
- "ansible_net_all_ipv4_addresses" - список IPv4 адресов на устройстве    
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/20.jpg)
```
  tasks:
    - name: PB3_SHO IF in CONFIG      
      ios_facts:  
        gather_subset: all  
    - name: Print ansible_net_all_ipv4_addresses fact
      debug: var=ansible_net_all_ipv4_addresses  

```
- "ansible_net_all_ipv6_addresses"
- "ansible_net_api"
- "ansible_net_config" - конфигурационный файл в строке
```
"Building configuration...\n\nCurrent configuration : 1347 bytes\n!\n! Last configuration change at 13:33:43 MSK Thu Mar 29 2018\n!\nversion 15.4\nservice timestamps debug datetime msec\nservice timestamps log datetime msec\nservice password-encryption\n!\nhostname R3\n!\nboot-start-marker\nboot host tftp R3-confg 192.168.10.131\nboot-end-marker\n!\n!\n!\nno aaa new-model\nno process cpu autoprofile hog\nclock timezone MSK 3 0\nmmi polling-interval 60\nno mmi auto-configure\nno mmi pvc\nmmi snmp-timeout 180\n!\n!\n!\n!\n!\n!\n!\n!\n\n\n!\n!\n!\n!\nip domain name test.local\nip cef\nno ipv6 cef\n!\nmultilink bundle-name authenticated\n!\n!\n!\n!\n!\n!\n!\n!\nusername admin privilege 15 password 7 08116C5D1A0E550516\n!\nredundancy\n!\nno cdp run\n!\nip ssh version 2\n! \n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\n!\ninterface Loopback0\n ip address 11.11.11.13 255.255.255.255\n!\ninterface Ethernet0/0\n no ip address\n shutdown\n no cdp enable\n!\ninterface Ethernet0/1\n no ip address\n shutdown\n no cdp enable\n!\ninterface Ethernet0/2\n no ip address\n shutdown\n no cdp enable\n!\ninterface Ethernet0/3\n description ### MGM ###\n ip address 192.168.10.13 255.255.255.0\n no cdp enable\n!\nip forward-protocol nd\n!\n!\nno ip http server\nno ip http secure-server\n!\n!\n!\n!\ncontrol-plane\n!\n!\n!\n!\n!\n!\n!\n!\nline con 0\n exec-timeout 5 30\n password 7 00343315174C5B140B\n logging synchronous\n login local\nline aux 0\nline vty 0 4\n logging synchronous\n login local\n history size 100\n transport input all\n!\n!\nend"
```
- "ansible_net_filesystems" 
- "ansible_net_filesystems_info"
- ansible_net_gather_network_resources"
            "ansible_net_gather_subset": [
                "interfaces",
                "default",
                "hardware",
                "config"]
- "ansible_net_hostname"
- "ansible_net_image"
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/22.jpg)
- "ansible_net_interfaces" - позже, в выводе можно будет обращаться к конкретному IF, например "Ethernet0/0"
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/23.jpg)
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/24.jpg)
- ansible_net_interfaces - словарь со всеми интерфейсами устройства. Имена интерфейсов - ключи, а данные - параметры каждого интерфейса    
```
  tasks:
    - name: PB3_SHO IF in CONFIG      
      ios_facts:  
        gather_subset: all     
    - name: Print ansible_net_interfaces fact        
      debug: var=ansible_net_interfaces    

	- name: Print ansible_net_interfaces fact        
      debug: var=ansible_net_interfaces['Ethernet0/0']  
```

- "ansible_net_iostype"
- "ansible_net_memfree_mb": 809.8315887451172,
- "ansible_net_memtotal_mb": 864.1188087463379,
- "ansible_net_neighbors": {},
- "ansible_net_operatingmode": "autonomous",
- "ansible_net_python_version": "3.10.12",
- "ansible_net_serialnum": "69212163",
- "ansible_net_system": "ios",
- "ansible_net_version": "15.4(2)T4",
- "ansible_network_resources": {}
 
- ansible_net_all_ipv6_addresses - список IPv6 адресов на устройстве    
- ansible_net_config - конфигурация (для Cisco sh run)    
```
  tasks:
    - name: PB3_SHO IF in CONFIG      
      ios_facts:  
        gather_subset: all  
    - name: Print ansible_net_all_ipv4_addresses fact
      debug: var=ansible_net_config 
```
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/16.jpg)
- ansible_net_filesystems - файловая система устройства    
- ansible_net_gather_subset - какая информация собирается (hardware, default, interfaces, config)    
- ansible_net_hostname - имя устройства    
- ansible_net_image - имя и путь ОС    

- ansible_net_memfree_mb - сколько свободной памяти на устройстве    
```
  tasks:
    - name: PB3_SHO IF in CONFIG      
      ios_facts:  
        gather_subset: all               
    - name: Print hardware fact                      
      debug: var=ansible_net_memfree_mb
```
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/17.jpg)
- ansible_net_memtotal_mb - сколько памяти на устройстве    
- ansible_net_model - модель устройства    
- ansible_net_serialnum - серийный номер  
```
  tasks:
    - name: PB3_SHO IF in CONFIG      
      ios_facts:  
        gather_subset: all               
    - name: Print serialnum                      
      debug: var=ansible_net_serialnum 
```
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/18.jpg)
- ansible_net_version - версия IOS
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/19.jpg)

После того, как Ansible собрал факты с устройства, все факты доступны как переменные в playbook, шаблонах и т.д.
Например, можно отобразить содержимое факта с помощью debug (playbook 2_ios_facts_debug.yml):

```
  tasks:

    - name: Facts
      ios_facts:
        gather_subset: all

    - name: Show ansible_net_all_ipv4_addresses fact
      debug: var=ansible_net_all_ipv4_addresses

    - name: Show ansible_net_interfaces fact
      debug: var=ansible_net_interfaces['Ethernet0/0']
```

![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/15.jpg)


# Сохранение фактов
Для того, чтобы лучше понять, какая информация собирается об устройствах и в каком формате, скопируем полученную информацию в файл. [Для этого будет использоваться модуль copy](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\03_03\ios_command_03_03_01.yaml).
```
---

- name: Collect IOS facts
  hosts: cisco-routers

  tasks:

    - name: Facts
      ios_facts:
        gather_subset: all
      register: ios_facts_result

    #- name: Create all_facts dir
    #  file:
    #    path: ./all_facts/
    #    state: directory
    #    mode: 0755

    - name: Copy facts to files
      copy:
        content: "{{ ios_facts_result | to_nice_json }}"
        dest: "all_facts/{{inventory_hostname}}_facts.json"
```

еще пример:
```
---
  - name: capture show output
    hosts: routers
    gather_facts: no
	connection: network_cli     
	
	tasks:        
	  - name: show run
        ios_command:
          commands:
		  - show run
	      - show ip route
	      - show ip eigrp neighbors
	      - show version
	    register: config
  - name: save output to local directory
    copy:
	  content: "{{ config.stdout | replace('\\n', '\n') }}"
      dest: "show-output/{{ inventory_hostname }}.ios" 
...
```

Чаще всего, в Ansible, модуль copy используется таким образом:

```
- copy:
    src: /srv/myfiles/foo.conf
    dest: /etc/foo.conf
```

В строке `content: "{{ ios_facts_result | to_nice_json }}"`

- параметр to_nice_json - это фильтр Jinja2, который преобразует информацию переменной в формат, в котором удобней читать информацию
    
- переменная в формате Jinja2 должна быть заключена в двойные фигурные скобки, а также указана в двойных кавычках