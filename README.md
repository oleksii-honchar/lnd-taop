# lnd-taop

## Prerequisites

- you need `psql` cli tool

```bash
brew install postgresql
```

- copy `project.env.dist` -> `projecy.env` and fill the vars
- `make restart` to laucng PG container

## How to use

### pgAdmin

- db connection host: `127.0.0.1`

### chinook DB

Download Chinook_PostgreSql.sql from [github](https://github.com/lerocha/chinook-database/blob/master/ChinookDatabase/DataSources/Chinook_PostgreSql.sql)

```bash
make restart
make create-user usr=taop
make create-db db=chinook usr=taop
make psql db=chinook
(psql)chinook=# \i TAOP/data/cdstore/Chinook_PostgreSql.sql
```

- to try Stored Procedure example:

 ```bash
 make psql db=chinook
 (psql)chinook=# \i TAOP/data/cdstore/sql/get_all_albums.sql
 (psql)chinook=# select * from get_all_albums(127);
 ```

### factbook section

Connect and import data

```bash
make psql # and wait...it can take ~1min to run the command
=# \i ./TAOP/data/factbook/factbook.sql
```

Run month data report

```bash
=# \i ./TAOP/data/factbook/month-data.sql
```