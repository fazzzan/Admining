
# Проблемы с которыми столкнулся в докере AWX
## работа DNS
Не резолвятся имена нод, так как на DNS - сервере не было A-записей для нод.
Также сам DNS-сервер не был указан в файле. 
```
sudo nano /etc/resolv.conf
nameserver 192.168.1.1
```
Этого не будет, если DNS-сервер будет свой,  получаемый настройками вместе с ip от DHCP

## Проверка
1. Проверка какие контейнеры запущены
```
docker stats
docker stop tools_postgres_1
docker stop tools_redis_1
docker stop tools_awx_1
docker start tools_postgres_1
docker start tools_redis_1
docker start tools_awx_1
```


![[Pasted image 20240213161232.png]]
## Проверка существующих имиджей
2. Проверка существующих имиджей
`docker images`
![[Pasted image 20240213161304.png]]
## Подключение к контейнеру
3. Подключение к контейнеру
```
docker container attach [OPTIONS] tools_awx_1
docker exec -it tools_awx_1 sh

в привилегированном режиме
docker exec --user=0 -it tools_awx_1 bash
```

После чего в докере пришлось подключаться ко всем управляемым нодам, а может просто не разобрался.
![[Pasted image 20240213234944.png]]

## Запуск докера
4. Запуск докера
```
docker run -d --name topdemo alpine top -b
И потом
docker attach topdemo
```

```
sudo nano /etc/resolv.conf 
```
