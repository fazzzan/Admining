Отправляет show на устройство под управлением IOS и возвращает результат выполнения команды. Не работает в режиме конфигурирования. Перед отправкой команды модуль ios_command:
- выполняет аутентификацию по SSH    
- переходит в режим enable    
- выполняет команду `terminal length 0`, чтобы вывод команд show отражался полностью, а не постранично    
- выполняет команду `terminal width 512`
Выполнение одной команды
```
---
- name: YAMLPB1
  hosts: cisco_devices
tasks:

    - name: run sh ip int br
      ios_command:
        commands: show ip int br
      register: sh_ip_int_br_result

    - name: Debug registered var
      debug: var=sh_ip_int_br_result.stdout_lines
...      
```

  или несколько команд
```
---
- name: YAMLPB1
  hosts: cisco_devices

  tasks:

    - name: run show commands
      ios_command:
        commands:
          - show ip int br
          - sh ip route
      register: show_result

    - name: Debug registered var
      debug: var=show_result.stdout_lines
...      
```
Еще раз: параметр register находится на одном уровне с именем задачи и модулем, а не на уровне параметров модуля ios_command.

ios_command поддерживает параметры:
- **commands** - список команд, которые надо отправить на устройство    
- **wait_for** (или waitfor) - список условий, на которые надо проверить вывод команды. Задача ожидает выполнения всех условий. Если после указанного количества попыток выполнения команды условия не выполняются, будет считаться, что task выполнен неудачно.    
- **match** - этот параметр используется вместе с wait_for для указания политики совпадения. Если параметр match установлен в all, должны выполниться все условия в wait_for. Если параметр равен any, достаточно, чтобы выполнилось одно из условий.  
- **retries** - указывает количество попыток выполнения команды, прежде чем она будет считаться невыполненной. По умолчанию - 10 попыток.    
- **interval** - интервал в секундах между повторными попытками выполнить команду. По умолчанию - 1 секунда.

Модуль поддерживает обработку ошибок

# wait_for
Задает список условий, на которые надо проверить вывод команды.
```
---
  tasks:

    - name: run show commands
      ios_command:
        commands: ping 192.168.100.100
        wait_for:
          - result[0] contains 'Success rate is 100 percent'
```
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/13.jpg)
Если заданная строка в выводе не появится, и за время выполнения playbook команда не была выполнена
![](Admining/Linux/Ansible/Ansible_для_сетевых_инженеров/pictures/14.jpg)

У таймаута есть значения по-умолчанию:
- интервал для каждого task - 2 секунды, .
- число попыток - 10 попыток
Ниже приведен пример изменения дефолтных значений:
```
  tasks:

    - name: run show commands
      ios_command:
        commands: ping 192.168.100.5 timeout 1
        wait_for:
          - result[0] contains 'Success rate is 100 percent'
        retries:  2
        interval: 12
```
