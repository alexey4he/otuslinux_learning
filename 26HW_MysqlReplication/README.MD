```
- name: create dump for slave server
  mysql_db:
    login_user: root
    login_password: "{{ rootmysql }}"
    state: dump
    name: all
    ignore_tables: "{{ item }}"
    target: /home/vagrant/slave_bet.sql
  with_items: 
    - bet.events_on_demand
    - bet.v_same_event
```


```failed: [master] (item=bet.events_on_demand) => {"changed": false, "item": "bet.events_on_demand", "msg": "mysqldump: [Warning] Using a password on the command line interface can be insecure.\nWarning: A partial dump from a server that has GTIDs will by default include the GTIDs of all transactions, even those that changed suppressed parts of the database. If you don't want to restore GTIDs, pass --set-gtid-purged=OFF. To make a complete dump, pass --all-databases --triggers --routines --events. \nmysqldump: Got error: 1449: The user specified as a definer ('betscraper'@'%') does not exist when using LOCK TABLES\n"}```