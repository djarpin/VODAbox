VODAbox
=======

Vagrant On-Database Analytics Sandbox

VODAbox combines PostgreSQL, PL/Python, PL/R, and MADlib to allow for extremely easy experimentation with on-database analytics.

Installation
------------

1. Download and install VirtualBox (https://www.virtualbox.org/wiki/Downloads)
2. Download and install Vagrant (http://www.vagrantup.com/downloads.html)
3. Create a new folder on your computer to hold shared documents for VODAbox
4. "cd" to this directory and run "vagrant init"
5. Run "vagrant box add db_sandbox http://lyte.id.au/vagrant/sl6-64-lyte.box"
6. Pull codes from this git repository into the new folder
7. Run "vagrant up"
8. Run "vagrant ssh"
9. Use something like PuTTY (http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) to log into your virtual machine with the ssh information given by the above
10. Within PuTTY "cd" to /vagrant and run "./finish_install.sh"
11. Start Postgres with the command "sudo service postgresql-9.2 start"
12. Run codes in examples using the command "psql -d maddb -f *sql_filename*"

Overview
--------
<LINK TO GOOGLE DOCS PRESENTATION>
