При работе с сетевым оборудованием необходимо задавать различные параметры, относящиеся к работе разных модулей. Например, модуль для работы с сетевыми устройствами  ios_x, требует задания:
- ansible_network_os - например, ios, eos
- ansible_user - имя пользователя    
- ansible_password - пароль    
- ansible_become - нужно ли переходить в привилегированный режим (enable, для Cisco)    
- ansible_become_method - каким образом переходить в привилегированный режим    
- ansible_become_pass - пароль для привилегированного режима

Эти параметры, например network_cli, можно указывать в нескольких местах:
- [ инвентарном файле](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\01_05\myhosts.ini): `ansible_connection=network_cli`
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/03.jpg)
- файлах с перемеными (файл как правило в отдельном каталоге group_vars/all.yml)
```
ansible_connection: network_cli
ansible_network_os: ios
ansible_user: cisco
ansible_password: cisco
ansible_become: yes
ansible_become_method: enable
ansible_become_pass: cisco
```
- файле playbook (позже): `connection: network_cli`
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/04.jpg)
