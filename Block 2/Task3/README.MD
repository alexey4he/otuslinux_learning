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

1. Создал 2 группы серверов Group1(**group1Client1; group1Client2**) 
   и Group2(**group2Client1; group2Client2**).

______________________________

- На **Group1** поднимем **tun ipip**. 

* На сервере **group1Client1** создадим интерфейс с помощью **nmcli**:
`````
nmcli connection add \
    type ip-tunnel ifname tun0 mode ipip \
    remote 10.10.140.2 local 10.10.140.1 dev eth1 \
    -- ipv4.method manual ipv4.addresses 192.168.140.1 \
    ipv4.routes "192.168.140.1/24" ip-tunnel.mtu 1500 ip-tunnel.ttl 255
`````
* На сервере **group1Client2** создадим интерфейс с помощью **iproute2**:
````
ip tunnel add tun0 mode ipip remote 10.10.140.1 local 10.10.140.2 dev eth1 ttl 255
ip address add 192.168.140.2 peer 192.168.140.1/32 dev tun0
ip link set tun0 mtu 1500 up
````

**тунель поднят** остался 1 вопрос. После поднятия туненля без разницы через **nmcli/ip** появляется мистический:
````
tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0

````
что это?
