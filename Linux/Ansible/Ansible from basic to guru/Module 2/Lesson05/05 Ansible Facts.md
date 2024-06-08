Тэги: #ansible #variables #facts
Ссылки: 

## Facts
Факты - это информация автоматически получаемая самим Ansible с управляемых машин
- модулем `setup ` при использовании `ad-hoc` - старый подход к сбору фактов. Сохраняет каждое значение в отдельную переменную (инжектированная переменная)
```
ansible ansible1 -m setup > ansible1.txt  
```
![[Pasted image 20240303150522.png]]
- в плейбуке(если этот функционал не был отключен принудительно) - новый подход к сбору фактов
![[Pasted image 20240303145624.png]]
```
---
- name: playbook to gather facts from all
  hosts: lin 
  tasks:
  - name: show all facts
    debug:
      var: ansible_facts
```

![[Pasted image 20240304231703.png]]

- использовании модуля `package_facts`
