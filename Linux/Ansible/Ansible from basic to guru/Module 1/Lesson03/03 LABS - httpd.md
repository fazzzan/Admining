Тэги: #ansible #playbook
Ссылки: 

## ТЗ
![[Pasted image 20240209143852.png]]
## Исполнение
Имеем ввиду, что на разных ОС WEB-сервер называется по-разному:
- RHEL - https
- DEBIAN - apache (https://www.devopstricks.in/installing-apache-web-server-on-ubuntu-22-04-with-ansible/)

> [!question]- ```01. Скачиваем с git ``` >
>  ```
>git clone https://github.com/snadervanvugt/ansiblecvc
>```

02. Приводим в соответствие файлы inventory, ansible.cfg

> [!question]- ```03. Редактируем файл /etc/ansible/ansiblecvc/basics/install_and_start_httpd.yaml ``` >
>  ```
>---
>- name: install start and enable httpd
>  hosts: redos
>  tasks:
>  - name: install package
>    package:
>      name: httpd
>      state: latest
>  - name: start and enable service
>    service:
>      name: httpd
>      state: started
>      enabled: yes
>- name: install APACHE
>  hosts: ubuntu
>  tasks:
>  - name: install Apache
>    apt:
>      name: apache2
>      state: present
>  - name: start Apache
>    service:
>      name: apache2
>      state: started
>      enabled: yes
>```

Держим в голове, что хороший плейбук - индемпотентен.
Также помним, что запихнуть в 1 плейбук 50 тасков - категорически неправильно и трудно диагностируемо.

> [!question]- ```04. Редактируем и запускаем проверку run_and_test_httpd.yaml ``` >
>  ```
>---
>- name: install start and enable httpd
 > gather_facts: false
>  hosts: redos
>  tasks:
>  - name: install package
>    package:
>      name: httpd
>      state: latest
>  - name: start and enable service
>    service:
>      name: httpd
>      state: started
>      enabled: yes
>
>- name: install start and enable APACHE
>  gather_facts: false
>  hosts: ubuntu
>  tasks:
>  - name: install Apache
>    apt:
>      name: apache2
>      state: present
>  - name: start Apache
>    service:
>      name: apache2
>      state: started
>      enabled: yes
>
>- name: test httpd ansible1
>  become: False
>  gather_facts: false
>  hosts: localhost
>  tasks:
>  - name: test httpd access ansible1
>    uri:
>      url: http://ansible1/icons/apache_pb2.gif
>
>  - name: test httpd access ansible2
>    uri:
>      url: http://ansible2/icons/ubuntu-logo.png
>
>  - name: test httpd access ansible3
>    uri:
>      url: http://ansible3/icons/apache_pb2.gif
>```

