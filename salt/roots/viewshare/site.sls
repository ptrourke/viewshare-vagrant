include:
  - viewshare.database
  - viewshare-dependencies

{% set root_password, client_password, replication_password = salt['cmd.run']('cat /etc/mysql/saltstore').split() %}

/var/www/cache/tmp:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - makedirs: True

/var/www/cache:
  file.directory:
    - user: www-data
    - group: www-data
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode

/srv/viewshare/shared/static:
  file.directory:
    - user: nobody
    - group: nogroup
    - dir_mode: 755
    - makedirs: True

viewshare_site_repo:
  git.latest:
    - name: https://github.com/zepheira/viewshare_site.git
    - rev: master
    - target: /srv/viewshare/current
    - require:
      - file: /srv/viewshare

viewshare_virtualenv:
  virtualenv.managed:
    - name: /srv/viewshare/shared/env
    - cwd: /srv/viewshare/current
    - requirements: file:/srv/viewshare/current/requirements.txt
    - require:
      - git: viewshare_site_repo

/srv/viewshare:
  file.directory:
    - user: nobody
    - group: nogroup
    - dir_mode: 755
    - recurse:
      - user
      - group
      - mode

/srv/viewshare/shared/viewshare_site_settings.py:
  file.managed:
    - source: salt://viewshare/viewshare_site_settings.py
    - user: nobody
    - group: nogroup
    - dir_mode: 755
    - template: jinja
    - context:
      client_password: "{{ client_password }}"
      akara_url: "{{ pillar.get('akara_url', 'http://localhost:8881') }}"
      secret_key: "{{ pillar.get('secret_key', salt['cmd.run']('openssl rand -base64 64')) }}"
