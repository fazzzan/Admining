Тэги: #ansible #variables #facts
Ссылки: 

Dict. vs Arrays - разные способы хранения, основанные на концепции Python
## Dictionary
Словарь или хэш - неупорядоченная коллекция значений, которая хранится в виде пары `key-value`
![[Pasted image 20240305231755.png]]
Обращение к словарю происходит целиком, без возможности выделить его элемент
## Array
Известен как список значений, к каждому значению можно обратиться индивидуально
![[Pasted image 20240305231608.png]]

## Multi-valued variables
В плейбуке могут использоваться переменные из множества значений, которые могут существовать либо в виде Array, либо в виде Dictionary. Способ хранения данных индивидуален в каждом случае:
 - Dict - это способ хранения fact - записывается в виде {}
 ![[Pasted image 20240305233945.png]]
 - Arr - чаще переменные из множества значений в виде Array, записывается в виде []
 ![[Pasted image 20240305233438.png]]
 Еще различия между этими объектами:
 ![[Pasted image 20240305234509.png]]
 Оба варианта хранения поддерживают `Loops` (циклы), которые в свою очередь используются совместно с условиями. Есть мальнокое НО: Dict не работает напрямую с Loop, только через функцию `dict2items`.
![[Pasted image 20240305233756.png]]

Встречаются варианты с массивами списков и со списками массивов.
Пример плейбуков для работы:
массив
```
---
- name: show lists also known as arrays
  hosts: ansible1
  vars_files:
    - vars/users-list
  tasks:
    - name: print array values
      debug:
        msg: "User {{ item.username }} has homedirectory {{ item.homedir }} and shell {{ item.shell }}"
      loop: "{{ users }}"
    - name: print the second array value
      debug:
        msg: the second item is {{ users[1] }} 
```

список - тут невозможно напрямую прибегнуть к функции loop
```
---
- name: show dictionary also known as hash
  hosts: ansible1
  vars_files:
    - vars/users-dictionary
  tasks:
    - name: print dictionary values
      debug:
        msg: "User {{ users.linda.username }} has homedirectory {{ users.linda.homedir }} and shell {{ users.linda.shell }}"
```

![[Pasted image 20240305234841.png]]

