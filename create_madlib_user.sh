#!/bin/bash

# Create a user and database
psql template1 -f /vagrant/create_madlib_user.sql
