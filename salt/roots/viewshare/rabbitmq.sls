include:
  - viewshare-dependencies

rabbitmq_viewshare_vhost:
  rabbitmq_vhost.present:
    - name: viewshare

rabbitmq_viewshare_user:
  rabbitmq_user.present:
    - name: viewshare_user
    - perms:
      - '/viewshare':
        - '.*'
        - '.*'
        - '.*'
    - require:
      - rabbitmq_vhost: rabbitmq_viewshare_vhost
