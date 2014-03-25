include:
  - viewshare.site
  - viewshare-dependencies

supervisor:
  pip.installed

celery==3.0:
  pip.installed

/etc/supervisor.d:
  file.directory:
    - user: root
    - group: adm
    - dir_mode: 755
    - makedirs: True

/var/log/supervisor:
  file.directory:
    - user: root
    - group: adm
    - dir_mode: 755
    - makedirs: True

/etc/supervisord.conf:
  file.managed:
    - source: salt://viewshare/supervisord.conf
    - user: root
    - group: adm
    - mode: 755

/etc/init.d/supervisor:
  file.managed:
    - source: salt://viewshare/supervisor
    - user: root
    - group: adm
    - mode: 755

/etc/default/supervisor:
  file.managed:
    - source: salt://viewshare/supervisor_default
    - user: root
    - group: adm
    - mode: 755

/srv/viewshare/shared/gunicorn_config.py:
  file.managed:
    - source: salt://viewshare/gunicorn_config.py
    - user: nobody
    - group: nogroup
    - mode: 755

/srv/viewshare/current/gunicorn_config.py:
  file.symlink:
    - target: /srv/viewshare/shared/gunicorn_config.py
    - require:
      - file: /srv/viewshare/shared/gunicorn_config.py

/etc/supervisor.d/viewshare.conf:
  file.managed:
    - source: salt://viewshare/viewshare.conf
    - user: root
    - group: adm
    - mode: 755

/etc/supervisor.d/viewshare-celeryd.conf:
  file.managed:
    - source: salt://viewshare/viewshare-celeryd.conf
    - user: root
    - group: adm
    - mode: 755

supervisor_service:
  service:
    - name: supervisor
    - running
    - enable: True
    - require:
      - file: /etc/init.d/supervisor
      - file: /etc/supervisor.d/viewshare.conf

supervisorctl_viewshare:
  supervisord:
    - name: viewshare
    - running
    - watch:
      - file: /etc/supervisor.d/viewshare.conf

supervisorctl_celeryd:
  supervisord:
    - name: viewshare-celeryd
    - running
    - watch:
      - file: /etc/supervisor.d/viewshare-celeryd.conf
    - require:
      - pip.installed: celery==3.0
