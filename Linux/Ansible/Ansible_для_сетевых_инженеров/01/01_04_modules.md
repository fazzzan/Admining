Модули Ansible, как правило, отвечает за свою конкретную и небольшую задачу. При работе ad-hoc команды - работает модуль. Модули можно собирать в определенный сценарий (play), а затем в playbook. 
Модулям передают аргументы, чтобы:
- управлять поведением
- передать на выполнение команду 
Например, модулю _ios_command_ передаем команду для выполнения  "commands='sh ip int br'"_:
```
ansible 192.168.100.1 -m ios_command -a "commands='sh ip int br'"
```
Для task из playbook аналогичная команда будет выглядеть:
```
  tasks:
    - name: Run multiple commands on Cisco IOS XE nodes
      ios_command:
        commands:
          - show ip int br
```

Результат выполнения модуля в JSON
