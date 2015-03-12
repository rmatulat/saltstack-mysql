# This is an example!
mysql:
  server:
    # root_password: False - to have root@localhost without password
    root_password: 'somepass'
    user: mysql
    # my.cnf sections changes 
    mysqld:
      # you can use either underscore or hyphen in param names
      bind-address: 0.0.0.0
      log_bin: /var/log/mysql/mysql-bin.log
      port: 3307
      binlog_do_db: foo
      auto_increment_increment: 5
      log_slow_verbosity: query_plan
      innodb_buffer_pool_size: 256M
      innodb_log_buffer_size: 8M
      innodb_file_per_table: 1
      innodb_open_files: 400
      innodb_io_capacity: 400
    mysql:
      # my.cnf param that not require value
      no-auto-rehash: noarg_present

  # Manage databases
  database.present:
    - foo
    - bar
  schema:
    foo:
      load: True
      source: salt://mysql/files/foo.schema
    bar:
      load: False

  # We want to remove the `test` Database.
  database.absent:
    - test

  # Manage users
  # you can get pillar for existent server using scripts/import_users.py script
  user.present:
    frank:
      password: 'somepass'
      host: localhost
      databases:
        - database: foo
          grants: ['select', 'insert', 'update']
        - database: bar
          grants: ['all privileges']
    bob:
      password_hash: '*6C8989366EAF75BB670AD8EA7A7FC1176A95CEF4'
      host: localhost
      databases:
        - database: foo
          grants: ['all privileges']
          grant_option: True
        - database: bar
          table: foobar
          grants: ['select', 'insert', 'update', 'delete']
    nopassuser:
      password: ~
      host: localhost
      databases: []

  user.absent:
    john:
      host: localhost
    jane:
      host: localhost

  # Override any names defined in defaults.yaml
  lookup:
    server: mysql-server
    # state manages the repository - see defaults.yaml
    repository:
      manage_repository: True
    # change place of datadir - see defaults.yaml
    datadir:
      change_it: True
      data_dir_custom: /your/custom/path
    client: mysql-client
    service: mysql-service
    python: python-mysqldb
