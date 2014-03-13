include:
  - viewshare-dependencies

/etc/memcached.conf:
  file.managed:
    - source: salt://memcached/memcached.conf
    - mode: 644

memcached_rsyslog:
  service:
    - name: rsyslog
    - running
    - reload: True
    - watch:
      - file: /etc/memcached.conf
