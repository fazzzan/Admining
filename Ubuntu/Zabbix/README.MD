https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-zabbix-to-securely-monitor-remote-servers-on-ubuntu-20-04-ru

1. Закачиваем server LTS Ubuntu 20 (Focal Fossa)
2. Устанавливаем, вручную конфигурируя IF. Сначала я пробовал ставить 2 IF, но после ряда ошибок решил ставить сначала IF/NAT и затем после установки и обновок, добавить IF2/Inside, чтобы иметь следующую цепочку:
VMNet8(NAT)<->ens33|Ubuntu|ens34<->VMNet1<->CLOUD<->GNS3 Labs
3. После установки проверяем ```ip a``` (Конфиг интерфейсов); ```ip route show``` (таблица маршрутизации);```ls /etc/netplan/``` (Что там за конфиг IF - main netplan configuration file ); 
```
fedor@s-admin:/etc/netplan$ ip a
...
2: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
...
    inet 192.168.163.140/24 brd 192.168.163.255 scope global ens33
...
3: ens34: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
...
    inet 192.168.48.182/24 brd 192.168.48.255 scope global dynamic ens34
...

fedor@s-mon:~$ ip route show
default via 192.168.163.2 dev ens33 proto static 
192.168.48.0/24 dev ens34 proto kernel scope link src 192.168.48.182 
192.168.163.0/24 dev ens33 proto kernel scope link src 192.168.163.140 
...
fedor@s-admin:/etc/netplan$ ls /etc/netplan/
00-installer-config.yaml
fedor@s-admin:/etc/netplan$ 
```
4. Редактируем netplan ```sudoedit /etc/netplan/00-installer-config.yaml```, делая ens33 static ip, после чего применив ```sudo netplan apply```:

```
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
#      dhcp4: true
      addresses:
      - 192.168.163.140/24
      gateway4: 192.168.163.2
      nameservers:
        addresses: [8.8.8.8, 127.0.0.1]
    ens34:
#       dhcp4: true
      addresses:
      - 192.168.48.182/24
      gateway4: 192.168.48.2
      nameservers:
        addresses: [127.0.0.1]
        search: [labs]

  version: 2

```
Проверка
```
fedor@s-mon:~$ ping www.ya.ru
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=128 time=18.1 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=128 time=18.6 ms
^C
--- ya.ru ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 18.105/18.348/18.591/0.243 ms
```

5. Установка сервера Apache httpd: 

Обновить систему, установить пакет apache2, выполнив следующие команды:

```
sudo apt update
sudo apt -y upgrade
sudo apt install -y apache2
```
После установки Apache - настроить базовую опцию безопасности, разрешив Prod ServerTokens только /etc/apache2/conf-enabled/security.conf: 
```
sudo sed -i "s/^ServerTokens OS$/ServerTokens Prod/" /etc/apache2/conf-enabled/security.conf
sudo sed -i "s/^ServerSignature On$/ServerSignature Off/" /etc/apache2/conf-enabled/security.conf
```
Директива ServerTokens настраивает то, что возвращается как HTTP-ответ сервера.
Допустимые варианты:  full | OS | Minimal | Minor | Major | Prod.

Перезапустить веб-сервис Apache после внесения изменений:
```
sudo systemctl restart apache2
```

Если установлен и включен брандмауэр UFW, разрешите доступ к портам 443 и 80:

```
sudo ufw allow proto tcp from any to any port 80,443
```

Чтобы включить брандмауэр UFW в Ubuntu, используйте:
```
sudo ufw enable
```

Включить службу ssh:
```
sudo ufw allow ssh
```

6. Установка сервера базы данных MariaDB
https://www.digitalocean.com/community/tutorials/how-to-install-mariadb-on-ubuntu-20-04-ru
Установить сервер базы данных MariaDB на Ubuntu 20.04 LTS.
```
sudo apt install mariadb-server
```
Обезопасить сервер базы данных:
```
sudo mysql_secure_installation
```
Обновить плагин аутентификации для пользователя root.
```
$ sudo mysql -u root
UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE User = 'root';
FLUSH PRIVILEGES;
QUIT;
```
Зададим нового пользователя fedor с правами root и с аутентификацией на основе пароля. Измените имя пользователя и пароль на предпочитаемые:
```
GRANT ALL ON *.* TO 'fedor'@'localhost' IDENTIFIED BY 'S...1' WITH GRANT OPTION;
```
Очистить привилегии, чтобы они были сохранены и доступны в текущем сеансе и закрыть оболочку MariaDB:
```
FLUSH PRIVILEGES;
exit;
```
Теперь проверить установку MariaDB. Если MariaDB не запущена, вы можете воспользоваться командой ```sudo systemctl start mariadb``` для запуска.
```
sudo systemctl status mariadb
Output
● mariadb.service - MariaDB 10.3.22 database server
     Loaded: loaded (/lib/systemd/system/mariadb.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2020-05-12 13:38:18 UTC; 3min 55s ago
       Docs: man:mysqld(8)
             https://mariadb.com/kb/en/library/systemd/
   Main PID: 25914 (mysqld)
     Status: "Taking your SQL requests now..."
      Tasks: 31 (limit: 2345)
     Memory: 65.6M
     CGroup: /system.slice/mariadb.service
             └─25914 /usr/sbin/mysqld
. . .
```
или залогиниться под пользователем fedor ```mysqladmin -u fedor -p version```

После завершения установки сервера базы данных - необходимо создать базу данных для пользователя Zabbix.
Заменить «StrongPassword» на нужный пароль для базы данных.

```
shell> mysql -ufedor -pS...1
mysql> create database zabbix character set utf8 collate utf8_bin;
mysql> grant all privileges on zabbix.* to fedor@localhost identified by 'S...1';
mysql> quit;
```

7. Установка Zabbix 5.0 сервера на Ubuntu 20.04 (Focal Fossa).
Теперь, когда установлены и работают необходимые зависимости, развернeуть сервер Zabbix 5.0.
Добавьте репозиторий Zabbix 5.0 в Ubuntu 20.04 (Bionic Beaver) LTS:
```
wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb
sudo dpkg -i ./zabbix-release_5.0-1+focal_all.deb
```
Теперь установить Zabbix 5.0 Server на Ubuntu 20.04 с поддержкой внешнего интерфейса и MySQL:
```
sudo apt update
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent
```

8. Импорт схемы базы данных Zabbix сервера
Для демонов Zabbix server и Zabbix proxy требуется база данных. Нет необходимости запускать Zabbix агент. Если Zabbix сервер и прокси установлены на одном хосте, их базы данных должны быть созданы с разными именами!
Импорт исходной схемы и данных для сервера с MySQL:
```
sudo su -
zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -ufedor -p zabbix
```
Ввести пароль пользователя базы данных Zabbix при появлении запроса.

9. Настройка и запуск Zabbix сервера
Отредактировать конфигурационный файл Zabbix /etc/zabbix/zabbix_server.conf и настроить параметры подключения к базе данных.
```
$ sudo vim /etc/zabbix/zabbix_server.conf
DBName=zabbix
DBUser=zabbix
DBPassword=S...1
```

Настроить PHP для веб-интерфейса Zabbix: файл /etc/zabbix/apache.conf, раскомментировать и установить часовой пояс.
```
$ sudo vim /etc/zabbix/apache.conf
php_value date.timezone Africa/Nairobi
```
Раздел должен выглядеть так:
```
............
<IfModule mod_php7.c>
        php_value max_execution_time 300
        php_value memory_limit 128M
        php_value post_max_size 16M
        php_value upload_max_filesize 2M
        php_value max_input_time 300
        php_value max_input_vars 10000
        php_value always_populate_raw_post_data -1
        php_value date.timezone Europe/Moscow
</IfModule>
.....
```
Перезапустить Zabbix сервер после изменения этого файла:
```
sudo systemctl restart zabbix-server zabbix-agent apache2
sudo systemctl enable zabbix-server zabbix-agent apache2
```
Настройка брандмауэра: убедитесь, что разрешен порт 5000 и порт 5001, Перезапустить apache2 и начать установку фронтенда:
```
sudo ufw allow proto tcp from any to any port 10050,10051
sudo systemctl restart apache2
```

10. Начальная настройка Zabbix

«http://(имя хоста или IP-адрес Zabbix сервера)/zabbix/», чтобы начать первоначальную настройку Zabbix.
- Шаг 1 – страница приветствия, нажмите «Next step», чтобы продолжить.
Нажмите Next, чтобы подтвердить требования к зависимостям.
Подтвердите настройки БД
Введите данные базы данных, которые мы создали ранее.
Вы можете заметить, что TLS также можно настроить на этом шаге, если вы хотите шифрование в подключении к вашей базе данных.
Нажмите «Next step» после завершения
Завершите установку, чтобы получить доступ к панели управления Zabbix.
Как только вы увидите страницу входа, введите учетные данные по умолчанию:

Username: "Admin"
Password: "zabbix"

- Шаг 2: Сменить пароль администратора
Войти в панель администратора с правами администратора. Из соображений безопасности необходимо изменить пароль для пользователя-администратора после первого входа в систему. 
```
Administration > Users > Admin > Password > Change Password
```

11. Регистрация хоста на сервере Zabbix
```(https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-zabbix-to-securely-monitor-remote-servers-on-ubuntu-20-04-ru)```

Делать через веб-интерфейс по адресу http://zabbix_server_name​​​/zabbix или https://zabbix_server_name/zabbix
```Configuration (Настройка) -> Hosts (Хосты) на левой панели управления -> Create host​​​​​​ (Создать хост) в верхнем правом углу экрана. ``` Откроется страница настройки хоста. Задать:
- Имя хоста
- IP-адрес
а затем добавить хост в группу. Можно выбрать существующую группу, например серверы Linux, или создать собственную группу. Хост может быть в нескольких группах. Для этого введите имя существующей или новой группы в поле Groups (Группы) и выберите желаемое значение из предлагаемого списка. Перед тем как добавить группу, нажмите на вкладку Templates​​​.

12. Настройка уведомлений по электронной почте

