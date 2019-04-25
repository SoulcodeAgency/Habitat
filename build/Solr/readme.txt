To create a new docker container, please use the install script for your environment:
- Install.ps1 for Windows
- Install.sh for Mac/Linux

The install script starts your container with docker compose and afterwards sets up SSL and the needed cores. 
Currently both scripts have little difference in behaviour, but at the end fullfill the same goal.

# Windows
To create a new container, please just start the Script by ".\Install.ps1"
Optionally you can provide a parameter -Remove, to clean up existing containers and volumes and then recreate it.: ".\Install.ps1 -Remove"

If you execute the script and the container is already existing, you will see a lot of solr errors, because of core creation although they already exists.
Your container will still be working at the end

# Mac / Linux (linux not tested)
The script allways checks for existing container and volume, and if found, always will remove it and recreate it then.

# Running Instance
You'll find your solr on port 11985 in your browser. Because of certification handling, you should add "solr.bkb.local" to your hosts file (binding it to 127.0.0.1)
and finally call your solr instance with url https://solr.bkb.local:11985
This you then also can add to your sitecore connectionstring for solr.search connectionstring: https://solr.bkb.local:11985/solr

# Solr configuration notes
- Cert Pwd: secret

# Troubleshooting
If you get an error "/bin/bash^M: bad interpreter: No such file or directory" while running Install script on Mac, then you need to open Install script in editor and change line endings to UNIX (LF) style.
