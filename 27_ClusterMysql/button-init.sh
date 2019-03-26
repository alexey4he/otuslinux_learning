#!/bin/bash

docker-compose up -d 

sleep 90

docker-compose exec mysqlnode1 mysqlsh clusteradmin@mysqlnode1:3306 -pclusterpass -- dba create-cluster otus

docker-compose exec mysqlnode1 mysqlsh clusteradmin@mysqlnode1:3306 -pclusterpass -- cluster add-instance clusteradmin@mysqlnode2 --password=clusterpass

docker-compose exec mysqlnode1 mysqlsh clusteradmin@mysqlnode1:3306 -pclusterpass -- cluster add-instance clusteradmin@mysqlnode3 --password=clusterpass


docker-compose up -d mysqlrouter