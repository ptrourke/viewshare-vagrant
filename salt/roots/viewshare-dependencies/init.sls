system_dependencies:
  pkg.installed:
    - names:
      - autoconf
      - binutils-doc
      - bison
      - build-essential
      - csstidy
      - erlang
      - erlang-dev
      - flex
      - git-core
      - libmemcache-dev
      - libmysqlclient-dev
      - locales
      - nginx
      - nginx-full
      - memcached
      - mysql-server
      - mysql-client
      - python
      - python-dev
      - python-software-properties
      - rabbitmq-server
      - util-linux

nodejs_repo:
  pkgrepo.managed:
    - humanname: NodeJS Repo
    - name: ppa:chris-lea/node.js
    - dist: trusty
    - file: /etc/apt/sources.list.d/nodejs.list
    - keyid: C7917B12
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: nodejs

nodejs:
  pkg.installed

pip_install:
  cmd.run:
    - name: wget https://raw.github.com/pypa/pip/master/contrib/get-pip.py -O - | sudo python
    - unless: which pip

virtualenv_install:
  cmd.wait:
    - name: pip install virtualenv
    - unless: which virtualenv
    - watch:
      - cmd: pip_install

en_US.UTF-8:
  locale.system
