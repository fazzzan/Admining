
формат файла - YAML. Внутри:
- play - задачи для группы хостов
- task - конкретная задача, внутри которой есть:
   - название
   - описание
   - модуль с командой

[ios_command.yaml](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\02_01\ios_command.yaml): 
[ios_command2.yaml](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\02_01\ios_command2.yaml): 
[ios_command3.yaml](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\02_01\ios_command3.yaml): 
[ios_command4.yaml](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\02_01\ios_command4.yaml): 


![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/05.jpg)

Хороший пример с двумя play и парой task
[ios_command7.yaml](E:\Study\GIT\Admining\Linux\Ansible\Ansible_для_сетевых_инженеров\configs\LABS\02_01\ios_command7.yaml)
Сценарии (play) и задачи (task) выполняются последовательно, в порядке определенном playbook-ом.
Если в сценарии, например, 2 task, то сначала для всех устройств из hosts выполняется 1-й task. После 1 task выполняется 2 task. При этом, если при работе playbook возникла ошибка в задаче на каком-то устройстве, это устройство исключается, и другие задачи на нём выполняться не будут.

![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/06.jpg)
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/07.jpg)
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/08.jpg)
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/09.jpg)

```
ansible-playbook -i myhosts.ini ios_command6.yaml -u admin -k
```

Параметр –limit позволяет ограничивать, для каких хостов или групп будет выполняться playbook, при этом не меняя сам playbook.
Например, только для маршрутизатора R3:

```
ansible-playbook ios_command7.yaml -u admin -k --limit R3
```

## Идемпотентность
Если, например, в task указано, что на сервер Linux надо установить httpd, то он будет установлен только в том случае, если его нет. То есть, действие не будет повторяться снова и снова при каждом запуске, а лишь тогда, когда пакета нет.
Аналогично и с сетевым оборудованием. Если задача модуля - выполнить команду в конфигурационном режиме, а она уже есть на устройстве, модуль не будет вносить изменения.