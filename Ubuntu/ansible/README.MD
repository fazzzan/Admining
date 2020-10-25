1. Ставим нужные вспомогательные сервисы:
tftpd
MC 
(With SecureCRT: Select Options -> Session Options -> Terminal -> Appearence -> Character encoding -> select: UTF-8.)
2. [Настраиваем сервер SSH](https://github.com/fazzzan/Admining/blob/master/Ubuntu/SSH/README.MD), чтобы он мог подключаться в том числе к клиентам со старыми алгоритмами шифрования
3. Закачиваем ssh key на наш сервер:
ssh-copy-id cisco@192.168.48.193
```
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/fedor/.ssh/id_rsa.pub"
...
Number of key(s) added: 1
...
Now try logging into the machine, with:   "ssh 'cisco@192.168.48.193'"
and check to make sure that only the key(s) you wanted were added.
```
Проверка заключается в ручном подключении "ssh username@remote_host" - запроса на импорт ключа быть не должно
На cisco проверить работу SSH ```do show ip ssh```. Для IOL:

```
SW4(config)#do show ip ssh
SSH Enabled - version 1.99
Authentication methods:publickey,keyboard-interactive,password
Authentication Publickey Algorithms:x509v3-ssh-rsa,ssh-rsa
Hostkey Algorithms:x509v3-ssh-rsa,ssh-rsa
Encryption Algorithms:aes128-ctr,aes192-ctr,aes256-ctr
MAC Algorithms:hmac-sha1,hmac-sha1-96
Authentication timeout: 120 secs; Authentication retries: 3
Minimum expected Diffie Hellman key size : 1024 bits
IOS Keys in SECSH format(ssh-rsa, base64 encoded): SW4
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCeXvCoKW8wcCr5YCDMezsvNHjz8Gt3NgcjIFlIzZQp
J9j/4o4SP8vXG6vx3tiUT3wPsCfhUpLhVVWf/yBYXB0p1loqvV8X6C/0AP5aRubf5X/bb5Wk5zDu7A/R
vm4zKaTNvN56VtRRnyM9NMmN18kL5YPKPl0ojwoffpNyPk9SpdllCI6BaCl1h/O1cfQYqQOvSyxqs383
cEhzLwYwwmdF+GWAxS/SL2FYrGRojYkZSbO8KNmtXKtoo8MoXrdA4jdCcKnekkLJ6Tr0p1fab+WgOnLu
VXXNTzAcxOXmDQyoouNCuFpi+F/YgwTlEhsIMnSHB2BtPaMeWqx1aGSXm/Nv
```

4. Установка Ansible
Необходимо предварительно установить программное обеспечение Ansible узел управления. Сначала обновим индекс пакетов системы с помощью следующей команды: 
```sudo apt update```.
После этого обновления установить программное обеспечение Ansible: 
```sudo apt install ansible```

```
sudo apt-get install python3-pip
pip3 install netaddr
pip3 install paramiko
```
5. Проверка файла hosts. Каталоги все логически увязаны между собой. Если в файле hosts есть группа network, то в каталоге group_vars должен файл с именем networks.yml, и только тогда inventory будет полностью нормально разворачиваться.
```
ansible-inventory --list -y
...
fedor@s-mon:/etc/ansible/L7$ ansible-inventory --list -y                   
all:
  children:
    network:
      children:
        lan:
          children:
            access:
              hosts:
                SW1:
                  Ansible_host: 192.168.48.201
                  ansible_become: true
                  ansible_become_method: enable
                  ansible_become_password: cisco123
                  ansible_connection: network_cli
                  ansible_network_os: ios
                  ansible_password: cisco
                  ansible_user: cisco
                  domain_name: otus1.local
                  name_servers: &id001
                  - 8.8.8.8
                  - 8.8.4.4
                  ntp_server: 172.20.1.17
                SW2:
                  Ansible_host: 192.168.48.202
                  ansible_become: true
                  ansible_become_method: enable
                  ansible_become_password: cisco123
                  ansible_connection: network_cli
                  ansible_network_os: ios
                  ansible_password: cisco
                  ansible_user: cisco
                  domain_name: otus1.local
                  name_servers: *id001
                  ntp_server: 172.20.1.17
                SW3:
                  Ansible_host: 192.168.48.203
                  ansible_become: true
                  ansible_become_method: enable
                  ansible_become_password: cisco123
                  ansible_connection: network_cli
                  ansible_network_os: ios
                  ansible_password: cisco
                  ansible_user: cisco
                  domain_name: otus1.local
                  name_servers: *id001
                  ntp_server: 172.20.1.17
```
6. Также проверяем работу DNS/hosts 
```
sudo vi /etc/hosts
192.168.48.201 SW1
192.168.48.202 SW2
192.168.48.203 SW3
192.168.48.204 SW4
192.168.48.191 R1
192.168.48.192 R2
192.168.48.193 R3
192.168.48.194 R4
```

