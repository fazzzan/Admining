Тэги: #ansible #playbook #variables 
Ссылки: 

## Задание переменных
### 1. в заголовке `playbook` разделе `vars`
 в заголовке `playbook` разделе `vars` - плохая практика, необходимо задавать эту переменную раз за разом, в каждом playbook (см. раздел ранее)
### 2. в заголовке `playbook` разделе `vars_files`
 2. в заголовке `playbook` разделе `vars_files` - файлы с переменными могут быть использованы в нескольких `playbook`
в заголовке `playbook` разделе `vars_files`:
![[Pasted image 20240302154224.png]]
```
myvars.yaml
mypackage: nmap
myftpservice: vsftpd
myfileservice: smb

playbook var_files, для REDOS - package, для UBUNTU - yum
---
- name: using a variable include file
  hosts: redos
  vars_files: myvars.yaml
  tasks:
  - name: install package
    package:
      name: "{{ mypackage }}"
      state: latest


Проверка 
ansible redos -m shell -a "rpm -qa | grep nmap"
```
В результате выполнения пакет может и не поставиться, если у ВМ нет доступа к ропозиторию
![[Pasted image 20240302155513.png]]

### 3. с использованием модуля `set_fact`
Этот модуль может быть использован где угодно в `play`, но применится этот факт только к хосту для которого он задан, то есть для другого хоста переменная не отработает. Преимущество от использования состоит в том, что в факт может быть занесен результат любого `task` `playbook`. Таким образом можно динамически переопределять переменную
```
---
- name: use set_fact in playbook
  hosts: localhost
  gather_facts: no
  tasks:
  - set_fact:
      myvar: myvalue777

- name: get set_fact in playbook
  hosts: localhost
  gather_facts: no
  tasks:
  - debug:
      msg: the value is {{ myvar }}

- name: get set_fact in playbook again
  hosts: localhost
  gather_facts: no
  tasks:
  - debug:
      msg: checking if set_fact is valid {{ myvar }}
...
```
![[Pasted image 20240303132340.png]]
### 4. в командной строке, с использованием опции `-e key=value`
 в командной строке, с использованием опции `-e key=value`
### 5. в файле `inventory`
в файле `inventory`
### 6. в переменных хоста или группы хостов
Переменные хоста или группы хостов - используются для задания конкретного свойства хоста, или общего свойства для группы хостов. Функционал получил 2-ю жизнь с TOWER. Использование переменных хоста или группы может запутать ситуацию при понимании того как работает плейбук.
Для работы с переменными хоста, создается:
- директория `host_vars` и в ней имя хоста с определенными переменными.
- директория `group_vars` с файлами содержащими переменные группы хостов.
![[Pasted image 20240303141141.png]]
![[Pasted image 20240303142134.png]]
В итоге будет выведено сообщение что создается пользователь заданный в переменной группы хостов, по имени группы.
![[Pasted image 20240303142301.png]]
### 7. запросить переменные через `vars_prompt`
Мы можем запросить переменные через `vars_prompt` в конкретном `play`. По-умолчанию переменная защищена флагом `private` и вводимые данные не видны.
- private: no - отменяет поведение по-умолчанию
Переменная может быть использована в `play`, в котором она инициализирована

## Ansible Vault
шифрование секретных данных


