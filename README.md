VODAbox
=======

Vagrant On-Database Analytics Sandbox

VODAbox combines a Scientific Linux virtual machine with PostgreSQL, PL/Python, PL/R, and MADlib to allow for extremely easy experimentation with on-database analytics.

Installation
------------

1. Download and install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Download and install [Vagrant](http://www.vagrantup.com/downloads.html)
3. Create a new folder on your computer to hold shared documents for VODAbox
4. `cd` to this directory and run `vagrant init`
5. Run `vagrant box add <VODAbox> http://lyte.id.au/vagrant/sl6-64-lyte.box`
6. Pull codes from this git repository into the new folder
7. Run `vagrant up`
8. Run `vagrant ssh`
9. Use something like [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) to log into your virtual machine with the ssh information given by the above
10. Within PuTTY `cd /vagrant` login as "su" (password = vagrant) and run `./finish_install.sh` then log-out of root
11. Start Postgres with the command `sudo service postgresql-9.2 start`
12. Run codes in examples using the command `psql -d maddb -f ` *filename.sql*

Overview
--------
A [presentation](https://docs.google.com/presentation/d/1e_AvTlDNRRE7_-gPVaJ7R2zJomSF1IHkzTa3gQ1ReYU/pub?start=false&loop=false&delayms=3000) on VODAbox given at the Champaign Urbana Database User Group on April 3rd, 2014.
