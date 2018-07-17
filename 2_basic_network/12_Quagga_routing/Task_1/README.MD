*Поднять OSPF между машинами на базе Quagga*

Поднял 3 машины ABR{1,2,3}. 
  
  Вывод **ip a**  *ABR1*:

````
  [vagrant@ABR1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 84188sec preferred_lft 84188sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:d3:f3:49 brd ff:ff:ff:ff:ff:ff
    inet 10.0.10.1/24 brd 10.0.10.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fed3:f349/64 scope link
       valid_lft forever preferred_lft forever
4: vlan16@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue stateUP group default qlen 1000
    link/ether 08:00:27:d3:f3:49 brd ff:ff:ff:ff:ff:ff
    inet 172.16.16.10/30 brd 172.16.16.11 scope global noprefixroute vlan16
       valid_lft forever preferred_lft forever
    inet6 fe80::43e:dd54:a4a2:419e/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue stateUP group default qlen 1000
    link/ether 08:00:27:d3:f3:49 brd ff:ff:ff:ff:ff:ff
    inet 172.16.12.10/30 brd 172.16.12.11 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::8e99:f637:18f7:c121/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
````

  Вывод **ip a**  *ABR2*:

````
[vagrant@ABR2 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 83573sec preferred_lft 83573sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:8c:81:6e brd ff:ff:ff:ff:ff:ff
    inet 10.0.20.1/24 brd 10.0.20.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe8c:816e/64 scope link
       valid_lft forever preferred_lft forever
4: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:8c:81:6e brd ff:ff:ff:ff:ff:ff
    inet 172.16.12.9/30 brd 172.16.12.11 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::5315:a676:4dab:190b/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: vlan20@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:8c:81:6e brd ff:ff:ff:ff:ff:ff
    inet 172.16.20.10/30 brd 172.16.20.11 scope global noprefixroute vlan20
       valid_lft forever preferred_lft forever
    inet6 fe80::a90:e3c4:9aec:c19d/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
````
  Вывод **ip a**  *ABR3*:

````
[vagrant@ABR3 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 83377sec preferred_lft 83377sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:9e:8d:3a brd ff:ff:ff:ff:ff:ff
    inet 10.0.30.1/24 brd 10.0.30.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe9e:8d3a/64 scope link
       valid_lft forever preferred_lft forever
4: vlan20@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:9e:8d:3a brd ff:ff:ff:ff:ff:ff
    inet 172.16.20.9/30 brd 172.16.20.11 scope global noprefixroute vlan20
       valid_lft forever preferred_lft forever
    inet6 fe80::eeb3:a52f:cc4c:f11c/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: vlan16@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:9e:8d:3a brd ff:ff:ff:ff:ff:ff
    inet 172.16.16.9/30 brd 172.16.16.11 scope global noprefixroute vlan16
       valid_lft forever preferred_lft forever
    inet6 fe80::f785:a816:1208:ec5f/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
````