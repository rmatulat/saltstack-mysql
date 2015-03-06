# Doing all the dirty 'add an apt repo' stuff.
# Fails if the server is behind a proxy because of gpgkeys.
# You may work around if you add the key manually via apt-key by doing an
# export http_proxy="{your.proxy:8000}"
{% from "mysql/static/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}

{% if mysql.repository.manage_repository == True  %}

managed_mysql_repo:
  pkgrepo.managed:
    - humanname: {{ mysql.repository.humanname }} 
    - name: {{ mysql.repository.name }} 
    - dist: {{ mysql.repository.dist }} 
    - file: {{ mysql.repository.file }} 
    - keyid: '{{ mysql.repository.keyid }}'
    - keyserver: {{ mysql.repository.keyserver }}
    - require_in:
      - pkg: {{ mysql.server }} 

{% endif %}
