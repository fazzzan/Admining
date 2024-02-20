Oct. 31, 2023
https://learning.oreilly.com/live-events/ansible-in-4-hours/0636920123842/

https://github.com/sandervanvugt/ansiblefundamentals

[Ansible для сетевых инженеров](https://ansible-for-network-engineers.readthedocs.io/ru/latest/book/01_basics/install.html)

![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/25.jpg)
Основы Ansible:
- Control node: Any machine (except Windows) with Ansible installed. can run commands and playbooks,
invoking /usr/bin/ansible or /usr/bin/ansible-playbook. We can use any computer that has Python
installed on it as a control node - laptops, shared desktops, and servers for running Ansible.
- Managed nodes: The network devices (and/or servers) that are managed with Ansible, are also called hosts.
Ansible is not installed on managed nodes.
- Inventory: The managed nodes are listed in an inventory file or sometimes called a hostfile. the
inventory can specify information like IP address for each managed node. An inventory can also
organize managed nodes by creating and nesting groups for easier scaling. Using an inventory file, such as the coming example, enables us to automate tasks for specific hosts and groups of hosts by
referencing the proper host/group using the hosts parameter that exists at the top section of each
play. It is also possible to store variables like the username and password within an inventory file.
Figure I.8, shows an example of an inventory file include two groups of cisco devices, IOS, and
NXOS, with specifying common variables.
- Modules: The units of code Ansible executes. Each module represents a particular use of task, from
administering users on a specific type of database to managing VLAN interfaces on a specific type
of network device. we can invoke a single module with a task, or invoke several different modules
in a playbook. There are four common network module and they are listed in following Table I.2
Table I. 2: Four main network devices module [31].

|Module | Description|
|---|---|
|command | Command modules run arbitrary commands on a network device.|
|config | Config modules allow configuration on the network device in a stateful way (idempotent)|
|facts| Fact modules return structured data about the network device|
|resource | Resource module can read and configure a specific resource on a network device.(e.g. VLAN).|

- Playbooks: The playbook is the top-level object that is executed to automate, it is an ordered list of Plays
and tasks saved, so it can run those tasks in that order repeatedly. Playbooks can include variables
as well as tasks, written in YAML (Yet Another Markup Language) and easy to read, write, share
and understand. Figure I.9, shows an example of a Playbook file that include one play and one task
for adding VLANs on a Cisco host
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/26.jpg)
- Play: One or more plays can exist within an Ansible playbook. In the previous Playbook example,
there are a single play within the playbook starts with a header section where play-specific
parameters are defined (name, hosts, and it may include the connection type). Each play is
comprised of one or more tasks.
- Tasks: The units of action in Ansible. We can execute a single task once with an ad-hoc command.
Tasks can also use the name parameter just as plays can. The next line after declaring the task
name in the example shown in Figure I.9, task starts with ios_vlan and it will execute the Ansible
module called ios_vlan.
- Templating: Ansible supports Jinja2 language which will be able to create templates that represent a
device’s configuration but with variables, as the example in Figure I.10.
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/27.jpg)


Конфигурирование файла hosts
```
  127  cat /etc/hosts
  128  nano /etc/hosts
```
https://serverastra.com/docs/Tutorials/Setting-Up-and-Securing-SSH-on-Ubuntu-22.04%3A-A-Comprehensive-Guide
> [!question]- ```1: Update the System``` Ubuntu 22>
>sudo apt update
>sudo apt upgrade

> [!question]- ```2: Install the OpenSSH Server``` >
>- Ubuntu 22 - ```sudo apt install openssh-server```
>- RedOS - ```dnf install openssh```

> [!question]- ```3: Configure Firewall Rules for SSH``` Ubuntu 22>
>```sudo ufw status```
>If UFW is inactive, enable it with the following command:
>```sudo ufw enable
>sudo ufw allow ssh```
>

Настройка демона SSH, очистка старых подключений по SSH
```
  138  nano /etc/ssh/ssh_config
  139  ssh-keygen -A
  140  service ssh restart
  
  157  nano /root/.ssh/known_hosts
  158  vi /root/.ssh/known_hosts
```


Для работы ANSIBLE необходим ряд дополнительного ПО и обновление ОС:
```
apt install nano
apt install mc
apt install sshpass
apt install pipx

sudo apt update
sudo apt upgrade

apt install ansible-core
pipx install --include-deps ansible
pipx ensurepath
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
sudo apt install python3-pip
pip install --user ansible-pylibssh
```
Настройка каталога с файлами, откуда будем запускать YAML файлы:
```
cd /etc/ansible/
```
Проверка того что есть или встало:
```
ansible --version
```
Установка модуей
```
ansible-galaxy collection list
ansible-galaxy collection install cisco.ios ---vvv
ansible-galaxy collection install theforeman.foreman -vvv
```







+ ansible R1 -i myhosts.ini -m ios_command -a "commands='sh ip int br'"
+ ansible R1 -i myhosts.ini -m ios_command -a "commands='who'"
ansible-playbook -i ./inventory ios_command.yaml -u admin -k


+ansible R1 -i myhosts.ini -c network_cli -e ansible_network_os=ios -u admin -k -m ios_command -a "commands='sh clock'"
+ansible R1 -m ios_command -a "commands='sh ip int br'"

ansible all --list-hosts - список хостов из файла ansible.cfg, параметр inventory 
[defaults]

inventory = ./myhosts.ini
remote_user = admin 
ask_pass = True
gathering = explicit
host_key_checking=False

При этом конфиг myhosts,ini связан с yaml файлом исполняемым командой 
ansible-playbook -i ./myhosts.ini ios_command.yaml -u admin -k
Название группы над которой выполняются действия - должны совпадать и в yaml и в ini.

Ограничение выполнения только для конкретного узла из инвентарного файла
+ ansible-playbook -i ./myhosts.ini ios_command3.yaml -u admin -k --limit R2