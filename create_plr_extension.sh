#!/bin/bash

# Create PL/R extension
psql template1 -f /vagrant/create_plr_extension.sql
psql maddb -f /vagrant/create_plr_extension.sql
