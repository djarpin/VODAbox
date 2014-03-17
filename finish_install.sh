#!/bin/bash

# Install PL/R
cd /usr/lib64/plr/plr
USE_PGXS=1 make
USE_PGXS=1 make install

# Create PL/R extension
cd /vagrant
service postgresql-9.2 restart
su postgres -c /vagrant/create_plr_extension.sh
