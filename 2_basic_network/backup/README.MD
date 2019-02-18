### Резервное копирование с помощью Bacula
___

# List jobs:

```
[root@bserver ~]# bconsole 
Connecting to Director localhost:9101
1000 OK: bacula-dir Version: 5.2.13 (19 February 2013)
Enter a period to cancel a command.
*
You have messages.
*list jobs 
Automatically selected Catalog: MyCatalog
Using Catalog "MyCatalog"
+-------+---------------------------+---------------------+------+-------+----------+-------------+-----------+
| JobId | Name                      | StartTime           | Type | Level | JobFiles | JobBytes    | JobStatus |
+-------+---------------------------+---------------------+------+-------+----------+-------------+-----------+
|     1 | Bacula Client for Otus HW | 2019-02-18 15:00:02 | B    | F     |        0 |           0 | E         |
|     2 | Bacula Client for Otus HW | 2019-02-18 15:10:02 | B    | F     |    2,391 |  10,360,981 | T         |
|     3 | BackupLocalFIle           | 2019-02-18 15:15:23 | B    | F     |   36,474 | 442,253,809 | T         |
|     4 | Bacula Client for Otus HW | 2019-02-18 15:20:18 | B    | I     |        0 |           0 | T         |
|     5 | Bacula Client for Otus HW | 2019-02-18 15:30:03 | B    | D     |        0 |           0 | T         |
|     6 | Bacula Client for Otus HW | 2019-02-18 15:40:03 | B    | I     |        0 |           0 | T         |
|     7 | Bacula Client for Otus HW | 2019-02-18 15:50:03 | B    | I     |        0 |           0 | T         |
|     8 | Bacula Client for Otus HW | 2019-02-18 16:00:03 | B    | D     |        0 |           0 | T         |
|     9 | Bacula Client for Otus HW | 2019-02-18 16:10:03 | B    | I     |        0 |           0 | T         |
|    10 | Bacula Client for Otus HW | 2019-02-18 16:20:02 | B    | I     |        0 |           0 | T         |
|    11 | Bacula Client for Otus HW | 2019-02-18 16:30:02 | B    | D     |        0 |           0 | T         |
|    12 | Bacula Client for Otus HW | 2019-02-18 16:40:03 | B    | I     |        0 |           0 | T         |
|    13 | Bacula Client for Otus HW | 2019-02-18 16:50:02 | B    | I     |        0 |           0 | T         |
|    14 | Bacula Client for Otus HW | 2019-02-18 17:00:02 | B    | D     |        0 |           0 | T         |
|    15 | Bacula Client for Otus HW | 2019-02-18 17:10:02 | B    | I     |        0 |           0 | T         |
|    16 | Bacula Client for Otus HW | 2019-02-18 17:20:02 | B    | I     |        0 |           0 | T         |
+-------+---------------------------+---------------------+------+-------+----------+-------------+-----------+

```
В первом джобе, еррор произошел по невнимательности. Забыл службу перезапустить после правок.
___

# list files jobid = {1 ... 6}:


[list files jobid](./jobid "jobid"). Т.к. данные на клиент в директории etc не менялись, я не стал прикладывать все списки. 

___

# 
[Server config](./bacula-serv-conf/ "server config")

[Client config](./bacula-client-conf/ "client config")
