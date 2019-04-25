# Почтовый сервер (Postfix + dovecot )

<details>
<summary> Задачи: </summary> 

1. Установить в виртуалке postfix+dovecot для приёма почты на виртуальный домен любым обсужденным на семинаре способом
2. Отправить почту телнетом с хоста на виртуалку
3. Принять почту на хост почтовым клиентом

Результат
1. Полученное письмо со всеми заголовками
2. Конфиги postfix и dovecot

</details>

# Выполнение 

Полученное письмо: 

```
[root@server Maildir]# cat /home/mailuser/Maildir/new/1556192560.V801I6007478M613375.server.otushw.local 
Return-Path: <alexey4he@otushw.local>
X-Original-To: mailuser@otushw.local
Delivered-To: mailuser@otushw.local
Received: from localhost (localhost [IPv6:::1])
        by server.otushw.local (Postfix) with SMTP id 3EF58B0FED
        for <mailuser@otushw.local>; Thu, 25 Apr 2019 14:41:51 +0300 (MSK)
subject: Hello Otus!
Message-Id: <20190425114200.3EF58B0FED@server.otushw.local>
Date: Thu, 25 Apr 2019 14:41:51 +0300 (MSK)
From: alexey4he@otushw.local

This is test messages, him create for telnet.
```
___

Проверил работу dovecot через почтовый клиент: 

![Evolution messages](/29_Postfix+Dovecot/evolution.png)

## Конфигурационный файлы postfix и dovecot: 
_____
1)  [Postfix](/29_Postfix+Dovecot/provision/roles/postfix-server/templates/main.cf.j2)
2) [Dovecot](29_Postfix+Dovecot/provision/roles/dovecot/templates/dovecot.conf.j2)