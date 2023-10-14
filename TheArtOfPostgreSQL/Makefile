DUMP    = ./taop.dump
PG_LIST = ./exclude-extensions.list
DBNAME  = taop

all: restore

restore: createdb $(PG_LIST)
	pg_restore -U taop -d $(DBNAME) --use-list=$(PG_LIST) --no-owner $(DUMP)
	psql -U taop -d $(DBNAME) -f setup.sql

createdb:
	createuser -SDr taop
	createdb -O taop $(DBNAME)
	psql -d $(DBNAME) -c 'create extension btree_gist'
	psql -d $(DBNAME) -c 'create extension ip4r'
	psql -d $(DBNAME) -c 'create extension hll'
	psql -d $(DBNAME) -c 'create extension cube'
	psql -d $(DBNAME) -c 'create extension earthdistance'
	psql -d $(DBNAME) -c 'create extension hstore'
	psql -d $(DBNAME) -c 'create extension intarray'
	psql -d $(DBNAME) -c 'create extension pg_trgm'

dropdb:
	dropdb --if-exists $(DBNAME)
	dropuser --if-exists taop

$(PG_LIST): $(DUMP)
	pg_restore --list $(DUMP) | awk -f exclude-extensions.awk > $(PG_LIST)

.PHONY: all restore createdb dropdb
