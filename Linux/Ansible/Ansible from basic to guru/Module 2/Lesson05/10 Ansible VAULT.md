Тэги: #ansible #variables #facts #vault
Ссылки: 

## Vault
Данные чувствительные к потере - необходимо шифровать. Для этого служит команда `ansible-vault`. При его помощи файл yaml шифруется, и надо будет говорить ansible расшифровать его
Порядок использования команды
![[Pasted image 20240306223155.png]]
- ansible-vault create secret.yml - создание зашифрованного файла, при этом шифрование надежное, поэтому можно размещать зашифрованный файл на github. На этот файл можно ссылаться в YAML плейбуке
![[Pasted image 20240306224105.png]]
![[Pasted image 20240306224027.png]]
Если запустить теперь плейбук то выдаст ошибку относительно отсутствия пароля `vault`, запускать надо правильно
![[Pasted image 20240306225626.png]]
 - `ansible-playbook --ask-vault-pass create_user.yaml`
 Пользователь создан: ![[Pasted image 20240306230134.png]]
 
 ```
# ansible all -a "tail -1 /etc/shadow"

ansible2 | CHANGED | rc=0 >>
bobbob:password:19788:0:99999:7:::
ansible1 | CHANGED | rc=0 >>
bobbob:password:19785:0:99999:7:::
ansible3 | CHANGED | rc=0 >>
bobbob:password:19785:0:99999:7:::
```
 Быстро надоесть вводить пароль, поэтому 
 - задать vault пароль можно командой
`echo P@ssw0rd > vault-pass` и вызывать эту команду 
 - `ansible-playbook --vault-pass-file=vault-pass create_user.yaml`