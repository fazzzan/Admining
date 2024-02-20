```
vi inventory
или
nano myhosts.ini
```
Файл может быть описан в формате INI ([myhosts.ini](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_01)) или YAML. В формате ini - используем:
- для конкрентного хостоа - ip или hostname,
- группы хостов [group_name]
- или группы групп [group]
- настройки :vars группы  [group:vars]
Хост может быть в нескольких группах, последовательные имена можем обозначать как _R[1:7]_.

```
...
[cisco_routers]
R[1:7]

[cisco_routers2]
router[A:D].example.com

[cisco_routers3]
192.168.255.1
192.168.255.2
192.168.255.3
192.168.255.4

[cisco_edge_routers]
192.168.255.1
192.168.255.2

[cisco_switches]
192.168.254.1
192.168.254.2

# кл.слово - children, до него - название группы
[cisco_devices:children]
cisco_routers
cisco_switches

# переменные для группы
[cisco_devices:vars]
ansible_connection=network_cli
ansible_network_os=ios
ansible_user=admin
ansible_password=P@ssw0rd
# ask_pass = False - если не хотим вводить пароль при запуске плейбука
```


Инвентарный файл (например [myhosts.ini](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_01\myhosts.ini)) должен лежать в каталоге на который указывает конфигурационный файл [ansible.cfg](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_01\ansible.cfg)

Просмотреть список хостов из файла заданного параметром inventory [ansible.cfg](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_01\ansible.cfg) или из файла inventory
```
ansible all --list-hosts
или 
ansible -i inventory os --list-hosts
``` 

![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/28.jpg)