Домашнее задание

# Web сервера

<details>
<summary> Задачи: </summary> 

Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.
Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

Смысл: умные боты попадаются редко, тупые боты по редиректам с куками два раза не пойдут

</details>

_____________________________________________

# Выполнение

Задача оказалось легче, чем я думал. :)

Привел дефолтный конфиг к виду: 

```
server {
        listen       80;
        listen       [::]:80 default_server;
        server_name  localhost;
        root         /usr/share/nginx/html;
        access_log   /var/log/nginx/access.log;

        location / {
                if ($cookie_access != "otus") {
                   return 302 $scheme://$server_addr/cookie;
                }
        }


        location /cookie {
                add_header Set-Cookie "access=otus";
                   return 302 $scheme://$server_addr/;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }

```

При обращение на дефолтный локейшен первый раз клиента переадресовывает на другую страницу, *http://$server_addr/cookie* где ему присваем куки и снова переадресовываем на базовый локейшен. 

Честно говоря, с куками до этого не работал и особо не разбирался в связи с чем столкнулся с проблемой тестирования. По началу проверку делал так: 
 ```
 curl -I -L 192.168.11.20
 ```

В связи с чем получилал бесконечный редирект и еще удивлялся что происходит. Пришлось узлу добавить внешний сетевой интерфейс что бы глянуть через браузер. В браузере все нормально, значит я что то делаю не так с курлом. Изучив функционал, нашел ключ ```--cookie```. Добавляем его и получаем:

```
[alexey4he@localhost ~]$ curl -I -L --cookie '' 192.168.11.20
HTTP/1.1 302 Moved Temporarily
Server: nginx/1.12.2
Date: Sat, 02 Mar 2019 15:34:28 GMT
Content-Type: text/html
Content-Length: 161
Connection: keep-alive
Location: http://192.168.11.20/cookie

HTTP/1.1 302 Moved Temporarily
Server: nginx/1.12.2
Date: Sat, 02 Mar 2019 15:34:28 GMT
Content-Type: text/html
Content-Length: 161
Connection: keep-alive
Location: http://192.168.11.20/
Set-Cookie: access=otus

HTTP/1.1 200 OK
Server: nginx/1.12.2
Date: Sat, 02 Mar 2019 15:34:28 GMT
Content-Type: text/html
Content-Length: 3700
Last-Modified: Tue, 06 Mar 2018 09:26:21 GMT
Connection: keep-alive
ETag: "5a9e5ebd-e74"
Accept-Ranges: bytes

```

Все готово :)
