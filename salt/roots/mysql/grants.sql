GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, SHUTDOWN, PROCESS, FILE, REFERENCES, INDEX, ALTER, SHOW DATABASES, SUPER, CREATE TEMPORARY TABLES, LOCK TABLES, EXECUTE, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '{{ client_password }}' WITH GRANT OPTION;

GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%' identified by '{{ replication_password }}';

SET PASSWORD FOR 'root'@'localhost' = PASSWORD('{{ root_password }}');