#!/bin/bash

# Install 64 bit Postgres 9.2, including plpython
rpm -i http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-sl92-9.2-8.noarch.rpm
yum -y install postgresql92 postgresql92-server postgresql92-contrib postgresql92-devel postgresql92-plpython postgresql92-plperl postgresql92-devel

# Initialize the Postgres service
service postgresql-9.2 initdb
service postgresql-9.2 start

# Login through root as postgres and run script to create a user and database
su postgres -c /vagrant/create_madlib_user.sh

# Change conf file
cp /var/lib/pgsql/9.2/data/pg_hba.conf /var/lib/pgsql/9.2/data/pg_hba.r1.conf
cp /vagrant/pg_hba.conf /var/lib/pgsql/9.2/data/pg_hba.conf

# Restart the database
service postgresql-9.2 restart
