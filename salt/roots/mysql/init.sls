{% set root_password = pillar.get('root_password', salt['cmd.run']('openssl rand -base64 12')) %}
{% set client_password = pillar.get('client_password', salt['cmd.run']('openssl rand -base64 12')) %}
{% set replication_password = pillar.get('replication_password', salt['cmd.run']('openssl rand -base64 12')) %}

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
      root_password: "{{ root_password }}"
    - require:
      - file.directory: /var/cache/local/preseeding

debconf_mysql_seed:
  debconf.set_file:
    - source: file:/var/cache/local/preseeding/mysql-server.seed
    - require:
      - file: mysql_server_seed
