# saltstack-mysql
Install the MySQL client and/or server.
This also applies for an MariaDB installation.

See the full [Salt Formulas installation and usage instructions](http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html).

Most behavior of this state collection can be modified using pillars. 

# Examples
For pillar examples take a look at the `example` directory.

# Avaible states

## `mysql`

Meta-state that includes all server packages in the correct order.
It will first try to configure a custom repository (if set to True in a pillar), then install 
the software itself followed by doing the configuration of the `my.cnf`.

## `mysql.server`

This will install the MySQL/MariaDB server (and creates an alternative `datadir` if needed),
sets an initial `root` password and installs and configures the needed python package and salt-minion config).

## `mysql_config`

This will (re-)build the `my.cnf`.
Usefull if you have changed the pillar data.

## `mysql.set_datadir` (private)

Do not call it directly! It's just needed while doing the server installation!

## `mysql.repo_config` (private)

This is not working for itself - but it's called in `state.highstate`.

## `mysql.users`

It creates users who should be present and removes those who should be absent.

## `mysql.database`

Same as `mysql.users` but for databases.
Take a look at the examples.

# Note

The static, default yaml files have been moved to the `static` directory to keep the `.sls` files together and
make `ls -l` a little bit less messy.
