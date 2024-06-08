[Установка и запуск](https://linuxize.com/post/how-to-install-gitea-on-centos-8/)
Прошло гораздо легче, буквально за 5 минут.
```
sudo dnf install sqlite
```
We’re assuming that [SELinux is either disabled](https://linuxize.com/post/how-to-disable-selinux-on-centos-8/) or set to permissive mode.
```
sudo useradd \
    --system \
    --shell /bin/bash \
    --comment 'Git Version Control' \
    --create-home \
    --home /home/git \
    git
```

```
На redos заработала эта версия
wget -O /tmp/gitea https://dl.gitea.com/gitea/1.21.7/gitea-1.21.7-linux-amd64
На centos заработала только эта версия
wget -O /tmp/gitea https://dl.gitea.com/gitea/1.21.7/gitea-1.21.7-linux-386
```

```
sudo mv /tmp/gitea /usr/local/bin

sudo chmod +x /usr/local/bin/gitea

mkdir -p /var/lib/gitea/{custom,data,indexers,public,log}
chown git: /var/lib/gitea/{data,indexers,log}
chmod 750 /var/lib/gitea/{data,indexers,log}
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea
chmod o+rx /usr/local/bin/gitea


sudo wget https://raw.githubusercontent.com/go-gitea/gitea/master/contrib/systemd/gitea.service -P /etc/systemd/system/


sudo systemctl daemon-reload
sudo systemctl enable --now gitea

sudo systemctl status gitea
```

Проверяем что у нас ничего не крутится на 3000 порту,  Если что-то занимает 3000 (у меня был докер), то меняем в конфиге, при этом не забываем что в конце идет обязательное разрешения  трафика через ___firewall-cmd___

```
netstat -pna | grep 3000

vi /etc/gitea/app.ini
```
 Если что-то занимает 3000 (у меня был докер), то меняем в конфиге
![[Pasted image 20240316072624.png]]

помогает диагностировать 
```
journalctl | tail -100
```


Теперь, когда Gitea запущена, пришло время завершить установку через веб-интерфейс.

По умолчанию Gitea прослушивает соединения через порт 3000 на всех сетевых интерфейсах. Вам нужно настроить брандмауэр, чтобы разрешить доступ к веб-интерфейсу Gitea:

```
sudo firewall-cmd --permanent --zone=public --add-port=3000/tcp
sudo firewall-cmd --reload
```


Также смотрим логи на предмет SELinux, мне помогла эта команда:
```
ausearch -c 'gitea' --raw | audit2allow -M my-gitea
semodule -X 300 -i my-gitea.pp
```

логин
gitrepo/P@ssw0rd

Настройка авторизации с AD (https://infoplex.ru/blog/posts/gitea-nastroyka-ldap-autentifikatsii/) достаточно просто:
1. создаем сервисную УЗ
![[Pasted image 20240414094622.png]]
2. Создаем группу пользователей
3. Настраиваем раздел Аутентификации
![[Pasted image 20240414094800.png]]
![[Pasted image 20240414094845.png]]
4. 