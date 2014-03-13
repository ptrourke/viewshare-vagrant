system_dependencies:
  pkg.installed:
    - names:
      - git-core
      - python
      - python-dev
      - locales
      - build-essenential
      - binutils-doc
      - autoconf
      - flex
      - bison
      - mysql-server
      - mysql-client
      - libmysqlclient-dev
      - nginx
      - nginx-full
      - memcached
      - libmemcache-dev
      - erlang
      - erlang-dev
      - util-linux
      - rabbitmq-server
      - csstidy
      - python-software-properties

nodejs_repo:
  pkgrepo.managed:
    - humanname: NodeJS Repo
    - name: ppa:chris-lea/node.js
    - dist: raring
    - file: /etc/apt/sources.list.d/nodejs.list
    - keyid: C7917B12
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: nodejs

nodejs:
  pkg.installed
