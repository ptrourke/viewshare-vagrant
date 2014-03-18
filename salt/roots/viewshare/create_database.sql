CREATE DATABASE viewshare CHARACTER SET utf8 COLLATE utf8_bin;
GRANT ALL PRIVILEGES ON viewshare.* TO viewshare@localhost IDENTIFIED BY '{{ client_password }}';
FLUSH PRIVILEGES;
