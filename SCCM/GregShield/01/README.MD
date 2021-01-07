# Вводная часть
Сертификация - 70-703

Задачи обучения:
   - Разработка и установка Primary Site
   - Слегка коснуться Multi-Site вариантов эксплуатации
   - Queries/Reports
   - Развертывание Soft, Updates, Operation systems
   - Распространение SCCM на Internet устройства (DMZ/Firewall)
   - Интеграция SCCM и MS Intune

![](./pictures/01.jpg)

# Лаборатория
 - подготовка VM
 - Конфигурирование PKI/ADCS
 - Развертывание/Автоустановка Certificates 

## Инфораструктура стенда
6 VM: 
2016: DC (домен, форрест), ConfigMGR (primary site сервер), File1 (fileserver),
Win10: Mydesktop, UserDesktop, Packager (для снапшотов)

![](./pictures/02.jpg)

Сетевая часть:
192.168.3.0/24 - Production
xxx - NAT сеть

DC: 192.168.3.100, ConfigMGR: 192.168.3.150; File1: 192.168.3.160
Mydesktop: 192.168.3.99; Userdesktop: dhcp; Packasger: dhcp

Internal AD domain: company.pri
External AD domain companydotpri.com
Azure AD domain: companydotpri.onmicrosoft.com

1. Установка 3 VM 2016; 3 VM 10 1803+
   - Сделал 2016Template расклонировал 3 VM, нарезал ip
   - Сделал Win10TemplateLTSB-1607, Win10Template-LTSC, надо сделать template Win8.1
2. firewall: разрешить все
   - GPO с DC: 
```
default Domain Policy
   - Конфигурация компьютера;
    - Политики -> Административные шаблоны -> Сеть -> Сетевые подключения -> Брандмауэр Windows -> Профиль домена -> - Брандмауэр Windows: Защита всех сетевых подключений -> Отключено
```   
3. DC: DNS, DHCP, ADDS
   - Ставим ADDS, затем promotion to DC и настраиваем DNS:
   - level Server 2012 R2
   - pass P@ssw0rd
   - netbios COMPANY
   - REBOOT
   - DHCP
При вводже в домен напаролся на одинаковые SID: Пуск -> Выполнить -> sysprep

![](./pictures/03.jpg)

5. ADCS+templates - пункт не по-порядку, но по духу видео ))
   - На DC ставим Authority сервис
   - PostConfigure - настройка роли RootCA

![](./pictures/04.jpg)

![](./pictures/05.jpg)

![](./pictures/06.jpg)
![](./pictures/08.jpg)

   - Настроить templates (в данном курсе 4 типа templates)
     - WebServer templates: для любого http-ориентировнного сервера с какой-либо установленной ролью SCCM (Management Point; Distribution Point, Software Update Point, State migration Point) - они все используют IIS механизм для передачи информации на другие машины, или клиенты. HTTPS использует аутентификацию. не позволяет выгружать private ключи
     - Web Server with Private Key - для AZURE, как я понял, позволяет выгружатиь private ключи
     - workstation authentication template - автоматически раскатываеvst сертификаты на WS через GPO, также не позволяет выгружать private key
     - workstation authentication with private key template - для выгрузки private key

![](./pictures/07.jpg)

4. ConfigMGR: SQL server 2016+SRSS; WSUS





