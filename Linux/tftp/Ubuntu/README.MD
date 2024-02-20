# Настройка tftp

Установка
```   
	5  apt install xinetd tftpd tftp
    6  echo > /etc/xinetd.d/tftp
```
Настройка конфига
[cat /etc/xinetd.d/tftp](configs/tftp)
```    7  apt install nano
    8  nano /etc/xinetd.d/tftp
```
Создание рабочего каталога 
``` 
   12  cd /var
   13  mkdir tftpboot
   14  chmod 777 tftpboot/
   15  chown -R nobody /tftpboot
   16  chown -R nobody tftpboot
   17  chmod -R 777 tftpboot/
   18  ls -lah
   ```
Перезапуск и редактирование первого файла, тиражирование файла
   ```19  nano /etc/xinetd.d/tftp
   20  sudo service xinetd restart
   21  ls -lah
   22  cd tftpboot
   23  nano R1-confg
   44  for f in R{2..7}-confg; do cp R1-confg $f; done
   45  ls -lah
```
тестирование закачки
```
   24  ip a
   25  tftp 192.168.10.131
```
