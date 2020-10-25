# после настройки подключения по SSH на образы IOL - может возникнуть ошибка:
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

# импорт сгенерированных на Cisco ключей:
ssh-copy-id cisco@192.168.48.191
```
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/fedor/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
Password: 
CThis device is private property. Access REstricted
Line has invalid autocommand "exec sh -c 'cd ; umask 077 ; mkdir -p .ssh && { [ -z `tail -1c .ssh/authorized_keys 2>/dev/null` ] || echo >> .ssh/authorized_keys ; } && cat >> .ssh/authorized_keys || exit 1 ; if type restorecon >/dev/null 2>&1 ; then restorecon -F .ssh .ssh/authorized_"Connection to 192.168.48.191 closed by remote host.

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'cisco@192.168.48.191'"
and check to make sure that only the key(s) you wanted were added.
```