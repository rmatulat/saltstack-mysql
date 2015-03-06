# The minion needs a python mysql package to work properly with the mysql.<something> modules.
# For further information : http://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.mysql.html
{% from "mysql/static/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:server:lookup')) %}
{% set os_family = salt['grains.get']('os_family', None) %}

mysql_python:
  pkg.installed:
    - name: {{ mysql.python }}

/etc/salt/minion.d/mysql.conf:
{% if os_family == "Debian" %}
  file.managed:
    - source: salt://mysql/files/minion.debian.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: salt-minion 

{% else %}
  file.managed:
    - source: salt://mysql/files/minion.default.conf
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: salt-minion

{% endif %}

# After a change of the minion config we need a restart...
trigger_salt_minion_for_mysql:
  service.running:
    - name: salt-minion
