Oct. 31, 2022
https://learning.oreilly.com/live-events/ansible-in-4-hours/0636920123842/

https://github.com/sandervanvugt/ansiblefundamentals

При первичной настройке EVE-NG очень много времени потрачено на:
- [```D:\Soft\eve-ng\EVE-NG-Win-Client-Pack-2.0.exe```](https://mega.nz/file/G5liXYzK#oaSC1Jrh5m0HaNkReirurtrXhIHGw6NOZX3jgus1xqo)
- подключение [SecureCRT](https://adminreboot.com/configure-eve-ng-to-use-securecrt-eve-ng-integrate-with-securecrt/): ```Open Firefox > Tools (☰) > Setting > Applications > Content Type **telnet** choose Action **Use SecureCRT Application**.```
- При установке Linux на ВМ в EVE-NG, необходимо в каталог положить iso файл и строчку QEMU сконфигурировать так, чтобы ВМ грузилась с CD и поддерживала клавиатуру:
```
-machine type=pc-1.0,accel=kvm -vga std -usbdevice tablet -boot order=d -k en-us
дефолтные настройки
-machine type=pc-1.0,accel=kvm -vga std -usbdevice tablet -boot order=cd
```
- открытие [новой сессии во вкладке](https://adminreboot.com/securecrt-open-new-tab-instead-of-open-new-window/)
![[Pasted image 20240716133259.png]]
- первоначальные конфигурации R1...R7. Основная задача: при загрузке Rxx должен брать первоначальный конфигурационный файл с tftp сервера. Алгоритм выстроен следующим образом:
1. Базовые настройки Rxx сохраняем и выгружаем в startup-конфиг EVE-NG, чтобы при wipe устройства оно конфигурировалось в минимальном объеме, достаточном для скачиванивания конфига с tftp
<details><summary>R1</summary>
    <pre>
hostname R1
!
boot-start-marker
boot host tftp R1-confg 192.168.10.131
boot-end-marker
!
interface Ethernet0/3
 ip address dhcp
 no shutdown
!
no ip http server
no ip http secure-server
    </pre>
   </details>
2. Обязательно делаем WR MEM  на роутере, после чего задаем загрузку Rxx из startup-конфиг EVE-NG 
3. В схему EVE-NG вводим "сеть", из списка подключенных к EVE интерфейсов, на котором работает DHCP, чтобы при включении Rxx получал ip и мог выйти на связь с tftp
![](pictures/01.png)
![](GIT/Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/02.jpg)
4.  Для установки tftp под UBUNTU
```
apt install xinetd tftpd tftp
```
6. В tftp создаем файлы с именами R1...R7, которые будут открываться загрузчиком 
```
administrator@admin-UB01:~$ cd /var/tftpboot/
administrator@admin-UB01:/var/tftpboot$ ll
total 44
drwxrwxrwx  3 nobody root 4096 ноя 13 10:35 ./
drwxr-xr-x 15 root   root 4096 ноя 10 10:10 ../
-rw-r--r--  1 root   root  606 ноя 13 10:33 R1-confg
-rw-r--r--  1 root   root  605 ноя 13 10:34 R2-confg
-rw-r--r--  1 root   root  605 ноя 13 10:34 R3-confg
-rw-r--r--  1 root   root  605 ноя 13 10:34 R4-confg
-rw-r--r--  1 root   root  605 ноя 13 10:34 R5-confg
-rw-r--r--  1 root   root  605 ноя 13 10:34 R6-confg
-rw-r--r--  1 root   root  605 ноя 13 10:35 R7-confg
-rw-r--r--  1 root   root  605 ноя 10 21:41 R8-confg
```
![](configs/R1-confg)
5. Проверяем через Wipe или очистку конфига
```
do erase startup-config
c
do reload
```




