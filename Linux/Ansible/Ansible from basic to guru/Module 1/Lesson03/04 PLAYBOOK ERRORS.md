Тэги: #ansible #playbook #ignore_errors
Ссылки: 

## ОШИБКИ
Ошибка является препятствием для дальнейшего выполнения любых заданий для этого хоста. Причиной этого служить аксиома: "Нормальное выполнение task зависит от нормального завершения предыдущего task"

Обойти эту аксиому поможет использование `ignore_errors: yes` в заголовке play. В этом случае выполнение может быть продолжено.

> [!question]- ```Обход ошибок ignore_errors ``` >
>  ```
>---
>- name: install start and enable httpd
>  hosts: all
>  ignore_errors: yes
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
>```

Без использования этой конструкции обработка для ноды ansible2 после первой ошибки была бы невозможно.
![[Pasted image 20240211000222.png]]
## ОТМЕНА ИЗМЕНЕНИЙ
Легко отменить изменения внесенные исполнением PLAYBOOK - невозможно. Единственный способ - попробовать написать PLAYBOOK отменяющий выполненные действия в обратном порядке.

