![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/25.jpg)

Проверка того что есть или встало:
```
ansible --version
  
  ansible [core 2.12.0]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.12 (main, Jun 11 2023, 05:26:28) [GCC 11.4.0]
  jinja version = 3.0.3
  libyaml = True
```
Тут будет показано расположение cfg. 

Сам файл ansible.cfg может храниться (файлы перечислены в порядке уменьшения приоритета):
- ANSIBLE_CONFIG (переменная окружения) 
-  [ansible.cfg](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_03\ansible.cfg) (в текущем каталоге)    
- ~/.ansible.cfg (в домашнем каталоге пользователя)    
- /etc/ansible/[ansible.cfg](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_03\ansible.cfg)

Конфигурация из разных файлов не совмещается. [Пример файла](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_03\ansible.cfg) , содержит:
- ссылка на inventory-файл в формате ini
- имя пользователя по-умолчанию
- запрос пароля
- отключение сбора фактов _gathering_
- запрет проверки ключей при подключении по SSH _host_key_checking_
```
root@admin-UB01:/etc/ansible# cat ansible.cfg 
[defaults]

inventory = ./myhosts.ini
remote_user = admin 
ask_pass = True
# Отключение сбора фактов в конфигурационном файле:
gathering = explicit
host_key_checking=False
```