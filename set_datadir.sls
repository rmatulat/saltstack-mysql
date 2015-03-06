# Creates datadir at a different place and links mysql.config.sections.mysqld.datadir 
# (e.g. /var/lib/mysql) to it.
# Usefull if /var is just too small and you need to have the
# MySQL data at a different place

# WARNING: This is just doing the job on a fresh install!
# It will not move anything existing!
# This state is useless if you have already installed your mysql/mariadb server!

{% from "mysql/static/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}

{% if mysql.datadir.change_it == True  %}

{{ mysql.datadir.data_dir_custom }}:
  file.directory:
    - dir_mode: 755
    - makedirs: True

# will fail if the datadir already exists
{{ mysql.config.sections.mysqld.datadir }}:
  file.symlink:
    - target: {{ mysql.datadir.data_dir_custom }}

{% endif %}
