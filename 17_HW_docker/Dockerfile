FROM alpine:latest

RUN apk update \
    && apk upgrade \
    && apk add nginx \
    && mkdir -p /usr/share/nginx/html

COPY ./file/html/* /usr/share/nginx/html/ 
COPY ./file/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./file/nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]