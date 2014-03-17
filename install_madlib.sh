#!/bin/bash

# Install madlib
yum -y install http://bitcast-a.v1.o1.sjc1.bitgravity.com/greenplum/MADlib/files/madlib-1.4-Linux.rpm --nogpgcheck

# Register madlib to the database
/usr/local/madlib/bin/madpack -p postgres -c vagrant@localhost:5432/maddb install
