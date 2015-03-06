{% from "mysql/static/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}
{% set os_family = salt['grains.get']('os_family', None) %}
{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

{% if mysql_root_password %}
mysql_root_password:
{% if os_family == 'Debian' %}
  cmd.run:
    - name: mysql --defaults-file=/etc/mysql/debian.cnf -e "update mysql.user set Password=password('{{ mysql_root_password|replace("'", "'\"'\"'") }}') where User='root'; flush privileges;"
    - unless: mysql --user root --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute='SELECT 1;'
    - require:
      - service: {{ mysql.server }} 
{% elif os_family == 'RedHat' %}
  cmd.run:
    - name: mysqladmin --user root password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --user root --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute='SELECT 1;'
    - require:
      - service: {{ mysql.server }} 
{% endif %}
{% endif %}

include:
  - mysql.set_datadir
  - mysql.python

{{ mysql.server }}:
  pkg.installed:
    - name: {{ mysql.server }}
  service.running:
    - name: {{ mysql.service }}
    - enable: True
    - watch:
      - pkg: {{ mysql.server }} 
