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

### Создаем пользователя
1. для создания используем модуль ```-m user```
> [!question]- ``` ansible -i inventory os -m user -a "name=ansible create_home=yes" -u administrator -b -k -K ```
> ```ansible -i inventory os -m user -a "name=ansible create_home=yes" -u administrator -b -k -K``` - для всей группы хостов, если у них совпадает пароль administrator'a
![[Pasted image 20240114002623.png]]
>
/etc/passwd : Contains user account information 
/etc/shadow: Contains secured account information (encrypted password) 
/etc/group : Contains group account Information 
/etc/gshadow : Contains secured group information (encrypted group password)
>
![[Pasted image 20240114130521.png]]

2. Для задания разрешения на вновь созданный каталог можно использовать команду:

> [!question]- ``` ansible -i inventory ansible1 -m shell -a "sudo chown ansible:ansible /home/ansible" -u zabbix -b -k -K ``` - для Ubuntu 20 >
>

3. созданному пользователю нужен пароль (способ задания пароля отличается для каждой ОС), зададим через модуль ```-m shell```, с использованием ```pipe "|"```. 

> [!question]- ``` ansible -i inventory redos -m shell -a "echo 'ansible:P@55w0rd' | chpasswd" -u administrator -b -k -K ``` - для Ubuntu 20/22, RedOS >
> ![[Pasted image 20240114162905.png]] 
> ![[Pasted image 20240114160349.png]]
> ![[Pasted image 20240114154143.png]]

> [!question]- ``` ansible -i inventory ansible1 -m shell -a "echo password | chpasswd --stdin ansible" -u administrator -b -k -K ``` >
> 
> 

4. Созданного пользователя надо добавить в группу администраторов
> [!question]- ``` ansible -i inventory os -m shell -a "adduser ansible sudo" -u administrator -b -k -K ``` - Ubuntu 20/22
> ![[Pasted image 20240114154802.png]]

> [!question]- ``` ansible -i inventory redos -m shell -a "usermod -aG wheel ansible" -u administrator -b -k -K ``` - RedOS
>![[Pasted image 20240114162444.png]] 

Проверка принадлежности пользователя группе
> [!question]- ``` ansible -i inventory os -m shell -a "sudo groups ansible" -u administrator -b -k -K ``` - Ubuntu 20/22,RedOS
>![[Pasted image 20240119112024.png]]

> [!question]- ``` ansible -i inventory os -m shell -a "getent group sudo" -u ansible -b -k -K ``` - Ubuntu 20/22
>

> [!question]- ``` ansible -i inventory os -m shell -a "getent group wheel" -u ansible -b -k -K ``` - RedOS
>

> [!question]- ``` ansible -i inventory os -m shell -a "cat /etc/group | grep ansible" -u ansible -b -k -K ``` - Ubuntu 20/22,RedOS
>![[Pasted image 20240119144141.png]]

Удаление пользователя
> [!question]- ``` ansible -i inventory lin -m user -a "name=ansible state=absent remove=true" -u administrator -b -k -K ``` - Ubuntu 20/22,RedOS
>![[Pasted image 20240207151142.png]]

Но есть и другой способ, о нем будет рассказано позже.

### SSH key-based login
Генерим ssh пару ключей и копируем их на все ноды, чтобы выполнять действия без ввода пароля
```
ssh-keygen
ssh-copy-id ansible@ubuntu20 - пришлось скидывать права на каталог пользователя.
ssh-copy-id ansible@ubuntu22
ssh-copy-id ansible@redos732

ansible -i inventory os -m command -a "id" -u ansible
```

![[Pasted image 20240119123700.png]]
[сравнительная таблица](https://redos.red-soft.ru/upload/iblock/001/su-sudo.png)
### Эскалация привилегий
Цель этого действия - разрешить пользователю ansible при подключении не вводить пароль для выполнения команд с повышенными привилегиями.
Для отключения запроса паролянеобходимо всего лишь добавить к строчке настройки пользователя директиву NOPASSWD (аналогично можно сделать для группы). 
1. Создаем файл sudoers и в нем размещаем инструкцию ```echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /tmp/sudoers```
2. Копируем на локальном ПК созданный файл в каталог sudeors.d с переименованием в нужного пользователя
3. Копируем ansible файл в каталоги на удаленные хосты

> [!question]- ``` Эскалация привилегий ``` - Ubuntu 20/22,RedOS
>```
echo 'ansible ALL=(ALL) NOPASSWD: ALL'>/tmp/sudoers
ansible -i inventory os -m copy -a "src=/tmp/sudoers dest=/etc/sudoers.d/ansible" -u ansible -b -K
>       проверка
>ansible -i inventory os -m shell -a "ls -lah /root" -b -u ansible
>```
![[Pasted image 20240119135106.png]]

### CFG файл
При выполнении задач, часто требуется указывать настройки для выполнения, они могут быть заданы в:
- строке исполнения ad-hoc команды
- playbook
- [ansible.cfg (конфигурационный файл)](obsidian://open?vault=GIT&file=Admining%2FLinux%2FAnsible%2FAnsible_%D0%B4%D0%BB%D1%8F_%D1%81%D0%B5%D1%82%D0%B5%D0%B2%D1%8B%D1%85_%D0%B8%D0%BD%D0%B6%D0%B5%D0%BD%D0%B5%D1%80%D0%BE%D0%B2%2F01%2F01_03_config_file)
      - по-умолчанию ansible.cfg: /etc/ansible/ansible.cfg
      - можно создать файл ansible.cfg в папке проекта, и его наличие "перекроет" файл по-умолчанию

Основные параметры [пример](https://github.com/sandervanvugt/ansiblecvc/blob/main/ansible.cfg):
- default раздел
     - inventory = inventory - файл хостов
     - remote_user = ansible - под кем производим подключение
     - host_key_checking = false - отключение проверки SSH
- privilege_escalation
     - become = True - запускать в привилегированном режиме (не надо больше использовать параметр ```-b```)
     - become_method = sudo - метод привилегированного режима ([сравнительная таблица](https://redos.red-soft.ru/upload/iblock/001/su-sudo.png))
     - become_user = root - пользователь привилегированного режима
     - become_ask_pass = False - запрет на запрос пароля для входа в привилегированный режим
![[Pasted image 20240119232422.png]]
После заполнения конфигурационного файла, можно не задавать всех параметров, которые мы использовали ранее
```
ansible all -m shell -a "ls -l /root"
```
![[Pasted image 20240119233427.png]]
![[Pasted image 20240119233716.png]]
Если в командной строке задать какие-то параметры, то они перекроют параметры из CFG

Выключение хостов
```
ansible all -m shell -a "shutdown now"
```


