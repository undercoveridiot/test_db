# test_db
A sample database with an integrated test suite, used to test your applications and database servers

This repository was migrated from [Launchpad](https://launchpad.net/test-db).

Originally written for MySQL, it has been ported to psql for testing in PostgreSQL.  Tested with PostgreSQL 9.3, but should work with all 9.x.


## Where it comes from

The original data was created by Fusheng Wang and Carlo Zaniolo at 
Siemens Corporate Research. The data is in XML format.
http://timecenter.cs.aau.dk/software.htm

Giuseppe Maxia made the relational schema and Patrick Crews exported
the data in relational format.

The database contains about 300,000 employee records with 2.8 million 
salary entries. The export data is 167 MB, which is not huge, but
heavy enough to be non-trivial for testing.

The data was generated, and as such there are inconsistencies and subtle
problems. Rather than removing them, we decided to leave the contents
untouched, and use these issues as data cleaning exercises.


## Installation:

To install the database, download the repository and change directory to the repository.

    $ sudo su postgres
    $ psql < employees.sql

The database and all related objects will be owned by the postgres user.  If you need to change ownership of the database and all tables use the following commands, replacing 'newowner' with the username to change ownership to:

    $ sudo su postgres
    $ psql -d employees
    employees=# DO $$DECLARE r record;
                  BEGIN
                      FOR r IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
                      LOOP
                          EXECUTE 'ALTER TABLE '|| r.tablename ||' OWNER TO newowner;';
                    END LOOP;
                END$$;
    employees=# ALTER DATABASE employees OWNER TO newowner;
    employees=# \d
    employees=# \l



## DISCLAIMER

To the best of my knowledge, this data is fabricated, and
it does not correspond to real people. 
Any similarity to existing people is purely coincidental.


## LICENSE
This work is licensed under the 
Creative Commons Attribution-Share Alike 3.0 Unported License. 
To view a copy of this license, visit 
http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to 
Creative Commons, 171 Second Street, Suite 300, San Francisco, 
California, 94105, USA.
