CREATE USER 'clusteradmin'@'%' IDENTIFIED BY 'clusterpass';
GRANT ALL PRIVILEGES ON *.* TO  'clusteradmin'@'%' WITH GRANT OPTION;
