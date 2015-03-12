# Creates and removes databases
# So be carefull about what you define in your pillars :-)

{% from "mysql/static/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}

{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set db_states = [] %}

include:
  - mysql.python

# Creating databases according to the pillar attributes of `database.present`.
# See examples
{% from "mysql/static/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:server:lookup')) %}
{% for database in salt['pillar.get']('mysql:database.present', []) %}
{% set state_id = 'mysql_db_' ~ loop.index0 %}
{{ state_id }}:
  mysql_database.present:
    - name: {{ database }}
    - host: localhost
    - connection_user: root
    {% if mysql_root_pass %}
    - connection_pass: '{{ mysql_root_pass }}'
    {% endif %}
    - connection_charset: utf8

{% if salt['pillar.get'](['mysql', 'schema', database, 'load']|join(':'), False) %}
{{ state_id }}_schema:
  file.managed:
    # Remember: The schema file has to have the same name as the database itself
    - name: {{ mysql.schema_root}}/{{ database }}.schema
    - source: {{ salt['pillar.get'](['mysql', 'schema', database, 'source']|join(':')) }}
    - user: {{ salt['pillar.get']('mysql:server:user', 'mysql') }}
    - makedirs: True

{{ state_id }}_load:
  cmd.wait:
    - name: mysql -u root -p{{ mysql_root_pass }} {{ database }} < {{ mysql.schema_root}}/{{ database }}.schema
    - watch:
      - file: {{ state_id }}_schema
      - mysql_database: {{ state_id }}
{% endif %}

{% do db_states.append(state_id) %}
{% endfor %}

# Removing databases according to the pillar attributes `database.absent`.
# See examples
{% for database in salt['pillar.get']('mysql:database.absent', []) %}
{% set state_id = 'mysql_db_remove' ~ loop.index0 %}
{{ state_id }}:
  mysql_database.absent:
    - name: {{ database }}
    - connection_user: root
    {% if mysql_root_pass %}
    - connection_pass: '{{ mysql_root_pass }}'
    {% endif %}
    - connection_charset: utf8

{% do db_states.append(state_id) %}
{% endfor %}
