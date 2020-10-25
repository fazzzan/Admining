после настройки подключения по SSH на образы IOL - может возникнуть ошибка:
```
fedor@s-mon:/srv$ ssh -l cisco 192.168.48.191
Unable to negotiate with 192.168.48.191 port 22: no matching key exchange method found. Their offer: diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1
```
Ошибка связана с тем, что в новой версии отключена поддержка старых алгоритмов шифрования. Исправить это можно раскомментировав соответствующие разделы ssh_config
```
sudo vim /etc/ssh/ssh_config
...
   Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-cbc,3des-cbc
...
    KexAlgorithms diffie-hellman-group1-sha1,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1
```