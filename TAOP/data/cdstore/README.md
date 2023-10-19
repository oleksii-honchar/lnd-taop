# cdstore

The *cdstore* application is a very simple wrapper on top of
the [Chinook](https://github.com/lerocha/chinook-database) database. The
Chinook data model represents a digital media store, including tables for
artists, albums, media tracks, invoices and customers.

The *cdstore* application allows to list useful information and reports on
top of the database, and also provides a way to generate some activity.

## How to start

In repo root folder execute commands:

~~~ shell
virtualenv .venv
source ./.venv/bin/activate
which python
# check if python referenced to ./.venv folder
pip install -r ./src/requirements.txt
~~~

It will activate root folder venv

Change VSCode python env by selecting python repo root interpreter path. It will work for any script until you call it from repo root folder. And imports will work from `.venv`. 

### Get data

SQLite

~~~ shell
curl -L -O https://raw.githubusercontent.com/lerocha/chinook-database/master/ChinookDatabase/DataSources/Chinook_PostgreSql.sql
~~~

PostgreSQL

~~~shell

~~~

[TBD] import data

### Launch PostgreSQL

From repo root folder call

~~~shell
make up svc=db
~~~

## How to use

Test if imports from venv works. Call from repo root:

~~~shell
make py-cdstore file=test-wget.py
~~~

~~~shell
make py-cdstore file="./src/cdstore.py genres"

               Genre | Count
---------------------+------
                Rock | 1297
               Latin | 579
               Metal | 374
  Alternative & Punk | 332
                Jazz | 130
            TV Shows | 93
               Blues | 81
           Classical | 74
               Drama | 64
            R&B/Soul | 61
              Reggae | 58
                 Pop | 48
          Soundtrack | 43
         Alternative | 40
         Hip Hop/Rap | 35
   Electronica/Dance | 30
         Heavy Metal | 28
               World | 28
    Sci Fi & Fantasy | 26
      Easy Listening | 24
              Comedy | 17
          Bossa Nova | 15
     Science Fiction | 13
       Rock And Roll | 12
               Opera | 1
~~~
