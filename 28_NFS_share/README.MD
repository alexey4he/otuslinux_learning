# Файловые хранилища: NFS - share.

<details>
<summary> Задачи: </summary> 

Vagrant stand NFS или SAMBA
NFS или SAMBA на выбор:

vagrant up должен поднимать 2 виртуалки: сервер и клиент
на сервер должна быть расшарена директория
на клиента она должна автоматически монтироваться при старте (fstab или autofs)
в шаре должна быть папка upload с правами на запись
- требования для NFS: NFSv3 по UDP, включенный firewall

* Настроить аутентификацию через KERBEROS

</details>

# Выполнение 

В этот раз посторался сделать роли которые могут мне пригодиться в будующем.

В первую очередь, настраиваю на всех серверах time зону.
По умолчанию в используемом мной дистрибутиве отключен firewalld, по условию задания я его включаю и разрешаю все необходимые сервисы для работы стенда. 

<details>
<summary>Есть вопрос:</summary>
Сколько не пытался вынести список сервисов в переменную, и использовать ее в правиле вида: 

``` - name: add service to public zone firewall
  firewalld:
    permanent: yes
    state: enabled
    zone: public
    service: '{{ open_service_firewalld }}'
  notify: 
    - restart firewalld
```

 Получал ошибку вида:

```
fatal: [server]: FAILED! => {"changed": false, "msg": "ERROR: Exception caught: org.fedoraproject.FirewallD1.Exception: INVALID_SERVICE: '['nfs', 'mountd', 'ntp', 'dns', 'rpc-bind']' not among existing services Permanent operation, Services are defined by port/tcp relationship and named as they are in /etc/services (on most systems)"}
```
в тоже время в том виде в котором это реализованно у [меня](provision/roles/firewalld/tasks/main.yml), все работает
</details>

Дальше все довольно просто, ни каких особых вопросов не возникло, до момента провижина конфига на vagrant стенд. 
Т.к. я генерирую прямую и обратную днс зону динамически, мне нужно было что бы провижин начался после того как оба узла поднимутся.

Если не сложно, подскажите как по другому это можно было реализовать? 