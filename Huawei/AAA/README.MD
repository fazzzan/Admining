# Настройки AAA

на SW
Настройки
Добавление локальных пользователей:

```
local-user admin password irreversible-cipher <SECRET_ADMIN_PASSWORD>
 local-user admin privilege level 15
 local-user admin service-type terminal http
 local-user netadmin password irreversible-cipher <SECRET_NETADMIN_PASSWORD>
 local-user netadmin privilege level 15
 local-user netadmin service-type terminal ssh
...
ssh user admin
ssh user admin authentication-type password
ssh user admin service-type all
ssh user netadmin
ssh user netadmin authentication-type password
ssh user netadmin service-type all
```

Заменить на свои значения <AUTH>, <TEMPLATE_RADIUS>, <DOMAIN_NAME>
```
aaa
 authentication-scheme default
 authentication-scheme radius
  authentication-mode radius
 authentication-scheme <AUTH>
  authentication-mode local radius
 authorization-scheme default
 accounting-scheme default
 local-aaa-user password policy administrator
  password expire 0
 domain default
  authentication-scheme default
  radius-server default
 domain default_admin
  authentication-scheme <AUTH>
  authorization-scheme default
  radius-server <TEMPLATE_RADIUS>
 domain <DOMAIN_NAME>
  authentication-scheme <AUTH>
  radius-server <TEMPLATE_RADIUS>
...
...
radius-server template <TEMPLATE_RADIUS>
 radius-server shared-key cipher <Pa55w0rd>
 radius-server authentication <NPS_IP_ADDR> 1812 weight 80
 undo radius-server user-name domain-included
radius-server authorization <NPS_IP_ADDR> shared-key cipher <Pa55w0rd2>
...
user-interface vty 0 4
 authentication-mode aaa
 user privilege level 15
 protocol inbound all
```

Настройки NPS:
1. Регистрируем Switch
![](PICTURES/NPS0.jpg)
2. Настраиваем Policy
![](PICTURES/NPS1.jpg)
![](PICTURES/NPS2.jpg)
![](PICTURES/NPS3.jpg)
![](PICTURES/NPS4.jpg)