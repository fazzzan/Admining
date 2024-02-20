# Настройка tftp
Материал взял отсюда: https://habr.com/ru/post/470303/ . Особенность настройки - запуск tftp только при обращении к нему
1. Ставим ОС, настраиваем сетевой IF
2. Доставляем пакеты xinetd, tftp-server, tftp, vim
```
sudo dnf -y install xinetd tftp-server tftp vim
```
3. Редактируем файл конфигурации:
   * - аргумент server_args: путь к каталогу, где лежат файлы, отдаваемые по tftp. </var/lib/tftpboot>
```
sudo vim /etc/xinetd.d/tftp

# default: off
# description: The tftp server serves files using the trivial file transfer \
#       protocol.  The tftp protocol is often used to boot diskless \
#       workstations, download configuration files to network-aware printers, \
#       and to start the installation process for some operating systems.
service tftp
{
        socket_type             = dgram
        protocol                = udp
        wait                    = yes
        user                    = root
        server                  = /usr/sbin/in.tftpd
        server_args             = -v -s /var/lib/tftpboot
        disable                 = no
        per_source              = 11
        cps                     = 100 2
        flags                   = IPv4
}
```
4. Настройка Firewall
   * Смотрим какие зоны есть ```ls -l /usr/lib/firewall/zones```
   * Проверяем сервисы в public зоне файерволла ```cat /usr/lib/firewall/zones/public.xml
   * Проверяем что IF в зоне public: ```firewall-cmd --get-active-zones```
   * Добавляем tftp в список приложений зоны public ```sudo firewall-cmd --permanent --zone=public --add-service=tftp && sudo firewall-cmd --reload```

5. Включаем сервер:
```
sudo systemctl start xinetd
sudo systemctl enable xinetd
```
6. Проверяем
Да, вешать в автозагрузку tftpd не требуется, хоть это и не совсем очевидно.
Далее, надо проверить, что всё работает. Создаём какой-нибудь файл и пытаемся его скачать (я делал для популярного пути хранения файлов, если он у вас другой — измените его тут):

echo passed > ~/test.txt
sudo mv ~/test.txt /var/lib/tftpboot
tftp 127.0.0.1 -c get test.txt
cat test.txt

Если в консоли появилось слово «passed», значит сервер работает. Если из локальной сети он при этом будет не доступен — разбирайтесь с зонами в firewalld
