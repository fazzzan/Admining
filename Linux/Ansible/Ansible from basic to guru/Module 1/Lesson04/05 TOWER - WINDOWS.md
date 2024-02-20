Тэги: #tower #awx 
Ссылки: 
## ТРЕБОВАНИЯ ДЛЯ ВЗАИМОДЕЙСТВИЯ С WINDOWS
См. LESSON1

## БАЗОВАЯ НАСТРОЙКА
1. Добавил inventory для WIN
![[Pasted image 20240214091030.png]]
2. Добавил в winventory группу
![[Pasted image 20240214093617.png]]
![[Pasted image 20240214093635.png]]
![[Pasted image 20240214093813.png]]

3. Добавил в winventory хосты
![[Pasted image 20240214091536.png]]
![[Pasted image 20240214091641.png]]

3. Добавляем переменные
```
ansible_connection: winrm
ansible_winrm_server_cert_validation: ignore
```
Пока никаких других переменных не добавляем.
![[Pasted image 20240214094251.png]]
4. Добавим группу для хостов (группы создаются в inventory winventory)
![[Pasted image 20240214162134.png]]
5. Назначим хосту группу
![[Pasted image 20240214094412.png]]
![[Pasted image 20240214094429.png]]

![[Pasted image 20240214161705.png]]

6. добавим credentials тип machine
![[Pasted image 20240214162442.png]]

7. Создадим новый MyProjects  и обновим его. Проект нам нужен чтобы создать связь с репозиторием проектов
`https://github.com/sandervanvugt/tower`

![[Pasted image 20240214163805.png]]

8.  Создадим новый template, создадим ссылку на playbook и запустим его
![[Pasted image 20240214170917.png]]
 
 ![[Pasted image 20240214164942.png]]
 ![[Pasted image 20240214165141.png]]
 
Все сработало, так как среда была готова
![[Pasted image 20240214171100.png]]

2. 