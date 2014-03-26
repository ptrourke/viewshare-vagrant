include:
  - viewshare-dependencies

/var/cache/local/preseeding:
  file.directory:
    - user: mysql
    - group: mysql
    - dir_mode: 755
    - makedirs: True

mysql_server_seed:
  file.managed:
    - name: /var/cache/local/preseeding/mysql-server.seed
    - source: salt://mysql/mysql-server.seed
    - template: jinja
    - mode: 600
    - user: mysql
    - group: mysql
    - context:
      root_password: {{ pillar.get('root_password', 'root_password') }}
    - require:
      - file.directory: /var/cache/local/preseeding

debconf_mysql_seed:
  debconf.set_file:
    - source: file:/var/cache/local/preseeding/mysql-server.seed
    - require:
      - file: mysql_server_seed

/etc/mysql/conf.d:
  file.directory:
    - user: mysql
    - group: mysql
    - dir_mode: 755
    - makedirs: True

mysql_debian_conf:
  file.managed:
    - name: /etc/mysql/debian.cnf
    - source: salt://mysql/debian.cnf
    - template: jinja
    - mode: 600
    - user: mysql
    - group: mysql
    - context:
      client_password: {{ pillar.get('client_password', 'client_password') }}
    - require:
      - pkg: mysql-server

mysql_server_conf:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://mysql/my.cnf
    - mode: 755
    - user: mysql
    - group: mysql
    - require:
      - pkg: mysql-server

mysql_grant_file:
  file.managed:
    - name: /etc/mysql/grants.sql
    - source: salt://mysql/grants.sql
    - template: jinja
    - mode: 600
    - user: mysql
    - group: mysql
    - context:
      root_password: {{ pillar.get('root_password', 'root_password') }}
      client_password: {{ pillar.get('client_password', 'client_password') }}
      replication_password: {{ pillar.get('replication_password', 'replication_password') }}
    - require:
      - pkg: mysql-server
  cmd.wait:
    - name: mysql -u root < /etc/mysql/grants.sql
    - watch:
      - file: mysql_grant_file
  service:
    - name: mysql
    - running
    - reload: True
    - watch:
      - cmd: mysql_grant_file
