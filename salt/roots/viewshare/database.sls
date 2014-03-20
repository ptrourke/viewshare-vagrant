include:
  - mysql
  - viewshare-dependencies

{% set root_password, client_password, replication_password = salt['cmd.run']('cat /etc/mysql/saltstore').split() %}

create_viewshare_database:
  file.managed:
    - name: /etc/mysql/create_database.sql
    - source: salt://viewshare/create_database.sql
    - template: jinja
    - mode: 600
    - user: mysql
    - group: mysql
    - context:
      client_password: "{{ client_password }}"
  cmd.wait:
    - name: mysql -u root -p{{ root_password }} < /etc/mysql/create_database.sql
    - watch:
      - file: create_viewshare_database
