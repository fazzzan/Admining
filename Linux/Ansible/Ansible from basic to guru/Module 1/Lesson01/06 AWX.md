Тэги: #ansible #assets #modules #Inventory #ad-hoc #AWT
Ссылки: 
## Установка AWX
AWX - форк TOWER - RHEL комплекса управление скриптами ANSIBLE  [пример установки](https://habr.com/ru/companies/pixonic/articles/352184/)

> [!question]- ```01. Проверяем и устанавливаем openssl, Ansible Centos STREAM 9```>
>```
>sudo yum install epel-release
>sudo yum update
>sudo yum install -y yum-utils
>sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
>
># OPENSSL
>sudo yum install openssl
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##openssl version
>##OpenSSL 3.0.7 1 Nov 2022 (Library: OpenSSL 3.0.7 1 Nov 2022)
>
># PYTHON
>python -V
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##python3 -m pip -V - /usr/bin/python3
>##/usr/bin/python3: No module named pip
>sudo yum install python3
>sudo yum install python3-pip
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##python3 -m pip -V
>##pip 21.2.3 from /usr/lib/python3.9/site-packages/pip (python 3.9)
>
># ANSIBLE
>python3 -m pip install --user ansible
>sudo su
>python3 -m pip install --user ansible
>ansible --version
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##ansible --version
>##ansible [core 2.15.9]
>
># SSHPASS
>sudo yum install sshpass 
>
># GIT (https://unixcop.com/how-to-install-git-on-centos-9-stream-fedora/)
>sudo yum install git
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##git --version
>##git version 2.43.0
>
># DOCKER
>sudo dnf update -y
>##При необходимости удаляем старое
>## sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
>##sudo yum remove docker-ce-3 docker-ce-cli-1 docker-buildx-plugin-0.12.1-1.el9.x86_64 docker-compose-plugin-2.24.5-1.el9.x86_64 containerd.io-1.6.28-3.1.el9.x86_64>
>sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
>sudo usermod -aG docker administrator
>logout
>systemctl enable --now docker
>sudo systemctl status docker
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##docker --version
>##Docker version 25.0.2, build 29cf629
>
># DOCKER-COMPOSE (Python module)
>sudo python3 -m pip install docker-compose
>sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##docker-compose --version
>##docker-compose version 1.29.2, build unknown
>
># DOCKER COMPOSE (plugin)
>sudo yum install docker-compose-plugin
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##docker compose version
>##Docker Compose version v2.24.5
>
># PYTHON2-SETUPTOOLS_SCM
>sudo yum --enablerepo=crb install python3-setuptools_scm
>
># NPM
>sudo yum install npm
>
># MAKE
>sudo yum -y install make
>## проверку работосопособности делаем как от текущего пользователя, так и от sudo su
>##make --version
>##GNU Make 4.3
>
># AWX
>mkdir git
>cd git
>git clone --depth 1 https://github.com/ansible/awx
>#git clone -b 23.7.0 https://github.com/ansible/awx.git
>cd awx
>#nano tools/docker-compose/inventory
>cp tools/docker-compose/inventory tools/docker-compose/inventory_bak
>echo pg_password="Qwerty123" >> tools/docker-compose/inventory
>echo broadcast_websocket_secret="Qwerty123" >> tools/docker-compose/inventory
>echo secret_key="Qwerty123" >> tools/docker-compose/inventory
>make docker-compose-build
>cp Makefile{,.orig}
>sed -i 's/^\(DOCKER_COMPOSE ?=\).*/\1 docker compose/' Makefile
>docker images
>####docker stats
>####docker stop CONTAINER 
>make docker-compose 
>
># Проверяем что AWX запустился, но без рабочего GUI (https://osslab.tw/books/ansible/page/ansible-gui) `https://server.ip.adress:8043/`
>```<% if (process.env.NODE_ENV === 'production') { %> <% } %> <% if (process.env.NODE_ENV === 'production') { %> <% } else { %> <% } %> <% if (process.env.NODE_ENV === 'production') { %>```
>
># Clean and build the UI
>docker exec tools_awx_1 make clean-ui ui-devel
>
>#Создаем AWX пользователя, с правами
>docker exec -ti tools_awx_1 awx-manage createsuperuser
>
>#Делаем контейнеры автозапускаемыми
>docker update --restart unless-stopped tools_awx_1
>docker update --restart unless-stopped tools_postgres_1
>docker update --restart unless-stopped tools_redis_1
>
># Проверяем что контейнеры запущены
>sudo docker stats
>
># Не делал автонаполнение данными AWX
>##docker exec tools_awx_1 awx-manage create_preload_data

## Установка без докеров на CENTOS7
https://yallalabs.com/linux/how-to-install-ansible-awx-without-docker-centos-7-rhel-7/

## Проблемы, с которыми столкнулся при настройке и смене сети:
- AWX не развертывает имена из файла /etc/hosts на локальном хосте. Необходимо чтобы отвечал сторонний DNS - сервер
- WINDOWS DNS сервер отвечает на запрос, только если в свойствах домена указан сконфигурированный scope
![[Pasted image 20240301202236.png]]
для REDOS, Centos9 (https://access.redhat.com/documentation/ru-ru/red_hat_enterprise_linux/9/html/configuring_and_managing_networking/configuring-the-order-of-dns-servers_configuring-and-managing-networking) отредактировать DNS надо так:
```
nmcli -p c
sudo nmcli -p connection edit "Проводное подключение 1"
nmcli> remove ipv4.dns
nmcli> set ipv4.dns 192.168.48.11
nmcli> set ipv4.dns-search test.local
nmcli> set ipv4.dns-priority 10
nmcli> print
nmcli> save
nmcli> quit

systemctl restart NetworkManager

cat /etc/resolv.conf
```
для UBUNTU 22 отредактировать DNS надо так:
```
cd /etc/netplan
vi 00-installer-config.yaml

# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      dhcp4: true
      nameservers:
        addresses:
          - 192.168.48.10
        search:
          - test.local
  version: 2

netplan apply
resolvectl status
```


