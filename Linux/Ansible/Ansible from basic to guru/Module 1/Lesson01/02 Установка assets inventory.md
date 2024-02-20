Тэги: #ansible #assets #modules #Inventory #ad-hoc #AWT
Ссылки: 
## Установка 
### Ansible

```
sudo yum update

# OPENSSL
sudo yum install openssl
## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
##openssl version
##OpenSSL 3.0.7 1 Nov 2022 (Library: OpenSSL 3.0.7 1 Nov 2022)

# PYTHON
sudo yum install python3
sudo yum install python3-pip
## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
##python3 -m pip -V
##pip 21.2.3 from /usr/lib/python3.9/site-packages/pip (python 3.9)

# ANSIBLE
python3 -m pip install --user ansible
sudo su
python3 -m pip install --user ansible
ansible --version
## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
##ansible --version
##ansible [core 2.15.9]

или так:
# sudo dnf provides */ansible - Поиск пакета, к которому принадлежит определенный файл/подпакет
sudo dnf install -y ansible - Установка стандартного пакета

Результат транзакции
===========================================================================================
Установка  6 Пакетов
```

> [!Что было установлено]- Что было установлено
> Объем загрузки: 17 M
> Объем изменений: 99 M
> Загрузка пакетов:
> (1/6): python3-jmespath-0.9.0-3.el7.noarch.rpm             297 kB/s |  42 kB     00:00    
> (2/6): sshpass-1.06-3.el7.x86_64.rpm                       170 kB/s |  24 kB     00:00    
> (3/6): python3-bcrypt-3.2.2-1.el7.x86_64.rpm               976 kB/s |  42 kB     00:00    
> (4/6): python3-pynacl-1.5.0-1.el7.x86_64.rpm               1.3 MB/s | 113 kB     00:00    
> (5/6): python3-paramiko-2.12.0-1.el7.noarch.rpm            1.4 MB/s | 307 kB     00:00    
> (6/6): ansible-2.9.27-3.el7.noarch.rpm                     2.7 MB/s |  17 MB     00:06    
> -------------------------------------------------------------------------------------------
> Общий размер                                               2.8 MB/s |  17 MB     00:06     
Проверка транзакции
Проверка транзакции успешно завершена.
Идет проверка транзакции
Тест транзакции проведен успешно.
Выполнение транзакции
  Подготовка       :                                                                   1/1 
  Установка        : python3-pynacl-1.5.0-1.el7.x86_64                                 1/6 
  Установка        : python3-bcrypt-3.2.2-1.el7.x86_64                                 2/6 
  Установка        : python3-paramiko-2.12.0-1.el7.noarch                              3/6 
  Установка        : sshpass-1.06-3.el7.x86_64                                         4/6 
  Установка        : python3-jmespath-0.9.0-3.el7.noarch                               5/6 
  Установка        : ansible-2.9.27-3.el7.noarch                                       6/6 
  Запуск скриптлета: ansible-2.9.27-3.el7.noarch                                       6/6 
  Проверка         : python3-jmespath-0.9.0-3.el7.noarch                               1/6 
  Проверка         : sshpass-1.06-3.el7.x86_64                                         2/6 
  Проверка         : ansible-2.9.27-3.el7.noarch                                       3/6 
  Проверка         : python3-bcrypt-3.2.2-1.el7.x86_64                                 4/6 
  Проверка         : python3-paramiko-2.12.0-1.el7.noarch                              5/6 
  Проверка         : python3-pynacl-1.5.0-1.el7.x86_64                                 6/6 
Установлен:
  ansible-2.9.27-3.el7.noarch                 python3-bcrypt-3.2.2-1.el7.x86_64           
  python3-jmespath-0.9.0-3.el7.noarch         python3-paramiko-2.12.0-1.el7.noarch        
  python3-pynacl-1.5.0-1.el7.x86_64           sshpass-1.06-3.el7.x86_64                   

![[Pasted image 20240113075813.png]]

Все зависимости ansible - phyton, потому что сам A разработан на Phyton
ansible --version
![[Pasted image 20240113082702.png]]

Установка версии 2.13, на UBUNTU 22
```
sudo apt-get update (подождать несколько минут)
sudo apt update (подождать несколько минут)
sudo apt install python3-pip (подождать несколько минут)
pip3 --version
pip3 install ansible-core==2.13
snap install curl

# PYTHON2
sudo apt install python2
sudo apt-get install python-pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py - если не получается. wget
wget https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible
export PATH="/root/.local/bin:$PATH"
ansible --version
```

Установка версии 2.13 для RedOS, используется установщик pip
```
sudo dnf provides */pip
... Выбираем последнюю версию

dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm
dnf install epel-release
pip3 install ansible-core==2.13
python3 -m pip -V
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --user
python3 -m pip install --user ansible
export PATH="/root/.local/bin:$PATH"
/root/.local/bin/ansible --version


```
![[Pasted image 20240113103951.png]]

Отличие начиная с версии 2.12 - коллекции
## Удаление
https://www.thegeekdiary.com/how-to-uninstall-ansible-software-package-in-ubuntu/

## Управление assets
- Control Node - рабочая станция, где установлен ANSIBLE, Python и откуда можно получить доступ к playbook
- Managed Nodes - узлы, которыми управляет ANSIBLE (win, Lin, network etc)
Требования для работы на nodes:
- Доступ по SSH, в текущем курсе будет настроено подключение с ключом -k (запрос пароля)
- Выделенный аккаунт для ANSIBLE (единый для всех, или выделенный для каждой ноды)
- права для выделенного аккаунта, чтобы он мог установливать пакеты, или конфигурационные файлы

## Inventory
Для работы необходимо задать разрешение имени ноды в ip:
- /etc/hosts
- DNS
Необходимо настроить файл inventory (/etc/ansible/hosts):
- доступ к хостам
- группировка нод
- задание переменных
Последующее использование файла через ключ ```-i ```, или задание файла inventory в файле ansible.cfg.
