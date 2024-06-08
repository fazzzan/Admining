Тэги: #ansible #variables #facts
Ссылки: 

## Magic Variables
зарезервированные переменые
![[Pasted image 20240306000518.png]]
- hostvars - значения facts других хостов плейбука
`{{ hostvars['ansible2']['ansible_facts']['distribution'] }}`
- groups - список всех хостов в группе inventory
`{% for host in groups['webservers']%}`
- group_names - список групп к которым в inventory принадлежит хост
`{% if 'webservers' in group_names %}` 
- inventory_hostname или inventory_hostname_short - альтернатива `ansible_hostname`, в случае если отключен сбор фактов 