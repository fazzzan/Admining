Модуль ios_config - используется для отправки команды глобального конфигурационного режима через использование параметра lines (alias - слова _commands_, то есть, можно вместо _lines_ писать _commands_). 
Пример:
```
---
- name: Run cfg commands on routers
  hosts: cisco_devices

  vars:
  ## some vars wright here

  tasks:
    - name: PB_TO_SET_YUSER_PASSWORD
      ios_config:
        lines:
          - service password-encryption
...
```

```
---
- name: Run cfg commands on routers
  hosts: cisco_devices

  tasks:
    - name: Disable CDP
      ios_config:
        lines:
          - no cdp run
...
```