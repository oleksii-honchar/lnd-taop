# The Art of PostgreSQL

Thanks for buying The Art of PostgreSQL! The edition you selected offers a
database dump of the datasets used in the book, allowing for easy replay of
the SQL queries.

This document shows how to restore the database. The core of it is as simple
as using the `pg_restore` command. The database has some dependencies
though…



## Restoring the PostgreSQL database

A `Makefile` is included to ease the process, so that you may run the
following command and be done. Of course, the command assumes that you have
a PostgreSQL instance reachable with the default connection parameters set
in the environment. Those are `PGHOST`, `PGUSER` and etc, as documented in
the `man psql` manual page.

Feel free to have a look at the `Makefile` and hack something around if for
some reasons it doesn't work as intended in your specific environment.

~~~ bash
make
~~~

A typical output looks like the following:

~~~
createuser -SDr taop
createdb -O taop taop
psql -d taop -c 'create extension btree_gist'
CREATE EXTENSION
psql -d taop -c 'create extension ip4r'
CREATE EXTENSION
psql -d taop -c 'create extension hll'
CREATE EXTENSION
psql -d taop -c 'create extension cube'
CREATE EXTENSION
psql -d taop -c 'create extension earthdistance'
CREATE EXTENSION
psql -d taop -c 'create extension hstore'
CREATE EXTENSION
psql -d taop -c 'create extension intarray'
CREATE EXTENSION
psql -d taop -c 'create extension pg_trgm'
CREATE EXTENSION
pg_restore -U taop -d taop --use-list=./exclude-extensions.list --no-owner ./taop.dump
psql -U taop -d taop -f setup.sql
BEGIN
ALTER DATABASE
CREATE ROLE
CREATE ROLE
ALTER ROLE
ALTER ROLE
COMMIT
~~~

The bundle ships with the `exclude-extensions.list` file, so that you won't
normally have the `pg_restore --list` line of output.

The `pg_restore --list` and `--use-list` options allow filtering SQL objects
from the dump that we don't want to restore. Here, we exclude extension
objects thanks to a very simple awk script.

PostgreSQL extensions can only be created by a superuser, and we use
pg_restore as the `taop` user, the owner of our `taop` database. It is
good practice that the owner of the database you're using is not a superuser
of your PostgreSQL instance.

So to avoid `pg_restore` time errors, we create the extension objects
previous to running the `pg_restore` command, as superusers, and then we
filter the commands out from the command thanks to the `--use-list` option.

If you have a CI/CD environment where you're restoring the most recent
nigthly production backup, this option may allow you to also filter out some
SQL objects that shouldn't be copied to the CI/CD environment, such as
production user credentials or other confidential information.

## psql configuration

You can install the `psqlrc` file to try it:

~~~
$ cp -i psqlrc ~/.psqlrc
~~~

## Conclusion

Your journey into *The Art of PostgreSQL* is now starting.

> _Knowledge is of no value unless you put it into practice._

> ***Anton Chekhov***

Writing code is fun. Have fun writing SQL!

