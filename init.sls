# It all begins here!
{% from "mysql/static/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}

include:
  - mysql.repo_config
  - mysql.server
  - mysql.mysql_config
