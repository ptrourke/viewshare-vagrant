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

akara_conf:
  file.managed:
    - name: /opt/akara/akara.conf
    - source: salt://akara/akara.conf
    - template: jinja
