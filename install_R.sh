#!/bin/bash

# Link to the EPEL repository
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Install R
yum -y install R

# Setup PL/R dependencies
yum -y install wget
ln -s /usr/pgsql-9.2/bin/pg_config /usr/local/bin/

# Create PL/R directory
mkdir /usr/lib64/plr
cd /usr/lib64/plr

# Download and extract PL/R
wget http://www.joeconway.com/plr/plr-8.3.0.15.tar.gz
tar -zxf plr-8.3.0.15.tar.gz
