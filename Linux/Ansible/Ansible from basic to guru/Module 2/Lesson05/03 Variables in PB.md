Тэги: #ansible #playbook #variables 
Ссылки: 

## Выделение переменных
Необходимо запомнить, что хранить переменных в YAML - плохая практика, так как это не позволит создать переносимый код
## Вызов переменнных
- Обращение к переменным происходит через конструкцию `{{ myvariables}}`
- Использование переменных в начале текста возможно через конструкцию с ковычками и фигурными скобками  `msg: "{{ myvariables}} is set"`
- Переменные могут использоваться в условиях when, в этом случае фигурные скобки опускаются.
- Переменные могут также браться из facts, собранных при запуске плейбука.

В результате выполнения примера ниже, 
> [!question]- ```01. пример использования переменных ``` >
>  ```
>---
>- name: create user using variable
>    hosts: all
>    vars:
>      user: lida
>    tasks:
>      name: create a user {{ user }} on host {{ ansible_hostname }}
>      user:
>        name: "{{ user }}"
>```

![[Pasted image 20240302140009.png]]
Видно, что в вывод названия задачи попало только значение `ansible1`, хотя плейбук отработал на обеих ВМ.
Можно налету поменять значение переменной, через ad-hoc команду `-e`:
```
ansible-playbook -i inventory variables_example.yaml -e user=bob
```

![[Pasted image 20240302140952.png]]
