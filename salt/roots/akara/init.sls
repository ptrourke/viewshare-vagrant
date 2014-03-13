include:
  - viewshare-dependencies

akara_group:
  group.present:
    - name: akara
    - system: True

akara_user:
  user.present:
    - name: akara
    - shell: /bin/false
    - system: True
    - groups:
      - akara
    - require:
      - group: akara

/opt/akara/caches:
  file.directory:
    - user: akara
    - group: akara
    - dir_mode: 755
    - makedirs: True
    - require:
      - user: akara

/var/log/akara:
  file.directory:
    - user: akara
    - group: akara
    - dir_mode: 770
    - require:
      - user: akara

/opt/akara/logs:
  file.symlink:
    - target: /var/log/akara
    - require:
      - file: /var/log/akara

akara_virtualenv:
  virtualenv.managed:
    - name: /opt/akara
    - requirements: salt://akara/requirements.txt

akara_conf:
  file.managed:
    - name: /opt/akara/akara.conf
    - source: salt://akara/akara.conf
    - template: jinja

geonames_db:
  file.managed:
    - name: /opt/akara/caches/geonames.sqlite3
    - source: http://dl.dropbox.com/u/19247598/Akara/geonames.sqlite3
    - source_hash: md5=f1ed1bb03370932d367e76013bef8218

akara_own_mod:
  file.directory:
    - name: /opt/akara
    - user: akara
    - group: akara
    - recurse:
      - user
      - group
    - require:
      - user: akara
      - group: akara
      - virtualenv: akara_virtualenv
      - file: akara_conf
      - file: geonames_db

akara_service_init:
  file.managed:
    - name: /etc/init.d/akara
    - source: salt://akara/akara_init
    - mode: 755

akara:
  service:
    - running
    - enable: True
    - require:
      - file: akara_service_init

akara_logrotate:
  file.managed:
    - name: /etc/logrotate.d/akara
    - source: salt://akara/akara_logrotate
    - mode: 755

rsyslog:
  service:
    - running
    - reload: True
    - watch:
      - file: akara_logrotate
