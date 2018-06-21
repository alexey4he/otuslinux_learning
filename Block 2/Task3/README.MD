Домашнее задание

# VPN

<details>
<summary> Задачи: </summary> 


1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

3*. Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке

</details>


______________________________________________________
# Выполнение

1.  

Создал 2 группы серверов tun(**tunClient1; tunClient2**)
и Group2(**tapClient1; tapClient2**).

______________________________

### Tun *ipip*
- На **Group1** поднимем **tun ipip**. 

* На сервере **tunClient1** создадим тунель через **nmcli**:
`````
nmcli connection add \
    type ip-tunnel ifname tun0 mode ipip \
    remote 10.10.140.2 local 10.10.140.1 dev eth1 \
    -- ipv4.method manual ipv4.addresses 192.168.140.1 \
    ipv4.routes "192.168.140.1/24" ip-tunnel.mtu 1500 ip-tunnel.ttl 255
`````
* На сервере **tunClient2** создадим тунель с помощью **ip**:
````
ip tunnel add tun0 mode ipip remote 10.10.140.1 local 10.10.140.2 dev eth1 ttl 255
ip address add 192.168.140.2 peer 192.168.140.1/32 dev tun0
ip link set tun0 mtu 1500 up
````

### TAP

В данном случае у меня не получилось с помощью **nmcli** создать необходимую конфигурацию. На обоих машинах, соединение буду устанавливать через **ip**

* На сервере **tapClient1**:

````
ip link add tap1 type gretap local 10.10.150.1 remote 10.10.150.2 dev eth1
ip address add 192.168.0.1/30 dev tap1
ip link set tap1 up
````
* На сервере **tapClient2**:

````
ip link add tap1 type gretap local 10.10.150.2 remote 10.10.150.1 dev eth1
ip address add 192.168.0.2/30 dev tap1
ip link set tap1 up
````

 
