#!/bin/bash

ports="1111 2222 3333"
host="192.168.255.1"

for x in $ports
do
    nmap -Pn --host_timeout 201 --max-retries 0 -p $x $host
    sleep 1
done
ssh vagrant@${host}