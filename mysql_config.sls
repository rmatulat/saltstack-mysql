# Creates a my.cnf with a bunch of key: value pairs in your pillar.
# Just take a look at the pillar.example
{% from "mysql/static/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}
{% set os_family = salt['grains.get']('os_family', None) %}

mysqld:
  service.running:
    - name: {{ mysql.service }}

mysql_config:
  file.managed:
    - name: {{ mysql.config.file }}
    - template: jinja
    - source: salt://mysql/files/my.cnf
    - backup: minion
    - watch_in:
      - service: {{ mysql.service }}
{% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 644
{% endif %}
