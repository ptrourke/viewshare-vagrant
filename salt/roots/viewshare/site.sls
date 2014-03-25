include:
  - viewshare.database
  - viewshare-dependencies

{% set root_password, client_password, replication_password = salt['cmd.run']('cat /etc/mysql/saltstore').split() %}
{% set rabbitmq_user_pass = pillar.get('rabbitmq_user_pass', salt['cmd.run']('openssl rand -base64 12')) %}

rabbitmq_viewshare_vhost:
  rabbitmq_vhost.present:
    - name: viewshare

rabbitmq_viewshare_user:
  rabbitmq_user.present:
    - name: viewshare_user
    - password: {{ rabbitmq_user_pass }}
    - perms:
      - '/viewshare':
        - '.*'
        - '.*'
        - '.*'
    - require:
      - rabbitmq_vhost: rabbitmq_viewshare_vhost

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
    - name: https://github.com/wamberg/viewshare_site.git
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
      smtp_host: "{{ pillar.get('smtp_host', '') }}"
      smtp_user: "{{ pillar.get('smtp_user', '') }}"
      smtp_password: "{{ pillar.get('smtp_password', '') }}"
      uservoice_account_key: "{{ pillar.get('uservoice_account_key', '') }}"
      uservoice_sso_key: "{{ pillar.get('uservoice_sso_key', '') }}"

/srv/viewshare/shared/celeryconfig.py:
  file.managed:
    - source: salt://viewshare/celeryconfig.py
    - user: nobody
    - group: nogroup
    - dir_mode: 755
    - template: jinja
    - context:
      rabbitmq_user_pass: "{{ rabbitmq_user_pass }}"

/srv/viewshare/current/viewshare_site_settings.py:
  file.symlink:
    - target: /srv/viewshare/shared/viewshare_site_settings.py
    - require:
      - file: /srv/viewshare/shared/viewshare_site_settings.py

/srv/viewshare/current/celeryconfig.py:
  file.symlink:
    - target: /srv/viewshare/shared/celeryconfig.py
    - require:
      - file: /srv/viewshare/shared/celeryconfig.py

django.syncdb:
  module.run:
    - settings_module: viewshare_site.settings
    - bin_env: /srv/viewshare/shared/env/bin/django-admin.py
    - env: /srv/viewshare/shared/env
    - pythonpath: /srv/viewshare/current
    - migrate: true
    - require:
      - file: /srv/viewshare/current/viewshare_site_settings.py
      - file: /srv/viewshare/current/celeryconfig.py
