include:
  - mysql
  - viewshare-dependencies

create_viewshare_database:
  file.managed:
    - name: /etc/mysql/create_database.sql
    - source: salt://viewshare/create_database.sql
    - template: jinja
    - mode: 600
    - user: mysql
    - group: mysql
    - context:
      client_password: {{ pillar.get('client_password', 'client_password') }}
  cmd.wait:
    - name: mysql -u root -p{{ pillar.get('root_password', 'root_password') }} < /etc/mysql/create_database.sql
    - watch:
      - file: create_viewshare_database
